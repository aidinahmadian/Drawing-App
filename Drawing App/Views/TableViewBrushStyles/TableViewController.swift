//
//  TableViewController.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/5/24.
//

import UIKit

// MARK: - TableViewController: Custom UIViewController

class TableViewController: UIViewController {
    
    // MARK: - Properties
    
    // Left TableView for displaying line width options
    fileprivate lazy var leftTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor.clear
        tableView.register(LeftTableViewCell.self, forCellReuseIdentifier: "LeftTableViewCell")
        tableView.bounces = true
        return tableView
    }()
    
    // Right TableView for displaying brushes based on the selected line width
    fileprivate lazy var rightTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RightTableViewCell.self, forCellReuseIdentifier: "RightTableViewCell")
        tableView.bounces = true
        return tableView
    }()
    
    // Line width options for the left TableView
    fileprivate let lineWidthOptions: [LineWidthOption] = [
        LineWidthOption(width: 1.0, label: "Pencil"),
        LineWidthOption(width: 2.0, label: "Brushes"),
        LineWidthOption(width: 3.0, label: "Watercolors")
    ]
    
    // Brush data for the right TableView, organized by line width
    fileprivate lazy var brushData: [[Line]] = {
        let brushNames: [[String]] = [
            ["testBrush1", "brush2"],  // Brushes for 1.0 Points
            ["testBrush1", "brush3", "brush2"],  // Brushes for 2.0 Points
            ["testBrush1"]  // Brushes for 3.0 Points
        ]
        
        return zip(lineWidthOptions, brushNames).map { (option, names) in
            names.compactMap { name in
                if let image = UIImage(named: name) {
                    let brush = TextureDrawableBrush(texture: image)
                    return Line(strokeWidth: option.width, color: .clear, points: [], brush: brush)
                }
                return nil
            }
        }
    }()
    
    // Other properties to manage scrolling and selection state
    fileprivate var selectIndex = 0
    fileprivate var isScrollDown = true
    fileprivate var lastOffsetY: CGFloat = 0.0
    fileprivate var isManualScrolling = false
    fileprivate var isAutoScrolling = false
    fileprivate var isUserInteraction = false
    var canvas: SimpleDrawCanvas!
    weak var delegate: BrushSelectionDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: - UI Setup
    
    // Setup the navigation bar
    private func setupNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // Setup the UI elements and constraints
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Brush Library"
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
        
        setupConstraints()
        
        leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
    }
    
    // Setup the layout constraints for the TableViews
    private func setupConstraints() {
        leftTableView.translatesAutoresizingMaskIntoConstraints = false
        rightTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            leftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftTableView.widthAnchor.constraint(equalToConstant: 80),
            leftTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            rightTableView.topAnchor.constraint(equalTo: leftTableView.topAnchor, constant: 0),
            rightTableView.leadingAnchor.constraint(equalTo: leftTableView.trailingAnchor, constant: 5),
            rightTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),
            rightTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    // Action for the right bar button tap
    @objc private func rightBarButtonTapped() {
        let alert = UIAlertController(
            title: "Feature Coming Soon\n🤩",
            message: "This feature will be available in the near future.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        generateHapticFeedback(.soft)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Number of sections in the TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == leftTableView ? 1 : brushData.count
    }
    
    // Number of rows in each section of the TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == leftTableView ? lineWidthOptions.count : brushData[section].count
    }
    
    // Configure the cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell", for: indexPath) as! LeftTableViewCell
            let option = lineWidthOptions[indexPath.row]
            cell.nameLabel.text = option.label
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightTableViewCell", for: indexPath) as! RightTableViewCell
            let brush = brushData[indexPath.section][indexPath.row]
            // Configure cell with brush data
            cell.secondLabel.text = "Test Brush"
            //cell.imageView?.image = UIImage(named: brush.texture.accessibilityIdentifier ?? "")
            return cell
        }
    }
    
    // Height for the section headers
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == leftTableView ? 0 : 20
    }
    
    // View for the section headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableView != leftTableView else { return nil }
        let headerView = TableViewHeaderView()
        headerView.nameLabel.text = "Brushes \(section)"
        return headerView
    }
    
    // Handle when a section header is about to be displayed
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard tableView == rightTableView, !isScrollDown, !isManualScrolling, !isAutoScrolling else { return }
        updateLeftTableViewSelection(forSection: section)
    }
    
    // Handle when a section header ends displaying
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard tableView == rightTableView, isScrollDown, !isManualScrolling, !isAutoScrolling else { return }
        updateLeftTableViewSelection(forSection: section + 1)
    }
    
    // Update the selection in the left TableView based on the section in the right TableView
    private func updateLeftTableViewSelection(forSection section: Int) {
        guard section < lineWidthOptions.count else { return }
        isAutoScrolling = true
        leftTableView.selectRow(at: IndexPath(row: section, section: 0), animated: true, scrollPosition: .none)
        isAutoScrolling = false
    }
    
    // Handle row selection in the TableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView {
            rightTableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.row), at: .top, animated: true)
        } else {
            let selectedLine = brushData[indexPath.section][indexPath.row]
            delegate?.didSelectBrush(selectedLine.brush)
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension TableViewController {
    
    // Handle scroll events in the TableView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView, tableView == rightTableView else { return }
        
        isScrollDown = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
        
        if let firstVisibleIndexPath = rightTableView.indexPathsForVisibleRows?.first, !isManualScrolling, !isAutoScrolling {
            updateLeftTableViewSelection(forSection: firstVisibleIndexPath.section)
        }
    }
}
