//
//  CustomTabBarController.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Main ViewControlle --> Setup TabBar Items
    
    let scribbleVC: SimpleDrawController = {
        let vc = SimpleDrawController()
        let icon = UIImage(systemName: "pencil.and.scribble")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(systemName: "pencil.and.scribble")?.withRenderingMode(.alwaysTemplate)
        let tabBarItem = UITabBarItem(title: "Scribble", image: icon, selectedImage: iconSelected)
        tabBarItem.tag = 1
        vc.tabBarItem.selectedImage = iconSelected
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    let patternVC: PatternViewController = {
        let vc = PatternViewController()
        let icon = UIImage(systemName: "lasso.badge.sparkles")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(systemName: "lasso.badge.sparkles")?.withRenderingMode(.alwaysTemplate)
        let tabBarItem = UITabBarItem(title: "Symmetrix", image: icon, selectedImage: iconSelected)
        tabBarItem.tag = 2
        vc.tabBarItem.selectedImage = iconSelected
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    // MARK: - UIViewController - (viewDidLoad)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().isTranslucent = false
        view.backgroundColor = .white
        self.tabBar.tintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        self.tabBarItem.title = nil
        
        let controllers = [scribbleVC, patternVC]
        self.viewControllers = controllers.map {UINavigationController(rootViewController: $0)}
    }
}
