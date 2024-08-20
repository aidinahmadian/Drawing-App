//
//  RectangleBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/27/24.
//

import UIKit

// MARK: - Rect Brush

class RectangleBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first, let lastPoint = points.last else { return }
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineCap(.butt)
        context.setLineDash(phase: 0, lengths: [])
        
        let rect = CGRect(x: min(firstPoint.x, lastPoint.x),
                          y: min(firstPoint.y, lastPoint.y),
                          width: abs(lastPoint.x - firstPoint.x),
                          height: abs(lastPoint.y - firstPoint.y))
        
        context.addRect(rect)
        context.strokePath()
    }
}
