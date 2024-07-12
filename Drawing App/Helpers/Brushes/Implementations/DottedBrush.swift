//
//  DottedBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/11/24.
//

import Foundation
import UIKit

class DottedBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineCap(.round)
        context.setLineDash(phase: 0, lengths: [CGFloat(strokeWidth * 2), CGFloat(strokeWidth * 2)]) //Set line dash pattern
        for point in points.dropFirst() {
            context.addLine(to: point)
        }
        context.strokePath()
    }
}
