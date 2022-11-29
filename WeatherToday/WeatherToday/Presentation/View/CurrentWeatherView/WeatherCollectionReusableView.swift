//
//  WeatherCollectionReusableView.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/25.
//

import UIKit
import SnapKit

final class WeatherCollectionReusableView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .left
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        addUnderLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(self)
            make.leading.equalTo(self).offset(10)
        }
    }
    
    private func addUnderLine() {
        let underline = layer.makeBorder([.bottom], color: UIColor.systemGray3, width: 0.5)
        underline.frame = CGRect(x: 18, y: layer.frame.height, width: underline.frame.width - 1, height: underline.frame.height)
        layer.addSublayer(underline)
    }
    
    func setupLabel(with indexPath: IndexPath) {
        if indexPath.section == 0 {
            let attributedString = NSMutableAttributedString(string: "")
            let hourlyTitle = NSMutableAttributedString(string: " 시간대별 일기예보")
            let icon = NSTextAttachment()
            icon.image = UIImage(systemName: "clock.fill")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            icon.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
            
            attributedString.append(NSAttributedString(attachment: icon))
            attributedString.append(hourlyTitle)
            
            titleLabel.attributedText = attributedString
            titleLabel.sizeToFit()
        } else {
            let attributedString = NSMutableAttributedString(string: "")
            let dailyTitle = NSMutableAttributedString(string: " 8일간의 일기예보")
            let icon = NSTextAttachment()
            icon.image = UIImage(systemName: "calendar")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            icon.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
            
            attributedString.append(NSAttributedString(attachment: icon))
            attributedString.append(dailyTitle)
            
            titleLabel.attributedText = attributedString
            titleLabel.sizeToFit()
        }
    }
}
