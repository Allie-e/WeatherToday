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
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private let disposeBag: DisposeBag = .init()
    
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
            .subscribe(onNext: { _, searchText in
                if searchText == "" {
                    self.searchResults.removeAll()
                    self.searchLocationTableView.reloadData()
                }
                self.searchCompleter.queryFragment = searchText
                self.applySnapShot(with: self.searchResults)
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
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.showAlert(title: "새로운 도시를 추가 하시겠습니까?")
            })
            .disposed(by: disposeBag)
    }
    
    private func searchLocation(with indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        search.start { reponse, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            guard let placeMark = reponse?.mapItems[0].placemark else {
                return
            }
            let coordinate = Coordinate(latitude: placeMark.coordinate.latitude, longitude: placeMark.coordinate.longitude)
        }
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
    
    private func applySnapShot(with weather: [MKLocalSearchCompletion]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MKLocalSearchCompletion>()
        snapshot.appendSections([.location])
        snapshot.appendItems(weather, toSection: .location)
        snapshot.reloadItems(weather)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func showAlert(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchLocationTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
