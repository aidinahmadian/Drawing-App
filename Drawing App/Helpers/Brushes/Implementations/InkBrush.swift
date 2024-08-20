//
//  InkBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/11/24.
//

import UIKit

// MARK: - Ink Brush

class InkBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        for (i, point) in points.enumerated() {
            context.setLineWidth(CGFloat(strokeWidth))
            context.setStrokeColor(strokeColor.cgColor)
            
            if i > 0 {
                context.addLine(to: point)
                context.strokePath()
                context.move(to: point)
                
                // Random ink blobs
                if Int.random(in: 0...10) > 7 {
                    let blobRadius = CGFloat.random(in: CGFloat(strokeWidth / 2)...CGFloat(strokeWidth))
                    context.setFillColor(strokeColor.cgColor)
                    context.fillEllipse(in: CGRect(x: point.x - blobRadius, y: point.y - blobRadius, width: blobRadius * 2, height: blobRadius * 2))
                }
            }
        }
    }
}
