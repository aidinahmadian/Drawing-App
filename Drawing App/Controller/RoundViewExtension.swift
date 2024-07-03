//
//  RoundViewExtension.swift
//  Test
//
//  Created by aidin ahmadian on 7/29/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

extension UIView {
    
    // Circle view
    func circleStyledView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius  = round(self.frame.size.width/2.0)
    }
}
