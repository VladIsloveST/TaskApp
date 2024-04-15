//
//  ViewController.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//

import UIKit
import SnapKit

protocol CellTaskDelegate: AnyObject {
    func changeTaskStatus(task: ToDoModel)
}

class ListView: UIViewController {
    // MARK: - Private Properties
    private var taskTableView: UITableView!
    private var taskPresenter: ListViewOutPut!
    private var tasks: [ToDoModel]!
    
    // MARK: - Initialization
    init(presenter: ListViewOutPut) {
        self.taskPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = taskPresenter.getTasks()
        configureTableView()
        setupNavBar()
    }
    
    // MARK: - Private Methods
    private func configureTableView() {
        taskTableView = UITableView()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.separatorInset.right = 20
        taskTableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.identifier)
        view.addSubview(taskTableView)
        taskTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavBar() {
        let image = UIImage(systemName: "square.and.pencil")
        let editButton = UIBarButtonItem(image: image, style: .plain,
                                         target: self, action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
        self.navigationItem.title = "List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc
    private func editButtonTapped() {
        taskPresenter.moveToTaskView(with: nil)
    }
}

// MARK: - Table View Data Source
extension ListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let toDoCell = tableView.dequeueReusableCell(
            withIdentifier: ToDoCell.identifier, for: indexPath) as? ToDoCell else { return cell }
        let task = tasks[indexPath.row]
        toDoCell.assignCellData(from: task, delegate: self)
        return toDoCell
    }
}

// MARK: - Table View Delegate
extension ListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskPresenter.moveToTaskView(with: tasks[indexPath.row] )
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedTask = tasks.remove(at: indexPath.row)
            taskPresenter.deleteTaskWith(title: removedTask.title)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Conform ViewInPut
extension ListView: ListViewInPut {
    func updateUI(_ newTasks: [ToDoModel]) {
        if tasks.description.hashValue != newTasks.description.hashValue {
            tasks = newTasks
            taskTableView.reloadData()
        }
    }
}

// MARK: - Additional Delegate
extension ListView: CellTaskDelegate {
    func changeTaskStatus(task: ToDoModel) {
        taskPresenter.erase(task: task)
    }
}
