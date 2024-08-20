//
//  RustBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/11/24.
//

import UIKit

// MARK: - Rust Brush

class RustBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setLineCap(.round)
        for point in points.dropFirst() {
            let alpha = CGFloat.random(in: 0.5...0.8)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            
            context.setLineWidth(CGFloat(strokeWidth))
            context.addLine(to: point)
            context.strokePath()
            context.move(to: point)
            
            let circleRadius = CGFloat(strokeWidth / 2)
            let circleRect = CGRect(
                x: point.x - circleRadius,
                y: point.y - circleRadius,
                width: circleRadius * 2,
                height: circleRadius * 2
            )
            context.setFillColor(color)
            context.fillEllipse(in: circleRect)
        }
    }
}
