//
//  TextureDrawableBrush.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/20/24.
//

//import UIKit
//
//class DrawableBrush: Brush {
//    func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
//        // This method should be overridden by subclasses
//    }
//}

//class TextureDrawableBrush: DrawableBrush {
//    let texture: UIImage
//    
//    init(texture: UIImage) {
//        self.texture = texture
//    }
//    
//    override func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
//        guard let cgImage = texture.cgImage, points.count > 1 else { return }
//        
//        context.saveGState()
//        
//        context.setLineCap(.round)
//        context.setLineJoin(.round)
//        
//        let textureSize = CGSize(width: CGFloat(strokeWidth) * 3, height: CGFloat(strokeWidth) * 3)
//        
//        let smoothedPoints = interpolatePointsWithHermite(points)
//        
//        for point in smoothedPoints {
//            let alpha = CGFloat.random(in: 0.6...0.9)
//            let color = strokeColor.withAlphaComponent(alpha).cgColor
//            
//            context.setStrokeColor(color)
//            context.setLineWidth(CGFloat(strokeWidth))
//            
//            let rect = CGRect(x: point.x - textureSize.width / 2, y: point.y - textureSize.height / 2, width: textureSize.width, height: textureSize.height)
//            
//            context.setBlendMode(.normal)
//            context.draw(cgImage, in: rect)
//        }
//        
//        context.restoreGState()
//    }
//    
//    private func interpolatePointsWithHermite(_ points: [CGPoint]) -> [CGPoint] {
//        guard points.count > 1 else { return points }
//        
//        var smoothedPoints: [CGPoint] = []
//        
//        for i in 0 ..< points.count - 1 {
//            let p0 = i > 0 ? points[i - 1] : points[i]
//            let p1 = points[i]
//            let p2 = points[i + 1]
//            let p3 = i < points.count - 2 ? points[i + 2] : points[i + 1]
//            
//            for t: CGFloat in stride(from: 0, through: 1, by: 0.1) {
//                let point = cubicHermite(p0: p0, p1: p1, p2: p2, p3: p3, t: t)
//                smoothedPoints.append(point)
//            }
//        }
//        
//        smoothedPoints.append(points.last!)
//        return smoothedPoints
//    }
//    
//    private func cubicHermite(p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint, t: CGFloat) -> CGPoint {
//        let t2 = t * t
//        let t3 = t2 * t
//        
//        let a = 2 * t3 - 3 * t2 + 1
//        let b = t3 - 2 * t2 + t
//        let c = t3 - t2
//        let d = -2 * t3 + 3 * t2
//        
//        let x = a * p1.x + b * (p2.x - p0.x) + c * (p3.x - p1.x) + d * p2.x
//        let y = a * p1.y + b * (p2.y - p0.y) + c * (p3.y - p1.y) + d * p2.y
//        
//        return CGPoint(x: x, y: y)
//    }
//}

//class TextureDrawableBrush: DrawableBrush {
//    let texture: UIImage
//    
//    init(texture: UIImage) {
//        self.texture = texture
//    }
//
////init(texture: UIImage) {
////        self.texture = texture.withRenderingMode(.alwaysTemplate)
////    }
//
//    override func draw(in context: CGContext, with points: [CGPoint], strokeWidth: Float, strokeColor: UIColor) {
//        guard let cgImage = texture.cgImage, points.count > 1 else { return }
//        
//        context.saveGState()
//        
//        context.setLineCap(.round)
//        context.setLineJoin(.round)
//        
//        let textureSize = CGSize(width: CGFloat(strokeWidth) * 3, height: CGFloat(strokeWidth) * 3)
//        
//        let smoothedPoints = interpolatePointsWithLinear(points, step: 5)
//        
//        for point in smoothedPoints {
//            let alpha = CGFloat.random(in: 0.6...0.9)
//            let color = strokeColor.withAlphaComponent(alpha).cgColor
//            
//            context.setStrokeColor(color)
//            context.setLineWidth(CGFloat(strokeWidth))
//            
//            let rect = CGRect(x: point.x - textureSize.width / 2, y: point.y - textureSize.height / 2, width: textureSize.width, height: textureSize.height)
//            
//            context.setBlendMode(.normal)
//            context.draw(cgImage, in: rect)
//        }
//        
//        context.restoreGState()
//    }
//    
//    private func interpolatePointsWithLinear(_ points: [CGPoint], step: CGFloat) -> [CGPoint] {
//        guard points.count > 1 else { return points }
//        
//        var smoothedPoints: [CGPoint] = []
//        
//        for i in 0..<points.count - 1 {
//            let p0 = points[i]
//            let p1 = points[i + 1]
//            
//            let distance = hypot(p1.x - p0.x, p1.y - p0.y)
//            let steps = max(1, Int(distance / step))
//            
//            for j in 0..<steps {
//                let t = CGFloat(j) / CGFloat(steps)
//                let x = p0.x + t * (p1.x - p0.x)
//                let y = p0.y + t * (p1.y - p0.y)
//                smoothedPoints.append(CGPoint(x: x, y: y))
//            }
//        }
//        
//        smoothedPoints.append(points.last!)
//        return smoothedPoints
//    }
//}
