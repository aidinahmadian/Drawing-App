//
//  SpiralBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/27/24.
//

import UIKit

class SpiralBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first, let lastPoint = points.last else { return }
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineDash(phase: 0, lengths: [])
        
        let center = firstPoint
        let maxRadius = hypot(lastPoint.x - firstPoint.x, lastPoint.y - firstPoint.y)
        let numberOfTurns = maxRadius / 20 // Adjust this value to control the density of the spiral
        let spacing: CGFloat = 10.0
        
        context.move(to: center)
        
        var angle: CGFloat = 0.0
        var radius: CGFloat = 0.0
        let step = 5 // Draw a point every 5 degrees to reduce the number of calculations
        let totalSteps = Int(numberOfTurns * 360 / CGFloat(step))
        
        for _ in 0..<totalSteps {
            angle += .pi * CGFloat(step) / 180
            radius += spacing * CGFloat(step) / 360
            if radius > maxRadius { break }
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            context.addLine(to: CGPoint(x: x, y: y))
        }
        
        context.strokePath()
    }
}
