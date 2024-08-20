//
//  HexagonBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/27/24.
//

import UIKit

// MARK: - Hexagon Brush

class HexagonBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let center = points.first, let edgePoint = points.last else { return }
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineCap(.round)
        context.setLineDash(phase: 0, lengths: [])
        
        let radius = hypot(edgePoint.x - center.x, edgePoint.y - center.y)
        let angle = CGFloat.pi / 3.0
        
        context.move(to: CGPoint(x: center.x + radius * cos(0), y: center.y + radius * sin(0)))
        
        for i in 1..<6 {
            let x = center.x + radius * cos(angle * CGFloat(i))
            let y = center.y + radius * sin(angle * CGFloat(i))
            context.addLine(to: CGPoint(x: x, y: y))
        }
        
        context.closePath()
        context.strokePath()
    }
}

