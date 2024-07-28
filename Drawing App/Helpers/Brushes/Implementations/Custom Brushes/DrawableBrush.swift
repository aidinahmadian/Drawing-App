//
//  TextureDrawableBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/28/24.
//

import UIKit

class TextureDrawableBrush: Brush {
    
    let texture: UIImage
    init(texture: UIImage) {
        self.texture = texture
    }

    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
        guard points.count > 1 else { return }

        context.saveGState()
        context.setLineCap(.round)
        context.setLineJoin(.round)

        let textureSize = CGSize(width: CGFloat(strokeWidth) * 3, height: CGFloat(strokeWidth) * 3)
        let smoothedPoints = interpolatePointsWithLinear(points, step: 5)
        let tintedTexture = tintedImage(using: strokeColor)

        for point in smoothedPoints {
            let rect = CGRect(x: point.x - textureSize.width / 2, y: point.y - textureSize.height / 2, width: textureSize.width, height: textureSize.height)
            if let cgImage = tintedTexture.cgImage {
                context.draw(cgImage, in: rect)
            }
        }

        context.restoreGState()
    }

    private func tintedImage(using color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(texture.size, false, texture.scale)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = texture.cgImage else {
            UIGraphicsEndImageContext()
            return texture
        }

        let rect = CGRect(origin: .zero, size: texture.size)
        
        color.setFill()
        context.fill(rect)
        
        context.setBlendMode(.destinationIn)
        context.draw(cgImage, in: rect)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage ?? texture
    }

    private func interpolatePointsWithLinear(_ points: [CGPoint], step: CGFloat) -> [CGPoint] {
        guard points.count > 1 else { return points }

        var smoothedPoints: [CGPoint] = []

        for i in 0..<points.count - 1 {
            let p0 = points[i]
            let p1 = points[i + 1]

            let distance = hypot(p1.x - p0.x, p1.y - p0.y)
            let steps = max(1, Int(distance / step))

            for j in 0...steps {
                let t = CGFloat(j) / CGFloat(steps)
                let x = p0.x + t * (p1.x - p0.x)
                let y = p0.y + t * (p1.y - p0.y)
                smoothedPoints.append(CGPoint(x: x, y: y))
            }
        }

        smoothedPoints.append(points.last!)
        return smoothedPoints
    }
}
