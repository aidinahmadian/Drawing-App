//
//  Line.swift
//  Test
//
//  Created by aidin ahmadian on 7/26/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

struct Line {
    var strokeWidth: Float
    var color: UIColor
    var points: [CGPoint]
    var brush: Brush
}

struct LineWidthOption {
    let width: Float
    let label: String
}
