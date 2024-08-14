//
//  LineBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/9/24.
//

import UIKit

// MARK: - Brush Protocol

/// A protocol that defines the drawing behavior for a brush.
protocol Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor)
}

// MARK: - BrushSelectionDelegate Protocol

/// A protocol that defines the delegate method for brush selection.
protocol BrushSelectionDelegate: AnyObject {
    func didSelectBrush(_ brush: Brush)
}
