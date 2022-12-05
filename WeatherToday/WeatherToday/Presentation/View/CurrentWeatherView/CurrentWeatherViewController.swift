//
//  ViewController.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/19.
//

import UIKit
import CoreLocation
import RxSwift

class CurrentWeatherViewController: UIViewController {
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
    
    private enum SupplementaryKind {
        static let header = "header"
    }
    
    private let currentWeatherView = CurrentWeatherView()
    private var forecastCollectionView: UICollectionView!
    private var dataSource: DiffableDataSource?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherItem>()
    
    let viewModel = WeatherViewModel()
    let loadLocationObservable: PublishSubject<Coordinate> = .init()
    let disposeBag: DisposeBag = .init()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        registerCollectionViewCell()
        addSubviews()
        setupDataSource()
        setupCollectionViewHeader()
        setupCurrentWeatherViewLayout()
        setupLocationManager()
        bind()
    }
    
    private func bind() {
        let location = locationManager.rx.didUpdateLocations
        let input = WeatherViewModel.Input(loadLocation: location)
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
        forecastCollectionView.showsVerticalScrollIndicator = false
    }
    
    private func registerCollectionViewCell() {
        forecastCollectionView.register(HourlyWeatherCollectionViewCell.self)
        forecastCollectionView.register(DailyWeatherCollectionViewCell.self)
    }
    
    private func creatLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 15
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else {
                return nil
            }
            
            switch sectionKind {
            case .hourly:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                      heightDimension: .absolute(110))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(110))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: sectionKind.column)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = sectionKind.orthogonalScrollingBehavior()
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(30)),
                    elementKind: SupplementaryKind.header,
                    alignment: .top)
                section.boundarySupplementaryItems = [header]
                section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: "CollectionBackgroundReusableView")]
                
                return section
            case .daily:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(70))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: sectionKind.column)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = sectionKind.orthogonalScrollingBehavior()
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(30)),
                    elementKind: SupplementaryKind.header,
                    alignment: .top)
                section.boundarySupplementaryItems = [header]
                section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: "CollectionBackgroundReusableView")]
                
                return section
            }
        },
        configuration: config)
        
        layout.register(CollectionBackgroundReusableView.self, forDecorationViewOfKind: "CollectionBackgroundReusableView")
        
        return layout
    }
    
    private func setupCollectionViewHeader() {
        forecastCollectionView.register(WeatherCollectionReusableView.self, forSupplementaryViewOfKind: SupplementaryKind.header, withReuseIdentifier: "WeatherCollectionReusableView")
        
        dataSource?.supplementaryViewProvider = { [weak self] (view, kind, indexPath) in
            guard let header = self?.forecastCollectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryKind.header, withReuseIdentifier: "WeatherCollectionReusableView", for: indexPath) as? WeatherCollectionReusableView else {
                return nil
            }
            header.setupLabel(with: indexPath)
            
            return header
        }
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
