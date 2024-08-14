//
//  NavBarAnimationManager.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/26/24.
//

import UIKit

// MARK: - NavBarAnimationManager

/// Manages the animations for toggling the navigation bar buttons.
class NavBarAnimationManager {
    
    // MARK: - Toggle Navigation Bar Buttons
    
    /// Toggles the navigation bar buttons with animation.
    /// - Parameters:
    ///   - controller: The view controller containing the navigation bar.
    ///   - navBarButtonItems: The additional navigation bar buttons to toggle.
    ///   - areNavBarButtonsExpanded: A Boolean indicating if the buttons are currently expanded.
    ///   - titleView: The title view of the navigation bar.
    ///   - completion: A completion handler called after the animation finishes, with a Boolean indicating the expanded state.
    static func toggleNavBarButtons(
        for controller: UIViewController,
        navBarButtonItems: [UIBarButtonItem],
        areNavBarButtonsExpanded: Bool,
        titleView: UIView?,
        completion: @escaping (Bool) -> Void
    ) {
        let expanded = !areNavBarButtonsExpanded
        let expandButtonIcon = expanded ? UIImage(systemName: "arrow.up.right.circle.fill") : UIImage(systemName: "shippingbox.and.arrow.backward.fill")
        
        // Ensure the navigation bar exists
        guard let navigationBar = controller.navigationController?.navigationBar else {
            completion(false)
            return
        }
        
        // Update the first right bar button item with the new icon
        controller.navigationItem.rightBarButtonItems?.first?.image = expandButtonIcon
        let transitionOptions: UIView.AnimationOptions = expanded ? .transitionFlipFromTop : .transitionCrossDissolve
        
        // Perform the transition animation for the navigation bar
        UIView.transition(with: navigationBar, duration: 0.4, options: transitionOptions, animations: {
            if expanded {
                // Expand: Append the additional bar button items
                controller.navigationItem.rightBarButtonItems?.append(contentsOf: navBarButtonItems)
                navBarButtonItems.forEach { button in
                    button.customView?.alpha = 0
                    button.customView?.transform = CGAffineTransform(translationX: 50, y: 0)
                }
            } else {
                // Collapse: Keep only the first bar button item
                controller.navigationItem.rightBarButtonItems = [controller.navigationItem.rightBarButtonItems?.first].compactMap { $0 }
            }
        }) { _ in
            // Perform spring animation for the bar button items
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
        
        // Animate the title view (e.g., fade and scale)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            titleView?.alpha = expanded ? 0 : 1
            titleView?.transform = expanded ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
        })
        
        generateHapticFeedback(.rigid)
    }
}
