//
//  SimpleDrawCanvas.swift
//  Test
//
//  Created by aidin ahmadian on 7/26/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

//MARK: - Setup Simple Draw View!

class SimpleDrawCanvas: UIView {
    
    var strokeColor = UIColor.black
    var strokeWidth: Float = 4.0
    static let viewWasTouched = "viewWasTouched"
    var lastPoint = CGPoint.zero
        
    //MARK: - Setup Functions!
    
    //Stroke Width
    
    func setStrokeWidth(width: Float) {
        self.strokeWidth = width
    }
    
    //Stroke Color
    
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
    // Undo Function
    
    func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    // Delete Function
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
        
    fileprivate var lines = [Line]()
    
    //MARK: - Setup Draw Rect
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
        NotificationCenter.default.post(name: Notification.Name(PatternView.viewWasTouched), object: nil)
        
        lastPoint = touches.first!.location(in: self)
    }
    
    //MARK: - Tracking The Finger
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
}
