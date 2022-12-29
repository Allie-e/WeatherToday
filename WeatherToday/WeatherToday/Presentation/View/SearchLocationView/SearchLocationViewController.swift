//
//  SearchLocationViewController.swift
//  WeatherToday
//
//  Created by Allie on 2022/12/10.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class SearchLocationViewController: UIViewController {
    private enum Section: CaseIterable {
        case location
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "검색"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private let searchLocationTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .black
        
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "도시 또는 공항 검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.layer.cornerRadius = 20
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        searchController.searchBar.tintColor = .white
        searchController.searchBar.becomeFirstResponder()
        
        return searchController
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Section, MKLocalSearchCompletion>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, MKLocalSearchCompletion>()
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private let disposeBag: DisposeBag = .init()
    var coordinateRelay: PublishRelay<Coordinate>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSearchController()
        bindTableView()
        initView()
        setupNavigationBar()
        setupLayout()
        setupSearchCompleter()
        registerTableViewCell()
        setupDataSource()
    }
    
    private func bindSearchController() {
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .debounce(.milliseconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { owner, searchText in
                owner.searchCompleter.queryFragment = searchText
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        searchLocationTableView.rx.itemSelected
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .flatMap({ owner, indexPath in
                owner.searchLocation(with: indexPath)
            })
            .subscribe(onNext: { indexPath in
                self.showAlert(title: "새로운 도시를 추가 하시겠습니까?", location: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    private func initView() {
        view.addSubview(searchLocationTableView)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.searchTextField.textColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupLayout() {
        searchLocationTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        searchCompleter.region = searchRegion
    }
    
    private func registerTableViewCell() {
        searchLocationTableView.register(SearchLocationTableViewCell.self, forCellReuseIdentifier: "SearchLocationTableViewCell")
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, MKLocalSearchCompletion>(tableView: searchLocationTableView, cellProvider: { (tableView, indexPath, item) -> SearchLocationTableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationTableViewCell", for: indexPath) as? SearchLocationTableViewCell else {
                return SearchLocationTableViewCell()
            }
            cell.setupCell(with: item.title)
            
            return cell
        })
        searchLocationTableView.dataSource = dataSource
    }
    
    private func applySnapShot(with location: [MKLocalSearchCompletion]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MKLocalSearchCompletion>()
        snapshot.appendSections([.location])
        snapshot.appendItems(location, toSection: .location)
        snapshot.reloadItems(location)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func showAlert(title: String, message: String? = nil, location: Coordinate?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let location = location else {
                return
            }
            self.coordinateRelay?.accept(location)
            self.presentingViewController?.dismiss(animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func searchLocation(with indexPath: IndexPath) -> Observable<Coordinate?> {
        return Observable.create { emitter in
            let selectedResult = self.searchResults[indexPath.row]
            let searchRequest = MKLocalSearch.Request(completion: selectedResult)
            let search = MKLocalSearch(request: searchRequest)
            var coordinate: Coordinate?
            search.start { reponse, error in
                guard error == nil else { return }
                guard let placeMark = reponse?.mapItems[0].placemark else { return }
                
                coordinate = Coordinate(latitude: placeMark.coordinate.latitude, longitude: placeMark.coordinate.longitude)
                
                emitter.onNext(coordinate)
            }
            
            return Disposables.create()
        }
    }
}

extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        applySnapShot(with: searchResults)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
