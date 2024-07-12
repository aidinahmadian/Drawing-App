//
//  LineBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/9/24.
//

import UIKit

protocol Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor)
}
