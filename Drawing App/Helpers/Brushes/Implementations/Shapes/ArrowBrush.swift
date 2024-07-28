//
//  ArrowBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/27/24.
//

import UIKit

class ArrowBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let startPoint = points.first, let endPoint = points.last else { return }
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineCap(.round)
        context.setLineDash(phase: 0, lengths: [])
        
        let arrowLength: CGFloat = 15.0
        let arrowAngle: CGFloat = CGFloat.pi / 6.0
        
        // Calculate the line from start to end
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        
        // Calculate the angle of the arrow
        let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
        
        // Calculate the points for the arrowhead
        let arrowPoint1 = CGPoint(
            x: endPoint.x - arrowLength * cos(angle + arrowAngle),
            y: endPoint.y - arrowLength * sin(angle + arrowAngle)
        )
        let arrowPoint2 = CGPoint(
            x: endPoint.x - arrowLength * cos(angle - arrowAngle),
            y: endPoint.y - arrowLength * sin(angle - arrowAngle)
        )
        
        // Draw the arrowhead
        context.move(to: endPoint)
        context.addLine(to: arrowPoint1)
        context.move(to: endPoint)
        context.addLine(to: arrowPoint2)
        
        context.strokePath()
    }
}
