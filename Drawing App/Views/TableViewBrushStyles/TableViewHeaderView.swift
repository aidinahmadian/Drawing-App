//
//  TableViewHeaderView.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/20/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

// MARK: - TableViewHeaderView: Custom UIView for Table View Headers

class TableViewHeaderView: UIView {
    
    // MARK: - UI Elements
    
    // Label to display the name in the header
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    // MARK: - Initializers
    
    // Initializer when creating the view programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // Initializer when creating the view from a storyboard or XIB file
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    // Method to configure the view and set up constraints
    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

