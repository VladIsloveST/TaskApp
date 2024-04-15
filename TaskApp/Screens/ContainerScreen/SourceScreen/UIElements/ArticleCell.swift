//
//  ArticleCell.swift
//  TestTask
//
//  Created by Mac on 18.03.2024.
//

import Foundation
import UIKit

class ArticleCell: UITableViewCell {
    static let identifier = ArticleCell.description()
    
    // MARK: - Private Properties
    private var titleLable: UILabel = {
        $0.font = UIFont(name: "Hiragino Mincho ProN W6", size: 18)
        $0.textColor = .black
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private var authorLable: UILabel = {
        $0.font = UIFont(name: "Arial", size: 14)
        $0.textColor = .gray
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func assignCellData(from article: ArticleData) {
        titleLable.text = article.title
        authorLable.text = article.author
    }
    
    private func setupConstraints() {
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(authorLable)
        authorLable.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
