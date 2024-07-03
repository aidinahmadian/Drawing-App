//
//  LeftTableViewCell.swift
//  Test
//
//  Created by aidin ahmadian on 7/20/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

//MARK: - Setup Left TableViewCell

class LeftTableViewCell: UITableViewCell {

    lazy var nameLabel = UILabel()
    private lazy var purpleView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        configureUI()
    }
    
    func configureUI () {
        nameLabel.frame = CGRect(x: 10, y: 10, width: 60, height: 40)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textColor = .gray
        nameLabel.highlightedTextColor = #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1)
        contentView.addSubview(nameLabel)
        
        purpleView.frame = CGRect(x: 0, y: 5, width: 5, height: 45)
        purpleView.backgroundColor = #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1)
        contentView.addSubview(purpleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = selected ? UIColor.white : #colorLiteral(red: 0.9739252856, green: 0.9739252856, blue: 0.9739252856, alpha: 1)
        isHighlighted = selected
        nameLabel.isHighlighted = selected
        purpleView.isHidden = !selected
    }
}
