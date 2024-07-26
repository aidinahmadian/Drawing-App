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
    var isGridVisible = false
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
        if let lastLine = lines.popLast() {
            redoLines.append(lastLine)
            setNeedsDisplay()
        }
    }
    
    func redo() {
        if let lastRedoLine = redoLines.popLast() {
            lines.append(lastRedoLine)
            setNeedsDisplay()
        }
    }
    
    func clear() {
        lines.removeAll()
        redoLines.removeAll()
        setNeedsDisplay()
    }
    
    fileprivate var lines = [Line]()
    fileprivate var redoLines = [Line]() // Add this line
    
    // MARK: - Setup Draw Rect
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Draw grid if visible
        if isGridVisible {
            drawGrid(in: context, rect: rect)
        }
        
        lines.forEach { (line) in
            line.brush.draw(in: context, with: line.points, strokeWidth: line.strokeWidth, strokeColor: line.color)
        }
    }
    
    private func drawGrid(in context: CGContext, rect: CGRect) {
        let gridSize: CGFloat = 20.0
        
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.lightGray.cgColor)
        
        for x in stride(from: 0, to: rect.width, by: gridSize) {
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        for y in stride(from: 0, to: rect.height, by: gridSize) {
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        context.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        var newLine = Line(strokeWidth: strokeWidth, color: strokeColor, points: [], brush: currentBrush)
        newLine.points.append(point) // Add the initial point to handle the dot case
        lines.append(newLine)
        redoLines.removeAll() // Clear redo stack when new line is drawn
        setNeedsDisplay()
        NotificationCenter.default.post(name: Notification.Name(SimpleDrawCanvas.viewWasTouched), object: nil)
        
        lastPoint = point
    }
    
    // MARK: - Tracking The Finger
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
}
