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
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, WeatherItem>
    
    private enum WeatherItem: Hashable {
        case hourly(HourlyWeather)
        case daily(DailyWeather)
    }
    
    private enum Section: Int {
        case hourly
        case daily
        
        
        var column: Int {
            switch self {
            case .hourly:
                return 4
                
            case .daily:
                return 1
            }
        }
        
        func orthogonalScrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .hourly:
                return .continuous
            case .daily:
                return .none
            }
        }
    }
    
    private let currentWeatherView = CurrentWeatherView()
    private var forecastCollectionView: UICollectionView!
    private var dataSource: DiffableDataSource?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherItem>()
    
    let viewModel = CurrentWeatherViewModel()
    let loadLocationObservable: PublishSubject<Coordinate> = .init()
    let disposeBag: DisposeBag = .init()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerLayer()
        setupCollectionView()
        registerCollectionViewCell()
        addSubviews()
        setupDataSource()
        setupCurrentWeatherViewLayout()
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
        
        output.loadForecastWeather
            .subscribe(onNext: { weather in
                guard let weather = weather else { return }
                self.applySnapshotWith(hourlyWeather: weather.hourly, dailyWeather: weather.daily)
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
        [currentWeatherView, forecastCollectionView].forEach { view in
            self.view.addSubview(view)
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
    
    private func setupCurrentWeatherViewLayout() {
        currentWeatherView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        forecastCollectionView.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherView.snp.bottom).offset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func setupCollectionView() {
        forecastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: creatLayout())
        forecastCollectionView.backgroundColor = .clear
        forecastCollectionView.layer.backgroundColor = (UIColor(red: 0.0784, green: 0.0784, blue: 0.4, alpha: 1.0).cgColor).copy(alpha: 0.2)
        forecastCollectionView.layer.cornerRadius = 15
        forecastCollectionView.layer.masksToBounds = true
        forecastCollectionView.showsVerticalScrollIndicator = false
    }
    
    private func registerCollectionViewCell() {
        forecastCollectionView.register(HourlyWeatherCollectionViewCell.self)
        forecastCollectionView.register(DailyWeatherCollectionViewCell.self)
    }
    
    private func creatLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else {
                return nil
            }
            
            //item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            //group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: sectionKind.column)
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = sectionKind.orthogonalScrollingBehavior()
            
            return section
        }
        return layout
    }
    
    private func setupDataSource() {
        dataSource = DiffableDataSource(collectionView: forecastCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .hourly(let hourlyWeather):
                let cell = collectionView.dequeueReusableCell(HourlyWeatherCollectionViewCell.self, for: indexPath)
                cell?.setupHourlyForecastCell(with: hourlyWeather)
                
                return cell
            case .daily(let dailyWeather):
                let cell = collectionView.dequeueReusableCell(DailyWeatherCollectionViewCell.self, for: indexPath)
                cell?.setupDailyForecastCell(with: dailyWeather)
                
                return cell
            }
        })
        forecastCollectionView.dataSource = dataSource
    }
    
    private func applySnapshotWith(hourlyWeather: [HourlyWeather]?, dailyWeather: [DailyWeather]?) {
        guard let hourlyWeather = hourlyWeather, let dailyWeather = dailyWeather else { return }
        let hourlyWeatherItems = hourlyWeather.map { WeatherItem.hourly($0) }
        let dailyWeatherItems = dailyWeather.map { WeatherItem.daily($0) }
        snapshot = NSDiffableDataSourceSnapshot<Section, WeatherItem>()
        
        snapshot.appendSections([.hourly])
        snapshot.appendItems(hourlyWeatherItems)
        snapshot.appendSections([.daily])
        snapshot.appendItems(dailyWeatherItems)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
