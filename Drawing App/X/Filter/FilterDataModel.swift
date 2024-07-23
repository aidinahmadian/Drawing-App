//
//  FilterDataModel.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 06/02/22.
//

import Foundation

struct FilterDataModel {
    let category: String
    var options: [FilterOptions]
    let isMultiple: Bool
    let ischangesApplied: Bool
}

struct FilterOptions {
    var isSelected: Bool
    let title: String
}


var filterMockData = [
    FilterDataModel(category: "sort", options: [
        FilterOptions(isSelected: false, title: "Relevance"),
        FilterOptions(isSelected: false, title: "Thickness"),
        FilterOptions(isSelected: false, title: "Rating"),
        FilterOptions(isSelected: false, title: "Cost: Low to High"),
        FilterOptions(isSelected: false, title: "Cost: High to Low")
    ], isMultiple: false, ischangesApplied: false),
    
    FilterDataModel(category: "brushes", options: [
        FilterOptions(isSelected: false, title: "LineBrush"),
        FilterOptions(isSelected: false, title: "DottedBrush"),
        FilterOptions(isSelected: false, title: "ChalkBrush"),
        FilterOptions(isSelected: false, title: "RustBrush"),
        FilterOptions(isSelected: false, title: "SquareTextureBrush"),
        FilterOptions(isSelected: false, title: "PencilBrush"),
        FilterOptions(isSelected: false, title: "CharcoalBrush"),
        FilterOptions(isSelected: false, title: "PastelBrush"),
        FilterOptions(isSelected: false, title: "WatercolorBrush"),
        FilterOptions(isSelected: false, title: "SplaterBrush"),
        FilterOptions(isSelected: false, title: "IncBrush"),
        FilterOptions(isSelected: false, title: "CustomBrush 1"),
        FilterOptions(isSelected: false, title: "CustomBrush 2"),
        FilterOptions(isSelected: false, title: "CustomBrush 3"),
        FilterOptions(isSelected: false, title: "CustomBrush 4"),
        FilterOptions(isSelected: false, title: "CustomBrush 5"),
        FilterOptions(isSelected: false, title: "CustomBrush 6"),
        FilterOptions(isSelected: false, title: "CustomBrush 7"),
        FilterOptions(isSelected: false, title: "CustomBrush 8"),
        FilterOptions(isSelected: false, title: "CustomBrush 9"),
        FilterOptions(isSelected: false, title: "CustomBrush 10"),
        FilterOptions(isSelected: false, title: "CustomBrush 11"),
        FilterOptions(isSelected: false, title: "CustomBrush 12"),
        FilterOptions(isSelected: false, title: "CustomBrush 13"),
        FilterOptions(isSelected: false, title: "CustomBrush 14")
    ], isMultiple: true, ischangesApplied: false),
    
    FilterDataModel(category: "show brushes with", options: [
        FilterOptions(isSelected: false, title: "pure veg")
    ], isMultiple: true, ischangesApplied: false),
]
