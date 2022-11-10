//
//  HourlyForecastCollectionViewCell.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/09.
//

import UIKit
import SnapKit

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    private let hourlyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        
        return label
    }()
    
    private let weatherImageview: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        
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
    
    func setupHourlyForecastCell(with data: HourlyWeather) {
        timeLabel.text = data.dt.toDate().toHourString()
        weatherImageview.image = UIImage(named: String(data.weather[0].id))
        temperatureLabel.text = data.temperature.toRoundedString()
    }
    
    private func addSubviews() {
        contentView.addSubview(hourlyStackView)
        [timeLabel, weatherImageview, temperatureLabel].forEach { view in
            hourlyStackView.addArrangedSubview(view)
        }
    }
    
    private func setupLayout() {
        hourlyStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
