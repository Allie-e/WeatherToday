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
        label.textColor = .systemGray2
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
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
            make.edges.equalTo(self)
        }
    }
    
    func setupLabel(with indexPath: IndexPath) {
        if indexPath.section == 0 {
            let hourlyTitle = NSMutableAttributedString(string: "시간대별 예보")
            let icon = NSTextAttachment()
            icon.image = UIImage(systemName: "clock.fill")
            icon.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
            
            hourlyTitle.append(NSAttributedString(attachment: icon))
            
            titleLabel.attributedText = hourlyTitle
        } else {
            let dailyTitle = NSMutableAttributedString(string: "일별 예보")
            let icon = NSTextAttachment()
            icon.image = UIImage(systemName: "calendar")
            icon.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
            
            dailyTitle.append(NSAttributedString(attachment: icon))
            
            titleLabel.attributedText = dailyTitle
        }
    }
}
