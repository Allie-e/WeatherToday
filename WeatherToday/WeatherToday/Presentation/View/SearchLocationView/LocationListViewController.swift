//
//  SearchLocationViewController.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/29.
//

import UIKit
import RxSwift
import CoreLocation

class LocationListViewController: UIViewController {
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
    
    private let locationListView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Section, CurrentWeather>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, CurrentWeather>()
    
    let viewModel = LocationListViewModel()
    let loadLocationObservable: PublishSubject<Coordinate> = .init()
    let disposeBag: DisposeBag = .init()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        initView()
        setupLayout()
        registerTableViewCell()
        setupDataSource()
        setupLocationManager()
        bind()
    }
    
    private func initView() {
        view.backgroundColor = .black
        view.addSubview(locationListView)
    }
    
    private func bind() {
        let location = locationManager.rx.didUpdateLocations
        let input = LocationListViewModel.Input(loadLocation: location)
        let output = viewModel.transform(input)
        
        output.loadCurrentWeather
            .subscribe(onNext: { weather in
                guard let weather = weather else { return }
                self.applySnapShot(with: weather)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupNavigationBar() {
        let searchImage = UIImage(systemName: "magnifyingglass")
        let searchButton = UIBarButtonItem(image: searchImage,
                                           style: .plain,
                                           target: self,
                                           action: nil)
        searchButton.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupLayout() {
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
    
    private func applySnapShot(with weather: CurrentWeather) {
        snapshot = NSDiffableDataSourceSnapshot<Section, CurrentWeather>()
        snapshot.appendSections([.location])
        snapshot.appendItems([weather], toSection: .location)
        snapshot.reloadItems([weather])
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
