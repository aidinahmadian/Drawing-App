//
//  CharcoalBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/11/24.
//

import Foundation
import UIKit

class CharcoalBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        for point in points.dropFirst() {
            let alpha = CGFloat.random(in: 0.3...0.7)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            context.setLineWidth(CGFloat(strokeWidth * 2))
            
            context.addLine(to: point)
            context.strokePath()
            context.move(to: point)
            
            context.setFillColor(color)
            let offset = CGFloat(strokeWidth)
            context.fillEllipse(in: CGRect(x: point.x - offset, y: point.y - offset, width: offset * 2, height: offset * 2))
        }
    }
}
