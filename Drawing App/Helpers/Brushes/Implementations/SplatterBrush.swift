//
//  SplatterBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/11/24.
//

import UIKit

class SplatterBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        context.setLineCap(.round)
        context.setLineJoin(.round)

        // Batch drawing operations using saveGState and restoreGState
        context.saveGState()

        // Reduce the splatter count for better performance
        let splatterCount = 5

        for point in points {
            for _ in 0..<splatterCount {
                let radius = CGFloat.random(in: 1...CGFloat(strokeWidth))
                let offsetX = CGFloat.random(in: -10...10)
                let offsetY = CGFloat.random(in: -10...10)
                let splatterPoint = CGPoint(x: point.x + offsetX, y: point.y + offsetY)
                
                let alpha = CGFloat.random(in: 0.3...0.8)
                let color = strokeColor.withAlphaComponent(alpha).cgColor
                context.setFillColor(color)
                context.fillEllipse(in: CGRect(x: splatterPoint.x - radius, y: splatterPoint.y - radius, width: radius * 2, height: radius * 2))
            }
        }

        context.restoreGState()
    }
}
