//
//  Page.swift
//  Test
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import Foundation

struct Page {
    let imageName: String?
    let videoName: String?
    let headerText: String
    let bodyText: String
    
    init(imageName: String? = nil, videoName: String? = nil, headerText: String, bodyText: String) {
        self.imageName = imageName
        self.videoName = videoName
        self.headerText = headerText
        self.bodyText = bodyText
    }
}
