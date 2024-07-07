//
//  NoiseView.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/7/24.
//

import UIKit

class NoiseView: UIView {
    
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
        
        let noiseDensity: CGFloat = 0.5
        let noiseIntensity: CGFloat = 0.08
        
        for _ in 0..<(Int(rect.width * rect.height * noiseDensity)) {
            let x = CGFloat.random(in: 0..<rect.width)
            let y = CGFloat.random(in: 0..<rect.height)
            let alpha = CGFloat.random(in: 0..<1) * noiseIntensity
            
            context.setFillColor(UIColor(white: 0, alpha: alpha).cgColor)
            context.fill(CGRect(x: x, y: y, width: 1, height: 1))
        }
    }
}
