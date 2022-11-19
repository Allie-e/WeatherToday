//
//  ViewController.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/19.
//

import UIKit
import CoreLocation
import RxSwift

class ViewController: UIViewController {
    private enum Section {
        case hourly
        case daily
    }
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    let currentWeatherView = CurrentWeatherView()
    let hourlyWeatherCollectionView: UICollectionView = {
        let layout = setupHourlyCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    let dailyWeatherCollectionView: UICollectionView = {
        let layout = setupDailyCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    private var hourlyDataSource: UICollectionViewDiffableDataSource<Section, HourlyWeather>?
    private var dailyDataSource: UICollectionViewDiffableDataSource<Section, DailyWeather>?
    
    let viewModel = CurrentWeatherViewModel()
    let loadLocationObservable: PublishSubject<Coordinate> = .init()
    let disposeBag: DisposeBag = .init()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerLayer()
        addSubviews()
        setupCurrentWeatherViewLayout()
        registerCollectionViewCell()
        setupCollectionViewDataSource()
        setupLocationManager()
        bind()
    }
    
    private func bind() {
        let location = locationManager.rx.didUpdateLocations
        let input = CurrentWeatherViewModel.Input(loadLocation: location)
        let output = viewModel.transform(input)
        
        output.loadCurrentWeather
            .subscribe(onNext: { weather in
                guard let weather = weather else { return }
                self.currentWeatherView.setupLabelText(with: weather)
            })
            .disposed(by: disposeBag)
        
        output.loadHourlyWeather
            .subscribe(onNext: { weather in
                guard let weather = weather else { return }
                self.applyHourlySnapshot(with: weather)
            })
            .disposed(by: disposeBag)
        
        output.loadDailyWeather
            .subscribe(onNext: { weather in
                guard let weather = weather else { return }
                self.applyDailySnapshot(with: weather)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func addSubviews() {
        view.addSubview(mainStackView)
        [currentWeatherView, hourlyWeatherCollectionView, dailyWeatherCollectionView].forEach { view in
            mainStackView.addArrangedSubview(view)
        }
    }
    
    private func setupCurrentWeatherViewLayout() {
        mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupViewControllerLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let colors = [
            UIColor(red: 93/255, green: 140/255, blue: 210/255, alpha: 1.0).cgColor,
            UIColor(red: 138/255, green: 217/255, blue: 237/255, alpha: 1.0).cgColor,
            UIColor(red: 186/255, green: 238/255, blue: 251/255, alpha: 1.0).cgColor
        ]
        
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Setup CollectionView
    static func setupHourlyCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    static func setupDailyCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func registerCollectionViewCell() {
        hourlyWeatherCollectionView.register(HourlyWeatherCollectionViewCell.self)
        dailyWeatherCollectionView.register(DailyWeatherCollectionViewCell.self)
    }
    
    private func setupCollectionViewDataSource() {
        hourlyDataSource = UICollectionViewDiffableDataSource<Section, HourlyWeather>(collectionView: hourlyWeatherCollectionView, cellProvider: { (collectionView, indexPath, weather) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell( HourlyWeatherCollectionViewCell.self, for: indexPath) else {
                return HourlyWeatherCollectionViewCell()
            }
            cell.setupHourlyForecastCell(with: weather)
            
            return cell
        })
        
        dailyDataSource = UICollectionViewDiffableDataSource<Section, DailyWeather>(collectionView: dailyWeatherCollectionView, cellProvider: { (collectionView, indexPath, weather) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell( DailyWeatherCollectionViewCell.self, for: indexPath) else {
                return DailyWeatherCollectionViewCell()
            }
            cell.setupDailyForecastCell(with: weather)
            
            return cell
        })
    }
    
    private func applyHourlySnapshot(with weather: [HourlyWeather]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, HourlyWeather>()
        snapshot.appendSections([.hourly])
        snapshot.appendItems(weather, toSection: .hourly)
        snapshot.reloadItems(weather)
        hourlyDataSource?.apply(snapshot)
    }
    
    private func applyDailySnapshot(with weather: [DailyWeather]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DailyWeather>()
        snapshot.appendSections([.daily])
        snapshot.appendItems(weather, toSection: .daily)
        snapshot.reloadItems(weather)
        dailyDataSource?.apply(snapshot)
    }
}
