//
//  RightTableViewCell.swift
//  Test
//
//  Created by aidin ahmadian on 7/20/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

//MARK: - Setup Right TableViewCell

class RightTableViewCell: UITableViewCell {
    
    lazy var imageB: UIImageView = {
        let label = UIImageView()
        label.image = UIImage(named: "testBrush1")
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageV: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "brush100")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test Brush"
        //label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(imageV)
        contentView.addSubview(imageB)
        contentView.addSubview(secondLabel)
        
        // Image View Constraints
        NSLayoutConstraint.activate([
            imageV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            imageV.widthAnchor.constraint(equalToConstant: 50),
            imageV.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Name Label Constraints
        NSLayoutConstraint.activate([
            imageB.leadingAnchor.constraint(equalTo: imageV.trailingAnchor, constant: 15),
            imageB.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageB.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            imageB.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Price Label Constraints
        NSLayoutConstraint.activate([
            secondLabel.leadingAnchor.constraint(equalTo: imageV.trailingAnchor, constant: 15),
            secondLabel.topAnchor.constraint(equalTo: imageB.bottomAnchor, constant: 5),
            secondLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            secondLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            generateHapticFeedback(.selection)
            contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            // Optional: Add a border
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        } else {
            contentView.backgroundColor = .white
            // Optional: Remove the border
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = nil
        }
        
        isHighlighted = selected
        imageB.isHighlighted = selected
    }
}
