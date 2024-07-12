//
//  SquareTextureBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/11/24.
//

import Foundation
import UIKit

class SquareTextureBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setLineCap(.square)
        for point in points.dropFirst() {
            let alpha = CGFloat.random(in: 0.5...0.9)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            context.setLineWidth(CGFloat(strokeWidth))
            
            context.addLine(to: point)
            context.strokePath()
            context.move(to: point)
            
            let squareSize = CGFloat(strokeWidth)
            let squareRect = CGRect(
                x: point.x - squareSize / 2,
                y: point.y - squareSize / 2,
                width: squareSize,
                height: squareSize
            )
            context.setFillColor(color)
            context.fill(squareRect)
        }
    }
}
