//
//  Label-ImageView Blinking Extension.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/7/24.
//

import Foundation
import UIKit

extension UIView {
    func startBlink() {
        UIView.animate(
            withDuration: 0.8,
            delay: 0.0,
            options: [.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
            animations: { self.alpha = 0.4 },
            completion: nil
        )
    }

    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1.0
    }
    
    func startBlinkingAnimations() {
        let animationSettings: [(duration: TimeInterval, delay: TimeInterval, transform: CGAffineTransform)] = [
            (1.5, 2.5, CGAffineTransform(translationX: 0, y: 25)),
            (1.5, 3.5, .identity),
            (1.5, 4.5, CGAffineTransform(translationX: 0, y: 25)),
            (1.5, 5.5, .identity)
        ]
        
        for setting in animationSettings {
            UIView.animate(
                withDuration: setting.duration,
                delay: setting.delay,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 2,
                options: [],
                animations: {
                    self.transform = setting.transform
                },
                completion: nil
            )
        }
    }
}
