//
//  TaskView.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//

import Foundation
import UIKit
import SnapKit

class TaskView: UIViewController {
    // MARK: - Private Properties
    private var titleLabel: UILabel!
    private var titleTextView: UITextView!
    private var explanationLabel: UILabel!
    private var explanationTextView: UITextView!
    private var taskPresenter: TaskViewOutPut!
    private var saveButtom: UIButton!
    private var task: ToDoModel!
    
    // MARK: - Initialization
    init(presenter: TaskViewOutPut) {
        self.taskPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Task"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureUIElements()
        setupConstraints()
    }
    
    func determine(task: ToDoModel) {
        self.task = task
    }
    
    // MARK: - Private Methods
    private func configureUIElements() {
        titleLabel = UILabel()
        titleLabel.text = "Title"
        setup(titleLabel)
        
        titleTextView = UITextView()
        setup(titleTextView)
        titleTextView.text = task.title
        taskPresenter.oldTitleValue = task.title
        
        explanationLabel = UILabel()
        explanationLabel.text = "Description"
        setup(explanationLabel)
        
        explanationTextView = UITextView()
        setup(explanationTextView)
        explanationTextView.text = task.explanation
        
        saveButtom = UIButton(type: .system)
        saveButtom.setTitle("Save", for: .normal)
        saveButtom.tintColor = .white
        saveButtom.backgroundColor = .systemBlue
        saveButtom.layer.cornerRadius = 25
        saveButtom.addTarget(self, action: #selector(pressedSaveButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top).inset(150)
            make.leading.equalToSuperview().inset(40)
            make.height.equalTo(30)
        }
        view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(100)
        }
        view.addSubview(explanationLabel)
        explanationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(35)
            make.leading.equalToSuperview().inset(40)
            make.height.equalTo(30)
        }
        view.addSubview(explanationTextView)
        explanationTextView.snp.makeConstraints { make in
            make.top.equalTo(explanationLabel.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(230)
        }
        view.addSubview(saveButtom)
        saveButtom.snp.makeConstraints { make in
            make.top.equalTo(explanationTextView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(130)
        }
    }
    
    private func setup(_ label: UILabel) {
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    private func setup(_ textView: UITextView) {
        textView.setupLayer()
        textView.font = UIFont(name: "Hiragino Mincho ProN W6", size: 24)
        textView.tintColor = .black
    }
    
    @objc
    private func pressedSaveButton() {
        let toDoModel = ToDoModel(title: titleTextView.text,
                                  explanation: explanationTextView.text,
                                  isReady: task.isReady)
        taskPresenter.added(toDoModel)
    }
}
