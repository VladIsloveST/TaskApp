//
//  ToDoCell.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//

import UIKit
import SnapKit

class ToDoCell: UITableViewCell {
    static let identifier = ToDoCell.description()
    
    // MARK: - Properties
    private weak var cellDelegate: CellTaskDelegate?
    private var taskData = ToDoModel()
    private var titleLable: UILabel = {
        $0.font = UIFont(name: "Hiragino Mincho ProN W6", size: 20)
        $0.textColor = .black
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let checkButton: CustomButtom = {
        let button = CustomButtom(normalStateImage: "square",
                                  selectedStateImage: "checkmark.square.fill")
        button.addTarget(self, action: #selector(putСheckmark), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func assignCellData(from task: ToDoModel, delegate: CellTaskDelegate?) {
        cellDelegate = delegate
        taskData = task
        checkButton.isSelected = task.isReady
        titleLable.attributedText = setupText(task.title)
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 20, 
                                                             bottom: 8, right: 50))
        }
        contentView.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc
    private func putСheckmark() {
        checkButton.isSelected = !checkButton.isSelected
        titleLable.attributedText = setupText(titleLable.text ?? "")
        taskData.isReady = checkButton.isSelected
        cellDelegate?.changeTaskStatus(task: taskData)
    }
    
    private func setupText(_ title: String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: title)
        if checkButton.isSelected {
            attributeString.addAttribute(.strikethroughStyle, value: 1,
                                         range: NSMakeRange(0, attributeString.length))
        }
        return attributeString
    }
}
