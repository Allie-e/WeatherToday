//
//  CurrentWeatherView.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/24.
//

import UIKit
import SnapKit

class CurrentWeatherView: UIView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabelText(with data: CurrentWeather) {
        nameLabel.text = data.name
        currentTemperatureLabel.text = "\(data.temperature.current.toRoundedString())°"
        descriptionLabel.text = data.weather.first?.weatherDescription
        temperatureLabel.text = "최고: \(data.temperature.max.toRoundedString())° 최저: \(data.temperature.min.toRoundedString())°"
    }
    
    private func addSubviews() {
        [nameLabel, currentTemperatureLabel, descriptionLabel, temperatureLabel].forEach { view in
            addSubview(view)
        }
    }
    
    private func setupLayout() {
        let safeArea = safeAreaLayoutGuide
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea).inset(5)
        }
        
        currentTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(nameLabel)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(nameLabel)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(nameLabel)
        }
    }
}
