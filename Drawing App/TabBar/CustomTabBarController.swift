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
        let icon = UIImage(systemName: "theatermask.and.paintbrush")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(systemName: "theatermask.and.paintbrush.fill")?.withRenderingMode(.alwaysTemplate)
        let tabBarItem = UITabBarItem(title: "VC1", image: icon, selectedImage: iconSelected)
        //tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem.tag = 1
        vc.tabBarItem = tabBarItem
        vc.tabBarItem.selectedImage = iconSelected
        return vc
    }()
    
    let patternVC: PatternViewController = {
        let vc = PatternViewController()
        let icon = UIImage(systemName: "lasso.badge.sparkles")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(systemName: "lasso.badge.sparkles")?.withRenderingMode(.alwaysTemplate)
        let tabBarItem = UITabBarItem(title: "Pattern", image: icon, selectedImage: iconSelected)
        tabBarItem.tag = 2
        vc.tabBarItem.selectedImage = iconSelected
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    let scribbleVC: SimpleDrawController = {
        let vc = SimpleDrawController()
        let icon = UIImage(systemName: "pencil.and.scribble")?.withRenderingMode(.alwaysOriginal)
        let iconSelected = UIImage(systemName: "pencil.and.scribble")?.withRenderingMode(.alwaysTemplate)
        let tabBarItem = UITabBarItem(title: "Draw", image: icon, selectedImage: iconSelected)
        tabBarItem.tag = 3
        vc.tabBarItem.selectedImage = iconSelected
        vc.tabBarItem = tabBarItem
        return vc
    }()
    
    let colorPaletteVC: ColorPickerViewController = {
        let vc = ColorPickerViewController()
        let icon = UIImage(systemName: "paintpalette")?.withRenderingMode(.alwaysTemplate)
        let iconSelected = UIImage(systemName: "paintpalette.fill")?.withRenderingMode(.alwaysTemplate)
        let tabBarItem = UITabBarItem(title: "Playground", image: icon, selectedImage: iconSelected)
        tabBarItem.tag = 4
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
        
        let controllers = [brushesTVC, patternVC, scribbleVC, colorPaletteVC]
        self.viewControllers = controllers.map {UINavigationController(rootViewController: $0)}
    }
}
