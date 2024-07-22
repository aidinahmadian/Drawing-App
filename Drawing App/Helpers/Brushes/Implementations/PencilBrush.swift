//
//  PencilBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/11/24.
//

import UIKit

class PencilBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        for point in points.dropFirst() {
            context.setLineWidth(CGFloat(strokeWidth))
            let alpha = CGFloat.random(in: 0.5...1.0)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            
            context.addLine(to: point)
            context.strokePath()
            context.move(to: point)
        }
    }
}
