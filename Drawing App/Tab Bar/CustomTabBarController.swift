//
//  CustomTabBarController.swift
//  Test
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Main ViewControlle --> Setup TabBar Items
    
    let brushesTVC: TableViewController = {
        let vc = TableViewController()
        let icon = UIImage(named: "icons8-drawing-25 (1)")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(named: "icons8-drawing-25")?.withRenderingMode(.alwaysOriginal)
        let tabBarItem = UITabBarItem(title: nil, image: icon, selectedImage: iconSelected)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem.tag = 1
        vc.tabBarItem.selectedImage = iconSelected
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    let colorPaletteVC: VarietiesViewController = {
        let vc = VarietiesViewController()
        let icon = UIImage(named: "icons8-paint-brush-25 (1)")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(named: "icons8-paint-brush-25")?.withRenderingMode(.alwaysOriginal)
        let tabBarItem = UITabBarItem(title: nil, image: icon, selectedImage: iconSelected)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem.tag = 4
        vc.tabBarItem.selectedImage = iconSelected
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    let scribbleVC: SimpleDrawController = {
        let vc = SimpleDrawController()
        let icon = UIImage(named: "icons8-signature-25")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(named: "icons8-signature-25-2")?.withRenderingMode(.alwaysOriginal)
        let tabBarItem = UITabBarItem(title: nil, image: icon, selectedImage: iconSelected)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem.tag = 3
        vc.tabBarItem.selectedImage = iconSelected
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    let patternVC: PatternViewController = {
        let vc = PatternViewController()
        let icon = UIImage(named: "icons8-paint-roller-25 (1)")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(named: "icons8-paint-roller-25")?.withRenderingMode(.alwaysOriginal)
        let tabBarItem = UITabBarItem(title: nil, image: icon, selectedImage: iconSelected)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem.tag = 2
        vc.tabBarItem.selectedImage = iconSelected
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    // MARK: - UIViewController - (viewDidLoad)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().isTranslucent = false
        //UINavigationBar.appearance().isTranslucent = false
        
        view.backgroundColor = .clear
        self.tabBar.tintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.white
        self.tabBarItem.title = nil
        
        let controllers = [brushesTVC, patternVC, scribbleVC, colorPaletteVC]
        self.viewControllers = controllers.map {UINavigationController(rootViewController: $0)}
    }
}
