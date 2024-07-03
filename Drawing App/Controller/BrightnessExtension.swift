//
//  ExploreViewController.swift
//  Test
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // Returns whether or not the color is a bright/light color
    func isLightColor() -> Bool {
        if let components = self.cgColor.components {
            // Ensure enough components
            if components.count < 3{
                return false
            }
            
            // Had to separate into individual equations
            // The calculation in one whole was too complex apparently
            let cOne = ((components[0]) * 299)
            let cTwo = ((components[1]) * 587)
            let cThree = ((components[2]) * 114)
            
            // Brightness equation
            let brightness = (cOne + cTwo + cThree) / 1000
            
            // If less than 0.5 color is considered "dark"
            if brightness < 0.5 {
                return false
            } else {
                return true
            }
        }
        
        // If it doesn't contain components return false
        return false
    }
}
