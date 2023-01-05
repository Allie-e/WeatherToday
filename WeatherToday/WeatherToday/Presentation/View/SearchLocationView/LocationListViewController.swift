//
//  SearchLocationViewController.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/29.
//

import UIKit
import RxSwift
import CoreLocation
import RxRelay

class LocationListViewController: UIViewController {
    private typealias DiffableDataSource = UITableViewDiffableDataSource<Section, CurrentWeather>
    
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
    
    private let searchButton: UIBarButtonItem = {
        let searchImage = UIImage(systemName: "magnifyingglass")
        let button = UIBarButtonItem(image: searchImage,
                                     style: .plain,
                                     target: self,
                                     action: nil)
        button.tintColor = .white
        
        return button
    }()
    
    private var dataSource: DiffableDataSource?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, CurrentWeather>()
    
    var selectCellAction: ((Coordinate) -> Void)?
    var locationManager: CLLocationManager!

    let viewModel = LocationListViewModel()
    let disposeBag: DisposeBag = .init()
    let coordinateRelay: PublishRelay<Coordinate> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addSubviews()
        setupLayout()
        setupNavigationBar()
        setupLocationManager()
        registerTableViewCell()
        setupDataSource()
        bind()
        bindSearchButton()
        bindTableView()
    }
    
    private func initView() {
        view.backgroundColor = .black
    }
    
    private func addSubviews() {
        view.addSubview(locationListView)
    }
    
    private func setupLayout() {
        locationListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
        
    private func bind() {
        let location = locationManager.rx.didUpdateLocations
        let input = LocationListViewModel.Input(loadLocation: location, addNewLocation: coordinateRelay.asObservable())
        let output = viewModel.transform(input)
        
        output.loadCurrentWeather
            .withUnretained(self)
            .subscribe(onNext: { _, weather in
                self.applySnapShot(with: weather)
            })
            .disposed(by: disposeBag)
        
        output.addNewWeather
            .withUnretained(self)
            .subscribe(onNext: { _, weather in
                self.applySnapShot(with: weather)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSearchButton() {
        searchButton.rx.tap
            .withUnretained(self)
            .bind { _ in 
                let searchVC = SearchLocationViewController()
                searchVC.coordinateRelay = self.coordinateRelay
                let searchNavigationController = UINavigationController(rootViewController: searchVC)
                searchNavigationController.modalPresentationStyle = .fullScreen
                self.present(searchNavigationController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        locationListView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let coordinate = owner.viewModel.currentWeathers[indexPath.row].coord
                owner.selectCellAction?(coordinate)
                owner.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func registerTableViewCell() {
        locationListView.register(LocationListTableViewCell.self, forCellReuseIdentifier: "LocationListTableViewCell")
    }
    
    private func setupDataSource() {
        dataSource = DiffableDataSource(tableView: locationListView, cellProvider: { (tableView, indexPath, item) -> LocationListTableViewCell in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListTableViewCell", for: indexPath) as? LocationListTableViewCell else {
                    return LocationListTableViewCell()
                }
                cell.setupLocationListCell(with: item)
                
                return cell
            }
        )
        locationListView.dataSource = dataSource
    }
    
    private func applySnapShot(with weather: [CurrentWeather]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CurrentWeather>()
        snapshot.appendSections([.location])
        snapshot.appendItems(weather)
        snapshot.reloadItems(weather)
        dataSource?.apply(snapshot)
    }
}
