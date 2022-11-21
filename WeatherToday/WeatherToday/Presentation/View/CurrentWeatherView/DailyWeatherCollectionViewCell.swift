//
//  DailyWeatherCollectionViewCell.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/15.
//

import UIKit
import SnapKit

final class DailyWeatherCollectionViewCell: UICollectionViewCell {
    private let dailyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let weatherImageview: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .systemGray
        
        return label
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
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
    
    func setupDailyForecastCell(with data: DailyWeather) {
        dayLabel.text = data.dt.toDate().toDayString()
        weatherImageview.image = UIImage(named: String(data.weather[0].icon))
        minTemperatureLabel.text = "\(data.temperature.min.toRoundedString())°"
        maxTemperatureLabel.text = "\(data.temperature.max.toRoundedString())°"
    }
    
    private func addSubviews() {
        contentView.addSubview(dailyStackView)
        [dayLabel, weatherImageview, minTemperatureLabel, maxTemperatureLabel].forEach { view in
            dailyStackView.addArrangedSubview(view)
        }
    }
    
    private func setupLayout() {
        dailyStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
