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
        let expandButtonIcon = expanded ? UIImage(systemName: "arrow.up.right.circle.fill") : UIImage(systemName: "rectangle.stack.badge.plus")
        
        guard let navigationBar = controller.navigationController?.navigationBar else {
            completion(false)
            return
        }
        
        controller.navigationItem.rightBarButtonItems?.first?.image = expandButtonIcon
        let transitionOptions: UIView.AnimationOptions = expanded ? .transitionFlipFromTop : .transitionCrossDissolve
        
        UIView.transition(with: navigationBar, duration: 0.4, options: transitionOptions, animations: {
            if expanded {
                controller.navigationItem.rightBarButtonItems?.append(contentsOf: navBarButtonItems)
                navBarButtonItems.forEach { button in
                    button.customView?.alpha = 0
                    button.customView?.transform = CGAffineTransform(translationX: 50, y: 0)
                }
            } else {
                controller.navigationItem.rightBarButtonItems = [controller.navigationItem.rightBarButtonItems?.first].compactMap { $0 }
            }
        }) { _ in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                navBarButtonItems.forEach { button in
                    button.customView?.alpha = expanded ? 1 : 0
                    button.customView?.transform = expanded ? .identity : CGAffineTransform(translationX: 50, y: 0)
                }
                controller.navigationItem.rightBarButtonItems?.first?.customView?.transform = expanded ? CGAffineTransform(rotationAngle: .pi / 4) : .identity
            }) { _ in
                completion(expanded)
            }
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            titleView?.alpha = expanded ? 0 : 1
            titleView?.transform = expanded ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
        })
        
        generateHapticFeedback(.rigid)
    }
}
