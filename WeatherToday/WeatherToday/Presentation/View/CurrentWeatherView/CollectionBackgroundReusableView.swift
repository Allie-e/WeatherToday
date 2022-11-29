//
//  CollectionBackgroundReusableView.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/29.
//

import UIKit
import SnapKit

final class CollectionBackgroundReusableView: UICollectionReusableView {
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = (UIColor(red: 0.0784, green: 0.0784, blue: 0.4, alpha: 1.0).cgColor).copy(alpha: 0.2)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
