//
//  StraightLineBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/26/24.
//

import UIKit

class StraightLineBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first, let lastPoint = points.last else { return }
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineCap(.round)
        context.setLineDash(phase: 0, lengths: [])
        
        context.move(to: firstPoint)
        context.addLine(to: lastPoint)
        
        context.strokePath()
    }
}
