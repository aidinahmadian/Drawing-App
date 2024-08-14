//
//  CustomTabBarController.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

// MARK: - CustomTabBarController: Custom UITabBarController

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    /// The view controller for the "Scribble" tab.
    let scribbleVC: SimpleDrawController = {
        let vc = SimpleDrawController()
        let icon = UIImage(systemName: "pencil.and.scribble")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(systemName: "pencil.and.scribble")?.withRenderingMode(.alwaysTemplate)
        let tabBarItem = UITabBarItem(title: "Scribble", image: icon, selectedImage: iconSelected)
        tabBarItem.tag = 1
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    /// The view controller for the "Symmetrix" tab.
    let patternVC: PatternViewController = {
        let vc = PatternViewController()
        let icon = UIImage(systemName: "lasso.badge.sparkles")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(systemName: "lasso.badge.sparkles")?.withRenderingMode(.alwaysTemplate)
        let tabBarItem = UITabBarItem(title: "Symmetrix", image: icon, selectedImage: iconSelected)
        tabBarItem.tag = 2
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the tab bar appearance
        UITabBar.appearance().isTranslucent = false
        view.backgroundColor = .white
        self.tabBar.tintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        self.tabBarItem.title = nil
        
        // Set up the view controllers for the tab bar
        let controllers = [scribbleVC, patternVC]
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
    }
}
