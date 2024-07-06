
import UIKit

// MARK: - Setup Left TableViewCell

class LeftTableViewCell: UITableViewCell {

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.highlightedTextColor = UIColor(red: 0.57, green: 0.27, blue: 1.00, alpha: 1.00)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var purpleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.57, green: 0.27, blue: 1.00, alpha: 1.00)
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
        contentView.addSubview(purpleView)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 60),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            purpleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            purpleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            purpleView.widthAnchor.constraint(equalToConstant: 5),
            purpleView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = selected ? .white : UIColor(white: 0.97, alpha: 1.0)
        nameLabel.isHighlighted = selected
        purpleView.isHidden = !selected
    }
}
