//
//  StarBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/27/24.
//

import UIKit

// MARK: - Star Brush

class StarBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let center = points.first, let outerPoint = points.last else { return }
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineCap(.round)
        context.setLineDash(phase: 0, lengths: [])
        
        let radius = hypot(outerPoint.x - center.x, outerPoint.y - center.y)
        let innerRadius = radius / 2.5
        let numberOfPoints = 5
        let angle = CGFloat(2 * Double.pi) / CGFloat(numberOfPoints * 2)
        
        context.move(to: CGPoint(x: center.x, y: center.y - radius))
        
        for i in 1..<(numberOfPoints * 2) {
            let radius = (i % 2 == 0) ? radius : innerRadius
            let x = center.x + radius * sin(angle * CGFloat(i))
            let y = center.y - radius * cos(angle * CGFloat(i))
            context.addLine(to: CGPoint(x: x, y: y))
        }
        
        context.closePath()
        context.strokePath()
    }
}
