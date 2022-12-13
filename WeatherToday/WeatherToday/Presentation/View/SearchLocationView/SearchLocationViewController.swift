//
//  SearchLocationViewController.swift
//  WeatherToday
//
//  Created by Allie on 2022/12/10.
//

import UIKit

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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupLayout()
        setupNavigationBar()
        registerTableViewCell()
    }
    
    private func initView() {
        view.addSubview(searchListTableView)
    }
    
    private func registerTableViewCell() {
        searchListTableView.register(SearchListTableViewCell.self, forCellReuseIdentifier: "SearchListTableViewCell")
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
