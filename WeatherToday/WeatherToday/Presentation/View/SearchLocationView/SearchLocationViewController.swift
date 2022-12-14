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
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "검색"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private let searchListTableView: UITableView = {
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
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var placeMark: MKPlacemark?
    var relay = PublishRelay<[MKLocalSearchCompletion]>()
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupLayout()
        setupSearchCompleter()
        setTableViewDelegateAndDataSource()
        setupNavigationBar()
        registerTableViewCell()
        bindSearchController()
    }
    
    private func bindSearchController() {
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { _, searchText in
                if searchText == "" {
                    self.searchResults.removeAll()
                    self.searchListTableView.reloadData()
                }
                self.searchCompleter.queryFragment = searchText
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func initView() {
        view.addSubview(searchListTableView)
    }
    
    private func setupSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    private func setTableViewDelegateAndDataSource() {
        searchListTableView.dataSource = self
        searchListTableView.delegate = self
    }
    
    private func registerTableViewCell() {
        searchListTableView.register(SearchLocationTableViewCell.self, forCellReuseIdentifier: "SearchListTableViewCell")
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.searchTextField.textColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupLayout() {
        searchListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchListTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension SearchLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchListTableView.dequeueReusableCell(withIdentifier: "SearchListTableViewCell", for: indexPath) as? SearchLocationTableViewCell else {
            return SearchLocationTableViewCell()
        }
        let searchResult = searchResults[indexPath.row].title
        cell.setupCell(with: searchResult)
        cell.selectionStyle = .none

        return cell
    }
}

extension SearchLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
