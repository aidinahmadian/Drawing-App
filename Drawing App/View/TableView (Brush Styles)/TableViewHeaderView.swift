//
//  TableViewHeaderView.swift
//  Test
//
//  Created by aidin ahmadian on 7/20/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

//MARK: - Setup TableView Header

class TableViewHeaderView: UIView {
 
    lazy var nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nameLabel.frame = CGRect(x: 15, y: 0, width: 200, height: 20)
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.text = "123"
        addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
