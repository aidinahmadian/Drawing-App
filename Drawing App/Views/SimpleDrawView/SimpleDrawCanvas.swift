//
//  SimpleDrawCanvas.swift
//  Test
//
//  Created by aidin ahmadian on 7/26/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class SimpleDrawCanvas: UIView {
    
    var strokeColor = UIColor.black
    var strokeWidth: Float = 4.0
    var currentBrush: Brush = LineBrush()
    static let viewWasTouched = "viewWasTouched"
    var lastPoint = CGPoint.zero
        
    // MARK: - Setup Functions
    
    func setStrokeWidth(width: Float) {
        self.strokeWidth = width
    }
    
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
    func setBrush(_ brush: Brush) {
        self.currentBrush = brush
    }
    
    func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
        
    fileprivate var lines = [Line]()
    
    // MARK: - Setup Draw Rect
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        lines.forEach { (line) in
            line.brush.draw(in: context, with: line.points, strokeWidth: line.strokeWidth, strokeColor: line.color)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line(strokeWidth: strokeWidth, color: strokeColor, points: [], brush: currentBrush))
        NotificationCenter.default.post(name: Notification.Name(SimpleDrawCanvas.viewWasTouched), object: nil)
        
        lastPoint = touches.first!.location(in: self)
    }
    
    // MARK: - Tracking The Finger
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
}
