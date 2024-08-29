//
//  EraserBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 8/11/24.
//

import UIKit

// MARK: - Eraser Brush

class EraserBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor = .white) {
        guard let firstPoint = points.first else { return }
        
        // Set the stroke color to white to simulate erasing
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineCap(.round)
        context.setLineDash(phase: 0, lengths: [])
        
        if points.count == 1 {
            // Erase a dot
            context.addArc(center: firstPoint, radius: CGFloat(strokeWidth) / 2, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
            context.fillPath()
        } else {
            context.move(to: firstPoint)
            
            if points.count > 2 {
                for i in 1..<points.count - 1 {
                    let p0 = points[i]
                    let p1 = points[i + 1]
                    let midPoint = CGPoint(x: (p0.x + p1.x) / 2, y: (p0.y + p1.y) / 2)
                    
                    context.addQuadCurve(to: midPoint, control: p0)
                }
                
                if let lastPoint = points.last {
                    context.addLine(to: lastPoint)
                }
            } else if points.count > 1 {
                context.addLine(to: points[1])
            }
            
            context.strokePath()
        }
    }
}