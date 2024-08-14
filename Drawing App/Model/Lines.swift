//
//  Line.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/26/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

// MARK: - Line Struct

struct Line {
    var strokeWidth: Float
    var color: UIColor
    var points: [CGPoint]
    var brush: Brush

    init(strokeWidth: Float, color: UIColor, points: [CGPoint], brush: Brush) {
        self.strokeWidth = strokeWidth
        self.color = color
        self.points = points
        self.brush = brush
    }
}

// MARK: - LineWidthOption Struct

struct LineWidthOption {
    let width: Float
    let label: String
}

// MARK: - BrushItem Struct

struct BrushItem {
    let name: String
    let brush: Brush
}
