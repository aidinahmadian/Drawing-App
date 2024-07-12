//
//  ChalkBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/11/24.
//

import Foundation
import UIKit

class ChalkBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        for (i, point) in points.enumerated() {
            context.setLineWidth(CGFloat(strokeWidth))
            let alpha = CGFloat.random(in: 0.3...0.7)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            
            if i > 0 {
                let jitteredPoint = CGPoint(
                    x: point.x + CGFloat.random(in: -1...1),
                    y: point.y + CGFloat.random(in: -1...1)
                )
                context.addLine(to: jitteredPoint)
                context.strokePath()
                context.move(to: jitteredPoint)
            }
        }
    }
}
