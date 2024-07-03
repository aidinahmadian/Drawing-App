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
    
    lazy var nameLabel = UILabel()
    private lazy var imageV = UIImageView()
    private lazy var priceLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
        
    func configureUI() {
        imageV.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        imageV.backgroundColor = .darkGray
        contentView.addSubview(imageV)
        
        nameLabel.frame = CGRect(x: 80, y: 10, width: 200, height: 30)
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.backgroundColor = .black
        contentView.addSubview(nameLabel)
        
        priceLabel.frame = CGRect(x: 80, y: 45, width: 200, height: 30)
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = UIColor.red
        priceLabel.backgroundColor = .blue
        contentView.addSubview(priceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.backgroundColor = selected ? #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 10
        isHighlighted = selected
        nameLabel.isHighlighted = selected
    }
}
