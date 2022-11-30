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
        
        return label
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "도시 또는 공항 검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.layer.cornerRadius = 20
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        
        return searchController
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let filterImage = UIImage(systemName: "ellipsis.circle")
        let filterButton = UIBarButtonItem(image: filterImage,
                                           style: .plain,
                                           target: self,
                                           action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = filterButton
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}
