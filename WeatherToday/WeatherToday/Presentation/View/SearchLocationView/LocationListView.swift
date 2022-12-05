//
//  LocationListView.swift
//  WeatherToday
//
//  Created by Allie on 2022/12/05.
//

import UIKit

final class LocationListView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        setupViewLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds

        let colors = [
            UIColor(red: 93/255, green: 140/255, blue: 210/255, alpha: 1.0).cgColor,
            UIColor(red: 138/255, green: 217/255, blue: 237/255, alpha: 1.0).cgColor,
            UIColor(red: 186/255, green: 238/255, blue: 251/255, alpha: 1.0).cgColor
        ]

        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.layer.addSublayer(gradientLayer)
        self.backgroundColor = .clear
    }
}
