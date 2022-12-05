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
        
        return label
    }()
    
    private let currentWeatherLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .right
        label.textColor = .white
        
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = .white
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        [nameLabel, currentWeatherLabel, temperatureLabel].forEach { view in
            containerView.addSubview(view)
        }
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        currentWeatherLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
        }
    }
    
    func setupLocationListCell(with data: CurrentWeather) {
        nameLabel.text = data.name
        currentWeatherLabel.text = "\(data.temperature.current.toRoundedString())°"
        temperatureLabel.text = "최고: \(data.temperature.max.toRoundedString())° 최저: \(data.temperature.min.toRoundedString())°"
    }
}
