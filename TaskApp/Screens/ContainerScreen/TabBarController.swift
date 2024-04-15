//
//  TabBarController.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Private Properties
    private var moduleFactory: ModuleFactoryProtocol!
    
    // MARK: - Initialization
    init(moduleFactory: ModuleFactory = ModuleFactory()) {
        self.moduleFactory = moduleFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label
        view.backgroundColor = .white
        setupViewControllers()
    }
    
    // MARK: - Private Methods
    private func setupViewControllers() {
        let listModule = UINavigationController()
        moduleFactory.configureListModule(with: listModule)
        let sourceModule = moduleFactory.configureSourceModule()
        
        viewControllers = [
            createTabBarItem(listModule, title: "List",
                             imageName: "doc.plaintext", selectedImage: "doc.plaintext.fill"),
            createTabBarItem(sourceModule, title: "Source",
                             imageName: "archivebox", selectedImage: "archivebox.fill")
        ]
    }
}
