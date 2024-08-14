//
//  RightTableViewCell.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/20/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

// MARK: - RightTableViewCell: Custom UITableViewCell

class RightTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    // First image view (imageB)
    lazy var imageB: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "testBrush1")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Second image view (imageV)
    private lazy var imageV: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "brush100")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Label to display the text (secondLabel)
    lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test Brush"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    // Initializer when creating the cell programmatically
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI() // Setup the UI elements
    }
    
    // Initializer when creating the cell from a storyboard or XIB file
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // Handle init with coder
    }
    
    // MARK: - UI Configuration
    
    // Method to configure the UI elements and set up constraints
    private func configureUI() {
        contentView.addSubview(imageV)
        contentView.addSubview(imageB)
        contentView.addSubview(secondLabel)
        
        NSLayoutConstraint.activate([
            imageV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            imageV.widthAnchor.constraint(equalToConstant: 50),
            imageV.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            imageB.leadingAnchor.constraint(equalTo: imageV.trailingAnchor, constant: 15),
            imageB.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageB.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            imageB.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            secondLabel.leadingAnchor.constraint(equalTo: imageV.trailingAnchor, constant: 15),
            secondLabel.topAnchor.constraint(equalTo: imageB.bottomAnchor, constant: 5),
            secondLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            secondLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Cell Selection Handling
    
    // Override method to handle cell selection and styling
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            generateHapticFeedback(.selection)
            contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        } else {
            // Remove the border when deselected
            contentView.backgroundColor = .white
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = nil
        }
        
        // Update the highlighted state for the image
        isHighlighted = selected
        imageB.isHighlighted = selected
    }
}
