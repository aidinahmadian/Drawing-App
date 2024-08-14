//
//  SymmetrixView.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/21/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit
import CoreGraphics

// MARK: - PatternView: Custom UIView for Drawing with Undo/Redo Functionality

class PatternView: UIView {
    
    // MARK: - Properties
    
    static let viewWasTouched = "viewWasTouched"
    
    // Arrays to keep track of the drawing states for undo and redo
    var undoStack: [UIImage] = []
    var redoStack: [UIImage] = []
    var currentImage: UIImage?
    
    // Core Graphics context for drawing
    lazy var bitmapCtx: CGContext? = {
        let width = Int(ceil(self.bounds.size.width * self.contentScaleFactor))
        let height = Int(ceil(self.bounds.size.height * self.contentScaleFactor))
        let RGB = CGColorSpaceCreateDeviceRGB()
        let BGRA = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        
        guard let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: RGB, bitmapInfo: BGRA.rawValue) else {
            return nil
        }
        
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
    
    // MARK: - Drawing Methods
    
    // Clear the canvas and reset the undo/redo stacks
    func clear() {
        guard let ctx = bitmapCtx else { return }
        ctx.fill(self.bounds)
        undoStack.removeAll()
        redoStack.removeAll()
        setNeedsDisplay()
    }
    
    // Undo the last drawing action
    func undo() {
        guard !undoStack.isEmpty else { return }
        
        if let currentImage = getImage() {
            redoStack.append(currentImage)
        }
        
        let previousImage = undoStack.removeLast()
        guard let ctx = bitmapCtx else { return }
        
        ctx.saveGState()
        ctx.setBlendMode(.copy)
        ctx.draw(previousImage.cgImage!, in: self.bounds)
        ctx.restoreGState()
        
        setNeedsDisplay()
    }
    
    // Redo the last undone drawing action
    func redo() {
        guard !redoStack.isEmpty else { return }
        
        if let currentImage = getImage() {
            undoStack.append(currentImage)
        }
        
        let nextImage = redoStack.removeLast()
        guard let ctx = bitmapCtx else { return }
        
        ctx.saveGState()
        ctx.setBlendMode(.copy)
        ctx.draw(nextImage.cgImage!, in: self.bounds)
        ctx.restoreGState()
        
        setNeedsDisplay()
    }
    
    // Get the current image from the context
    func getImage() -> UIImage? {
        guard let ctx = bitmapCtx, let image = ctx.makeImage() else { return nil }
        return UIImage(cgImage: image)
    }
    
    // Draw a line between the start and end points, repeated for a circular pattern
    func drawLine(startPoint: CGPoint, endPoint: CGPoint) {
        guard let ctx = bitmapCtx else { return }
        
        ctx.setLineWidth(lineWidth)
        ctx.setStrokeColor(lineColor.cgColor)
        
        let inset = ceil(lineWidth * 0.5)
        let centre = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        for t in 0..<turns {
            let angle = CGFloat(t) / CGFloat(turns) * CGFloat(.pi * 2.0)
            let rotation = CGAffineTransform(rotationAngle: angle)
            
            var transform = CGAffineTransform(translationX: centre.x, y: centre.y)
            transform = rotation.concatenating(transform)
            transform = transform.translatedBy(x: -centre.x, y: -centre.y)
            
            let start = startPoint.applying(transform)
            let end = endPoint.applying(transform)
            
            ctx.move(to: start)
            ctx.addLine(to: end)
            ctx.strokePath()
            
            let origin = CGPoint(x: min(start.x, end.x), y: min(start.y, end.y))
            let size = CGSize(width: abs(start.x - end.x), height: abs(start.y - end.y))
            
            let dirtyRect = CGRect(origin: origin, size: size).insetBy(dx: -inset, dy: -inset)
            setNeedsDisplay(dirtyRect)
        }
    }
    
    // MARK: - Touch Handling
    
    // Handle the beginning of a touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: Notification.Name(PatternView.viewWasTouched), object: nil)
        
        lastPoint = touches.first!.location(in: self)
        
        // Save the current state at the beginning of a drawing action
        if let image = getImage() {
            currentImage = image
        }
    }
    
    // Handle the movement of a touch event
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        drawLine(startPoint: lastPoint, endPoint: point)
        lastPoint = point
    }
    
    // Handle the end of a touch event
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        drawLine(startPoint: lastPoint, endPoint: point)
        
        // Push the saved state to the undo stack once the drawing is complete
        if let image = currentImage {
            undoStack.append(image)
            currentImage = nil
            redoStack.removeAll()
        }
    }
    
    // MARK: - Draw Method
    
    // Render the current content of the context onto the view
    override func draw(_ rect: CGRect) {
        guard let ctx = bitmapCtx, let image = ctx.makeImage(), let viewCtx = UIGraphicsGetCurrentContext() else { return }
        viewCtx.setBlendMode(.copy)
        viewCtx.interpolationQuality = .none
        viewCtx.draw(image, in: rect, byTiling: false)
    }
}
