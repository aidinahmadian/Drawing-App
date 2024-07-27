//
//  TriangleBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/27/24.
//

import UIKit

class TriangleBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first, let lastPoint = points.last else { return }
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineDash(phase: 0, lengths: [])
        
        // Calculate the third point of the triangle
        let midX = (firstPoint.x + lastPoint.x) / 2
        let topPoint = CGPoint(x: midX, y: min(firstPoint.y, lastPoint.y))
        
        // Use the first and last points as the base of the triangle
        let leftPoint = CGPoint(x: firstPoint.x, y: max(firstPoint.y, lastPoint.y))
        let rightPoint = CGPoint(x: lastPoint.x, y: max(firstPoint.y, lastPoint.y))
        
        // Draw the triangle
        context.move(to: topPoint)
        context.addLine(to: leftPoint)
        context.addLine(to: rightPoint)
        context.addLine(to: topPoint)
        
        context.strokePath()
    }
}
