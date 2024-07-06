//
//  TableViewController.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/5/24.
//

import UIKit

class OldTableViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate lazy var leftTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor.clear
        tableView.register(LeftTableViewCell.self, forCellReuseIdentifier: kLeftTableViewCell)
        tableView.bounces = false
        return tableView
    }()
    
    fileprivate lazy var rightTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RightTableViewCell.self, forCellReuseIdentifier: kRightTableViewCell)
        tableView.bounces = true
        return tableView
    }()
    
    fileprivate let categoryData = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V"]
    fileprivate let foodData: [[String]] = {
        let data = Array(repeating: (1...20).map { "\($0)" }, count: 5).flatMap { $0 }
        return Array(repeating: data, count: 22)
    }()
    
    fileprivate var selectIndex = 0
    fileprivate var isScrollDown = true
    fileprivate var lastOffsetY: CGFloat = 0.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Brush Library"
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
        
        setupConstraints()
        
        leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
    }
    
    private func setupConstraints() {
        leftTableView.translatesAutoresizingMaskIntoConstraints = false
        rightTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftTableView.topAnchor.constraint(equalTo: view.topAnchor),
            leftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftTableView.widthAnchor.constraint(equalToConstant: 80),
            leftTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            rightTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            rightTableView.leadingAnchor.constraint(equalTo: leftTableView.trailingAnchor, constant: 5),
            rightTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),
            rightTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension OldTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == leftTableView ? 1 : categoryData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == leftTableView ? categoryData.count : foodData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: kLeftTableViewCell, for: indexPath) as! LeftTableViewCell
            cell.nameLabel.text = categoryData[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kRightTableViewCell, for: indexPath) as! RightTableViewCell
            cell.nameLabel.text = foodData[indexPath.section][indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == leftTableView ? 0 : 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableView != leftTableView else { return nil }
        let headerView = TableViewHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        headerView.nameLabel.text = categoryData[section]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard tableView == rightTableView, !isScrollDown, tableView.isDragging || tableView.isDecelerating else { return }
        selectRow(at: section)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard tableView == rightTableView, isScrollDown, tableView.isDragging || tableView.isDecelerating else { return }
        selectRow(at: section + 1)
    }
    
    private func selectRow(at index: Int) {
        leftTableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .top)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView == leftTableView else { return }
        selectIndex = indexPath.row
        rightTableView.scrollToRow(at: IndexPath(row: 0, section: selectIndex), at: .top, animated: true)
        leftTableView.scrollToRow(at: IndexPath(row: selectIndex, section: 0), at: .top, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension OldTableViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView, tableView == rightTableView else { return }
        isScrollDown = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
    }
}

