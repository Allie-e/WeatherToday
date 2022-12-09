//
//  SearchListTableViewCell.swift
//  WeatherToday
//
//  Created by Allie on 2022/12/09.
//

import UIKit

final class SearchListTableViewCell: UITableViewCell {
    private let namelabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.textColor = .systemGray3
        
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
        contentView.addSubview(namelabel)
    }
    
    private func setupLayout() {
        namelabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
