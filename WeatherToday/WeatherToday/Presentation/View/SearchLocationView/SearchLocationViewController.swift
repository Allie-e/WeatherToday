//
//  SearchLocationViewController.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/29.
//

import UIKit

class SearchLocationViewController: UIViewController {
    private enum Section: CaseIterable {
        case location
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "날씨"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "도시 또는 공항 검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.layer.cornerRadius = 20
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        searchController.searchBar.tintColor = .label
        
        return searchController
    }()
    
    private let locationListView = LocationListView()
    private var dataSource: UITableViewDiffableDataSource<Section, CurrentWeather>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, CurrentWeather>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUpSearchController()
        addSubviews()
        setupLayout()
        registerTableViewCell()
        setupDataSource()
    }
    
    private func setupNavigationBar() {
        let filterImage = UIImage(systemName: "ellipsis.circle")
        let filterButton = UIBarButtonItem(image: filterImage,
                                           style: .plain,
                                           target: self,
                                           action: nil)
        filterButton.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = filterButton
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(locationListView)
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        locationListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func registerTableViewCell() {
        locationListView.register(LocationListTableViewCell.self, forCellReuseIdentifier: "LocationListTableViewCell")
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, CurrentWeather>(tableView: locationListView, cellProvider: { (tableView, indexPath, item) -> LocationListTableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListTableViewCell", for: indexPath) as? LocationListTableViewCell else {
                return LocationListTableViewCell()
            }
            cell.setupLocationListCell(with: item)
            
            return cell
        })
        locationListView.dataSource = dataSource
    }
    
    private func applySnapShot(with weather: [CurrentWeather]) {
        snapshot.appendSections([.location])
        snapshot.appendItems(weather, toSection: .location)
        snapshot.reloadItems(weather)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension SearchLocationViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }
}
