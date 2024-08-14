//
//  SimpleDrawCanvas.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/26/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

// Custom UIView subclass for a simple drawing canvas
class SimpleDrawCanvas: UIView {
    
    // MARK: - Properties
    
    var strokeColor = UIColor.black
    var strokeWidth: Float = 4.0
    var currentBrush: Brush = LineBrush()
    var isGridVisible = false
    var isMoveMode = false
    static let viewWasTouched = "viewWasTouched"
    var lastPoint = CGPoint.zero
    
    // Cached image to store the drawn content
    private var cachedImage: UIImage?
    
    // Arrays to track position changes for undo/redo in Move mode
    private var moveHistory: [([Line], Int, CGPoint)] = []
    private var redoMoveHistory: [([Line], Int, CGPoint)] = []
    
    // Arrays to store lines and redo actions
    fileprivate var lines = [Line]()
    fileprivate var redoLines = [Line]()
    private var movingShapeIndex: Int?
    
    // MARK: - Setup Functions
    
    // Set the stroke width for drawing
    func setStrokeWidth(width: Float) {
        self.strokeWidth = width
    }
    
    // Set the stroke color for drawing
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
    // Set the current brush tool for drawing
    func setBrush(_ brush: Brush) {
        self.currentBrush = brush
        if brush is EraserBrush {
            updateCachedImage()
        }
    }
    
    // Undo the last action (either in MovingMode or DrawingMode)
    func undo() {
        if isMoveMode {
            if let lastMove = moveHistory.popLast() {
                redoMoveHistory.append((lines, lastMove.1, lastMove.2))
                lines = lastMove.0
                updateCachedImage()
                setNeedsDisplay()
            }
        } else {
            if let lastLine = lines.popLast() {
                redoLines.append(lastLine)
                updateCachedImage()
                setNeedsDisplay()
            }
        }
    }
    
    // Redo the last undone action (either in MovingMode or DrawingMode)
    func redo() {
        if isMoveMode {
            if let lastRedoMove = redoMoveHistory.popLast() {
                moveHistory.append((lines, lastRedoMove.1, lastRedoMove.2))
                lines = lastRedoMove.0
                updateCachedImage()
                setNeedsDisplay()
            }
        } else {
            if let lastRedoLine = redoLines.popLast() {
                lines.append(lastRedoLine)
                updateCachedImage()
                setNeedsDisplay()
            }
        }
    }
    
    // Clear the canvas and reset all states
    func clear() {
        lines.removeAll()
        redoLines.removeAll()
        moveHistory.removeAll()
        redoMoveHistory.removeAll()
        cachedImage = nil
        setNeedsDisplay()
    }
    
    // MARK: - Drawing Method
    
    // Custom drawing method to render the canvas content
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Draw grid if visible
        if isGridVisible {
            drawGrid(in: context, rect: rect)
        }
        
        // Draw cached image
        cachedImage?.draw(in: rect)
        
        // Draw the new lines on top
        lines.forEach { line in
            line.brush.draw(in: context, with: line.points, strokeWidth: line.strokeWidth, strokeColor: line.color)
        }
    }
    
    // Draw grid on the canvas
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
    
    // MARK: - Touch Handling
    
    // Handle the beginning of a touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        if isMoveMode {
            // Handle move logic
            if let shapeIndex = hitTestShape(at: point) {
                movingShapeIndex = shapeIndex
                lastPoint = point
                // Save current state for undo in Move mode
                moveHistory.append((lines, shapeIndex, lastPoint))
                redoMoveHistory.removeAll()
            } else {
                movingShapeIndex = nil
            }
        } else {
            // Handle drawing logic
            var newLine = Line(strokeWidth: strokeWidth, color: strokeColor, points: [], brush: currentBrush)
            newLine.points.append(point) // Add the initial point to handle the dot case
            lines.append(newLine)
            redoLines.removeAll() // Clear redo stack when new line is drawn
            NotificationCenter.default.post(name: Notification.Name(SimpleDrawCanvas.viewWasTouched), object: nil)
            
            lastPoint = point
        }
    }
    
    // Handle the movement of a touch event
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        if isMoveMode, let shapeIndex = movingShapeIndex {
            // Handle move logic
            let dx = point.x - lastPoint.x
            let dy = point.y - lastPoint.y
            moveShape(at: shapeIndex, by: CGPoint(x: dx, y: dy))
            lastPoint = point
            setNeedsDisplay()
        } else if !isMoveMode {
            // Handle drawing logic
            guard var lastLine = lines.popLast() else { return }
            
            lastLine.points.append(point)
            lines.append(lastLine)
            
            // Only update the view if there are at least two points
            if lastLine.points.count > 1 {
                setNeedsDisplay()
            }
        }
    }
    
    // Handle the end of a touch event
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        if isMoveMode {
            // End move logic
            movingShapeIndex = nil
        } else {
            // Handle drawing logic
            guard var lastLine = lines.popLast() else { return }
            
            lastLine.points.append(point)
            lines.append(lastLine)
            updateCachedImage()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Utility Methods
    
    // Update the cached image with the current lines
    private func updateCachedImage() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Draw the existing lines into the cached image
        lines.forEach { line in
            line.brush.draw(in: context, with: line.points, strokeWidth: line.strokeWidth, strokeColor: line.color)
        }
        
        cachedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    // Calculate the bounding box for a given line
    private func calculateBounds(for line: Line) -> CGRect {
        guard let firstPoint = line.points.first else { return .zero }
        var minX = firstPoint.x
        var minY = firstPoint.y
        var maxX = firstPoint.x
        var maxY = firstPoint.y
        
        for point in line.points {
            minX = min(minX, point.x)
            minY = min(minY, point.y)
            maxX = max(maxX, point.x)
            maxY = max(maxY, point.y)
        }
        
        // Adding padding to avoid cutting off the strokes
        let padding: CGFloat = CGFloat(line.strokeWidth)
        return CGRect(x: minX - padding, y: minY - padding, width: maxX - minX + 2 * padding, height: maxY - minY + 2 * padding)
    }
    
    // Hit-test to find the shape index at a given point
    private func hitTestShape(at point: CGPoint) -> Int? {
        let increasedHitArea: CGFloat = 20.0 // Increase the hit area
        for (index, line) in lines.enumerated().reversed() {
            let boundingBox = calculateBounds(for: line).insetBy(dx: -increasedHitArea, dy: -increasedHitArea)
            if boundingBox.contains(point) {
                return index
            }
        }
        return nil
    }
    
    // Move the shape at a given index by a delta point
    private func moveShape(at index: Int, by delta: CGPoint) {
        for i in 0..<lines[index].points.count {
            lines[index].points[i] = CGPoint(x: lines[index].points[i].x + delta.x, y: lines[index].points[i].y + delta.y)
        }
        updateCachedImage()
    }
}

// MARK: - CGPoint Extension

// Extension to calculate the distance between two CGPoints
private extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
