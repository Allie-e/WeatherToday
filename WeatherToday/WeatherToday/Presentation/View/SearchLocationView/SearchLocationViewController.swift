//
//  SearchLocationViewController.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/29.
//

import UIKit

class SearchLocationViewController: UIViewController {
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setUpSearchController()
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
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
}

extension SearchLocationViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }
}
