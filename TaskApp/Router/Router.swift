//
//  Router.swift
//  TestTask
//
//  Created by Mac on 15.03.2024.
//

import Foundation
import UIKit

protocol MainRouterProtocol {
    var  navigatinController: UINavigationController? { get set }
    var  assemblyModule: AssemblyModuleProtocol? { get set }
}

protocol RouterProtocol: MainRouterProtocol {
    func showTaskView(with data: ToDoModel)
    func popToRoot()
}

class ListRouter: RouterProtocol {
    // MARK: -  Properties
    var navigatinController: UINavigationController?
    var assemblyModule: AssemblyModuleProtocol?
    
    // MARK: - Initialization
    init(navigatinController: UINavigationController, assemblyModule: AssemblyModuleProtocol) {
        self.navigatinController = navigatinController
        self.assemblyModule = assemblyModule
    }
    
    // MARK: - Methods
    func initialViewController() {
        if let navigatinController = navigatinController {
            guard let listView = assemblyModule?.assembleListView(router: self) else { return }
            navigatinController.viewControllers = [listView]
        }
    }
    
    func showTaskView(with data: ToDoModel) {
        if let navigatinController = navigatinController {
            guard let taskView = assemblyModule?.assembleTaskView(router: self) else { return }
            (taskView as? TaskView)?.determine(task: data)
            navigatinController.pushViewController(taskView, animated: false)
        }
    }
    
    func popToRoot() {
        if let navigatinController = navigatinController {
            navigatinController.popToRootViewController(animated: false)
        }
    }
}
