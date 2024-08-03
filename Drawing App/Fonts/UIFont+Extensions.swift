//
//  UIFont+Extensions.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 8/3/24.
//

import UIKit

extension UIFont {
    static func customFont(name: String, size: CGFloat, fallbackFont: UIFont = .systemFont(ofSize: 14)) -> UIFont {
        return UIFont(name: name, size: size) ?? fallbackFont
    }
}
