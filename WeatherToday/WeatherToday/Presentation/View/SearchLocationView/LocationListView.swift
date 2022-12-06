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
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
