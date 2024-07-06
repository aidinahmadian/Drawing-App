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
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageV: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .red
        label.backgroundColor = .blue
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
        contentView.addSubview(nameLabel)
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
            nameLabel.leadingAnchor.constraint(equalTo: imageV.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Price Label Constraints
        NSLayoutConstraint.activate([
            secondLabel.leadingAnchor.constraint(equalTo: imageV.trailingAnchor, constant: 15),
            secondLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            secondLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            secondLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = selected ? UIColor(red: 0.57, green: 0.27, blue: 1.0, alpha: 1.0) : .white
        contentView.layer.cornerRadius = 10
        isHighlighted = selected
        nameLabel.isHighlighted = selected
    }
}
