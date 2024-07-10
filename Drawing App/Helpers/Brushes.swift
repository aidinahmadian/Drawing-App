//
//  LineBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/9/24.
//

import UIKit

protocol Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor)
}

class LineBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineCap(.round)
        context.setLineDash(phase: 0, lengths: []) //Resets line dash to solid
        for point in points.dropFirst() {
            context.addLine(to: point)
        }
        context.strokePath()
    }
}

class DottedBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(CGFloat(strokeWidth))
        context.setLineCap(.round)
        context.setLineDash(phase: 0, lengths: [CGFloat(strokeWidth * 2), CGFloat(strokeWidth * 2)]) //Set line dash pattern
        for point in points.dropFirst() {
            context.addLine(to: point)
        }
        context.strokePath()
    }
}

class ChalkBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        for (i, point) in points.enumerated() {
            context.setLineWidth(CGFloat(strokeWidth))
            let alpha = CGFloat.random(in: 0.3...0.7)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            
            if i > 0 {
                let jitteredPoint = CGPoint(
                    x: point.x + CGFloat.random(in: -1...1),
                    y: point.y + CGFloat.random(in: -1...1)
                )
                context.addLine(to: jitteredPoint)
                context.strokePath()
                context.move(to: jitteredPoint)
            }
        }
    }
}

class RustBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setLineCap(.round)
        for point in points.dropFirst() {
            let alpha = CGFloat.random(in: 0.5...0.8)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            
            context.setLineWidth(CGFloat(strokeWidth))
            context.addLine(to: point)
            context.strokePath()
            context.move(to: point)
            
            let circleRadius = CGFloat(strokeWidth / 2)
            let circleRect = CGRect(
                x: point.x - circleRadius,
                y: point.y - circleRadius,
                width: circleRadius * 2,
                height: circleRadius * 2
            )
            context.setFillColor(color)
            context.fillEllipse(in: circleRect)
        }
    }
}


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

class PencilBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        for point in points.dropFirst() {
            context.setLineWidth(CGFloat(strokeWidth))
            let alpha = CGFloat.random(in: 0.5...1.0)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            
            context.addLine(to: point)
            context.strokePath()
            context.move(to: point)
        }
    }
}

class CharcoalBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        for point in points.dropFirst() {
            let alpha = CGFloat.random(in: 0.3...0.7)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            context.setLineWidth(CGFloat(strokeWidth * 2))
            
            context.addLine(to: point)
            context.strokePath()
            context.move(to: point)
            
            context.setFillColor(color)
            let offset = CGFloat(strokeWidth)
            context.fillEllipse(in: CGRect(x: point.x - offset, y: point.y - offset, width: offset * 2, height: offset * 2))
        }
    }
}


class PastelBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        for point in points.dropFirst() {
            let alpha = CGFloat.random(in: 0.6...0.9)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            context.setLineWidth(CGFloat(strokeWidth * 3))
            
            context.addLine(to: point)
            context.strokePath()
            context.move(to: point)
            
            context.setFillColor(color)
            let offset = CGFloat(strokeWidth)
            context.fillEllipse(in: CGRect(x: point.x - offset, y: point.y - offset, width: offset * 2, height: offset * 2))
        }
    }
}

class WatercolorBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        guard let firstPoint = points.first else { return }
        context.move(to: firstPoint)
        
        for (i, point) in points.enumerated() {
            context.setLineWidth(CGFloat(strokeWidth))
            let alpha = CGFloat.random(in: 0.1...0.5)
            let color = strokeColor.withAlphaComponent(alpha).cgColor
            context.setStrokeColor(color)
            
            if i > 0 {
                let jitteredPoint = CGPoint(
                    x: point.x + CGFloat.random(in: -1...1),
                    y: point.y + CGFloat.random(in: -1...1)
                )
                context.addLine(to: jitteredPoint)
                context.strokePath()
                context.move(to: jitteredPoint)
            }
        }
    }
}

class SplatterBrush: Brush {
    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        for point in points {
            let splatterCount = Int.random(in: 5...15)
            for _ in 0..<splatterCount {
                let radius = CGFloat.random(in: 1...CGFloat(strokeWidth))
                let offsetX = CGFloat.random(in: -10...10)
                let offsetY = CGFloat.random(in: -10...10)
                let splatterPoint = CGPoint(x: point.x + offsetX, y: point.y + offsetY)
                
                let alpha = CGFloat.random(in: 0.3...0.8)
                let color = strokeColor.withAlphaComponent(alpha).cgColor
                context.setFillColor(color)
                context.fillEllipse(in: CGRect(x: splatterPoint.x - radius, y: splatterPoint.y - radius, width: radius * 2, height: radius * 2))
            }
        }
    }
}

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
