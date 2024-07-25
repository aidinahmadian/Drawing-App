//
//  ArrayTableViewController.swift
//  Test
//
//  Created by aidin ahmadian on 7/21/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class ArrayChoiceTableViewController<Element: Equatable>: UITableViewController {

    typealias SelectionHandler = (Element) -> Void
    typealias LabelProvider = (Element) -> NSAttributedString

    private let values: [Element]
    private let labels: LabelProvider
    private let onSelect: SelectionHandler?
    private let header: String?
    private let selectedValue: Element?

    init(_ values: [Element], selectedValue: Element?, header: String? = nil, labels: @escaping LabelProvider, onSelect: SelectionHandler? = nil) {
        self.values = values
        self.selectedValue = selectedValue
        self.onSelect = onSelect
        self.labels = labels
        self.header = header
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the table view's background color
        tableView.backgroundColor = UIColor.white

        // Customize the cells' background color
        tableView.separatorColor = UIColor.clear
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.attributedText = labels(values[indexPath.row])
        
        // Set custom background color for cells
        cell.backgroundColor = UIColor.white

        // Customize background view for selected cell
        if values[indexPath.row] == selectedValue {
            let customBackgroundView = UIView()
            customBackgroundView.backgroundColor = UIColor.systemGray6
            customBackgroundView.layer.cornerRadius = 10
            customBackgroundView.layer.masksToBounds = true
            
            let contentView = UIView()
            contentView.backgroundColor = .clear
            contentView.addSubview(customBackgroundView)
            customBackgroundView.translatesAutoresizingMaskIntoConstraints = false

            // Set constraints to reduce the left and right margins
            NSLayoutConstraint.activate([
                customBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
                customBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
                customBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
                customBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])

            cell.backgroundView = contentView
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            cell.backgroundView = nil
        }

        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Scroll to the selected item
        if let selectedValue = selectedValue, let selectedIndex = values.firstIndex(of: selectedValue) {
            let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
            tableView.scrollToRow(at: selectedIndexPath, at: .middle, animated: false)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        generateHapticFeedback(.selection)
        self.dismiss(animated: true)
        onSelect?(values[indexPath.row])
    }
}
