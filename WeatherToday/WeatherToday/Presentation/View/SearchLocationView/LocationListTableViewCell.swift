//
//  LocationListTableViewCell.swift
//  WeatherToday
//
//  Created by Allie on 2022/12/05.
//

import UIKit
import SnapKit

final class LocationListTableViewCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let currentWeatherLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .right
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray3
        label.textAlignment = .right
        label.sizeToFit()
        
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .right
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupLayout()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLocationListCell(with data: CurrentWeather) {
        nameLabel.text = data.name
        currentWeatherLabel.text = "\(data.temperature.current.toRoundedString())°"
        descriptionLabel.text = data.weather.first?.weatherDescription
        temperatureLabel.text = "최고: \(data.temperature.max.toRoundedString())° 최저: \(data.temperature.min.toRoundedString())°"
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        [nameLabel, currentWeatherLabel, descriptionLabel, temperatureLabel].forEach { view in
            containerView.addSubview(view)
        }
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(30)
        }
        
        currentWeatherLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.bottom.leading.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherLabel.snp.bottom).offset(10)
            make.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setupCell() {
        self.backgroundColor = UIColor(red: 93/255, green: 140/255, blue: 210/255, alpha: 1.0)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
}
