//
//  GradientView.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/7/24.
//

import UIKit

class GradientView: UIView {
    private var colors: [CGColor] = [#colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1), UIColor.white.cgColor, UIColor.white.cgColor]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let locations: [CGFloat] = [0.0, 0.5, 1.0]
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locations) else { return }
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = max(rect.width, rect.height)
        
        context.drawRadialGradient(gradient,
                                   startCenter: center, startRadius: 0,
                                   endCenter: center, endRadius: radius,
                                   options: [.drawsAfterEndLocation])
    }
    
    func updateGradientColor(at index: Int, to color: UIColor) {
        guard index >= 0 && index < colors.count else { return }
        colors[index] = color.cgColor
        setNeedsDisplay()
    }
}
