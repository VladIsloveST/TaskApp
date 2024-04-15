//
//  SceneDelegate.swift
//  TestTask
//
//  Created by Mac on 14.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        let mainController = TabBarController()
        mainController.selectedIndex = 0
        self.window?.rootViewController = mainController
        window?.makeKeyAndVisible()
    }
}

