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
        label.textColor = .white
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with title: String) {
        namelabel.text = title
    }
    
    private func initView() {
        backgroundColor = .black
        contentView.addSubview(namelabel)
    }
    
    private func setupLayout() {
        namelabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}
