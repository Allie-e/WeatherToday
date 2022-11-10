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
    }
    
    private let mainStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    let currentWeatherView = CurrentWeatherView()
    let hourlyForecastCollectionView: UICollectionView = {
        let layout = setupCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    private var hourlyDataSource: UICollectionViewDiffableDataSource<Section, HourlyWeather>?
    
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
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func addSubviews() {
        view.addSubview(mainStackView)
        [currentWeatherView, hourlyForecastCollectionView].forEach { view in
            mainStackView.addArrangedSubview(view)
        }
    }
    
    private func setupCurrentWeatherViewLayout() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        currentWeatherView.snp.makeConstraints { make in
            make.height.equalTo(200)
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
    static func setupCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func registerCollectionViewCell() {
        hourlyForecastCollectionView.register(HourlyForecastCollectionViewCell.self)
    }
    
    private func setupCollectionViewDataSource() {
        hourlyDataSource = UICollectionViewDiffableDataSource<Section, HourlyWeather>(collectionView: hourlyForecastCollectionView, cellProvider: { (collectionView, indexPath, weather) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell( HourlyForecastCollectionViewCell.self, for: indexPath) else {
                return HourlyForecastCollectionViewCell()
            }
            cell.setupHourlyForecastCell(with: weather)
            
            return cell
        })
    }
    
    private func applySnapshot(with weather: [HourlyWeather]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, HourlyWeather>()
        snapshot.appendSections([.hourly])
        snapshot.appendItems(weather, toSection: .hourly)
        snapshot.reloadItems(weather)
        hourlyDataSource?.apply(snapshot)
    }
}
