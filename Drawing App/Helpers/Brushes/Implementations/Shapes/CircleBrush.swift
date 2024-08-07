//
//  CircleBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/26/24.
//

import UIKit

class CircleBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first, let lastPoint = points.last else { return }
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineCap(.round)
        context.setLineDash(phase: 0, lengths: [])
        
        let radius = hypot(lastPoint.x - firstPoint.x, lastPoint.y - firstPoint.y) / 2
        let center = CGPoint(x: (firstPoint.x + lastPoint.x) / 2, y: (firstPoint.y + lastPoint.y) / 2)
        
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        context.strokePath()
    }
}
