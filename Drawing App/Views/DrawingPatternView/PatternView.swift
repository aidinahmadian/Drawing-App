//
//  SymmetrixView.swift
//  Test
//
//  Created by aidin ahmadian on 7/21/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit
import CoreGraphics

//MARK: - Setup Pattern View

class PatternView: UIView {
    
    static let viewWasTouched = "viewWasTouched"
    lazy var bitmapCtx: CGContext? = {
        let width = Int(ceil(self.bounds.size.width * self.contentScaleFactor))
        let height = Int(ceil(self.bounds.size.height * self.contentScaleFactor))
        let RGB = CGColorSpaceCreateDeviceRGB()
        let BGRA = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: RGB, bitmapInfo: BGRA.rawValue) else { return nil }
        ctx.setLineCap(CGLineCap.round)
        ctx.setLineJoin(CGLineJoin.round)
        ctx.scaleBy(x: self.contentScaleFactor, y: self.contentScaleFactor)
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(self.bounds)
        return ctx
    }()
    
    var lastPoint = CGPoint.zero
    var lineWidth: CGFloat = 4.0
    var lineColor = UIColor.black
    var turns = 16
    
    //MARK: - Setup Delete All Function
    
    func clear() {
        guard let ctx = bitmapCtx else { return }
        ctx.fill(self.bounds)
        setNeedsDisplay()
    }
    
    //MARK: - Setup getImage (For Saving The Image)
    
    func getImage() -> UIImage? {
        guard let ctx = bitmapCtx, let image = ctx.makeImage() else { return nil }
        return UIImage(cgImage: image)
    }
    
    //MARK: - Setup DrawLine
    
    func drawLine(startPoint: CGPoint, endPoint: CGPoint) {
        guard let ctx = bitmapCtx else { return }
        
        ctx.setLineWidth(lineWidth)
        ctx.setStrokeColor(lineColor.cgColor)
        
        let inset = ceil(lineWidth * 0.5)
        let centre = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        for t in 0 ..< turns {
            let angle = CGFloat(t) / CGFloat(turns) * CGFloat(.pi * 2.0)
            let rotation = CGAffineTransform(rotationAngle: angle)
            
            var m = CGAffineTransform(translationX: centre.x, y: centre.y)
            m = rotation.concatenating(m)
            m = m.translatedBy(x: -centre.x, y: -centre.y)
            
            let start = startPoint.applying(m)
            let end = endPoint.applying(m)
            
            ctx.move(to: start)
            ctx.addLine(to: end)
            ctx.strokePath()
            
            let origin = CGPoint(x: min(start.x, end.x), y: min(start.y, end.y))
            let size = CGSize(width:abs(start.x - end.x), height:abs(start.y - end.y))
            
            let dirtyRect = CGRect(origin:origin, size:size).insetBy(dx: -inset, dy: -inset)
            setNeedsDisplay(dirtyRect)
        }
    }
    
    //MARK: - Setup Functions

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: Notification.Name(PatternView.viewWasTouched), object: nil)
        
        lastPoint = touches.first!.location(in: self)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        drawLine(startPoint: lastPoint, endPoint: point)
        lastPoint = point
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        drawLine(startPoint: lastPoint, endPoint: point)
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = bitmapCtx, let image = ctx.makeImage(), let viewCtx = UIGraphicsGetCurrentContext() else { return }
        viewCtx.setBlendMode(.copy)
        viewCtx.interpolationQuality = .none
        viewCtx.draw(image, in: rect, byTiling: false)
    }
}
