//
//  LeftTableViewCell.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/5/24.
//

import UIKit

// MARK: - Setup Left TableViewCell

class LeftTableViewCell: UITableViewCell {

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.highlightedTextColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var customGreenView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }
    
    private func configureUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(customGreenView)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 60),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            customGreenView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customGreenView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            customGreenView.widthAnchor.constraint(equalToConstant: 5),
            customGreenView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = selected ? .white : UIColor(white: 0.97, alpha: 1.0)
        nameLabel.isHighlighted = selected
        customGreenView.isHidden = !selected
    }
}
