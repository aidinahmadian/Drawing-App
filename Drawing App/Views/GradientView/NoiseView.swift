//
//  NoiseView.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/7/24.
//

import UIKit

// Custom UIView subclass that creates a noise effect overlay
class NoiseView: UIView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    // MARK: - Drawing Method
    
    // Custom drawing method to create a noise effect
    override func draw(_ rect: CGRect) {
        // Obtain the current graphics context
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Configuration for noise generation
        let noiseDensity: CGFloat = 0.5
        let noiseIntensity: CGFloat = 0.08
        
        // Generate noise by filling small rectangles randomly across the view
        for _ in 0..<(Int(rect.width * rect.height * noiseDensity)) {
            let x = CGFloat.random(in: 0..<rect.width)
            let y = CGFloat.random(in: 0..<rect.height)
            let alpha = CGFloat.random(in: 0..<1) * noiseIntensity
            
            // Set the fill color with varying alpha and draw a 1x1 pixel rectangle
            context.setFillColor(UIColor(white: 0, alpha: alpha).cgColor)
            context.fill(CGRect(x: x, y: y, width: 1, height: 1))
        }
    }
}
