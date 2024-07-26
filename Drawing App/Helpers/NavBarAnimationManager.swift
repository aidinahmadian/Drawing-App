//
//  NavBarAnimationManager.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/26/24.
//

import UIKit

class NavBarAnimationManager {
    
    static func toggleNavBarButtons(for controller: UIViewController, navBarButtonItems: [UIBarButtonItem], areNavBarButtonsExpanded: Bool, titleView: UIView?, completion: @escaping (Bool) -> Void) {
        let expanded = !areNavBarButtonsExpanded
        
        // Update the expand button icon immediately based on the state
        let expandButtonIcon = expanded ? UIImage(systemName: "arrow.up.right.circle.fill") : UIImage(systemName: "rectangle.stack.badge.plus")
        controller.navigationItem.rightBarButtonItems?.first?.image = expandButtonIcon
        
        // Flip animation for the navigation bar
        UIView.transition(with: controller.navigationController!.navigationBar, duration: 0.4, options: .transitionFlipFromTop, animations: {
            
            if expanded {
                controller.navigationItem.rightBarButtonItems?.append(contentsOf: navBarButtonItems)
                navBarButtonItems.forEach { button in
                    button.customView?.alpha = 0
                    button.customView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
                titleView?.alpha = 0
                titleView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            } else {
                controller.navigationItem.rightBarButtonItems = [controller.navigationItem.rightBarButtonItems?.first].compactMap { $0 }
            }
            
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                
                navBarButtonItems.forEach { button in
                    button.customView?.alpha = expanded ? 1 : 0
                    button.customView?.transform = expanded ? .identity : CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
                
                titleView?.alpha = expanded ? 0 : 1
                titleView?.transform = expanded ? CGAffineTransform(scaleX: 0.5, y: 0.5) : .identity
                
                // Update the expand button icon rotation
                controller.navigationItem.rightBarButtonItems?.first?.customView?.transform = expanded ? CGAffineTransform(rotationAngle: .pi) : .identity
                
            }) { _ in
                completion(expanded)
            }
        }
        
        generateHapticFeedback(.selection)
    }
}
