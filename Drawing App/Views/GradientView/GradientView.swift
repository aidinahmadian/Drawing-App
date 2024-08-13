//
//  GradientView.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/7/24.
//

import UIKit

// Custom UIView subclass that displays a radial gradient
class GradientView: UIView {
    
    // MARK: - Properties
    
    // Array of colors used in the gradient
    private var colors: [CGColor] = [
        #colorLiteral(red: 0.6875687242, green: 0.9330262542, blue: 0.927660346, alpha: 1).cgColor,
        UIColor.white.cgColor,
        UIColor.white.cgColor
    ]
    
    // MARK: - Initializers
    
    // Initializer when creating the view programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    // Initializer when creating the view from a storyboard or XIB file
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    // MARK: - Drawing Method
    
    // Custom drawing method to render the radial gradient
    override func draw(_ rect: CGRect) {
        // Obtain the current graphics context
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Locations of the gradient colors (start, middle, and end)
        let locations: [CGFloat] = [0.0, 0.5, 1.0]
        
        // Create a gradient with the specified colors and locations
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: locations
        ) else { return }
        
        // Define the center and radius for the radial gradient
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = max(rect.width, rect.height)
        
        // Draw the radial gradient
        context.drawRadialGradient(
            gradient,
            startCenter: center, startRadius: 0,
            endCenter: center, endRadius: radius,
            options: [.drawsAfterEndLocation]
        )
    }
    
    // MARK: - Public Methods
    
    // Method to update the color at a specific index in the gradient
    func updateGradientColor(at index: Int, to color: UIColor) {
        // Ensure the index is within bounds
        guard index >= 0 && index < colors.count else { return }
        
        // Update the color at the specified index and request a redraw
        colors[index] = color.cgColor
        setNeedsDisplay() // Triggers a redraw to apply the color change
    }
}
