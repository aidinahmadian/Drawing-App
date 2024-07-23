//
//  t2.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/5/24.
//

import UIKit

class TableViewController: UIViewController {
    
    // MARK: - Properties
    
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
    
    fileprivate let lineWidthOptions: [LineWidthOption] = (1...14).map { width in
        LineWidthOption(width: Float(width), label: "\(width).0 Points")
    }

    fileprivate let brushData: [[BrushItem]] = {
        let data = Array(repeating: (0...5).map { BrushItem(name: "\($0)") }, count: 1).flatMap { $0 }
        return Array(repeating: data, count: 14)
    }()
    
    fileprivate var selectIndex = 0
    fileprivate var isScrollDown = true
    fileprivate var lastOffsetY: CGFloat = 0.0
    fileprivate var isManualScrolling = false
    fileprivate var isAutoScrolling = false
    fileprivate var isUserInteraction = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        
        setupUI()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
            let rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "info.circle"),
                style: .plain,
                target: self,
                action: #selector(rightBarButtonTapped)
            )
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        //navigationController?.navigationBar.prefersLargeTitles = true
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
    
    @objc private func rightBarButtonTapped() {
        let moreInfoVC = MoreInfoVC()
        present(moreInfoVC, animated: true, completion: nil)
        //navigationController?.pushViewController(moreInfoVC, animated: true)
        print("Right bar button tapped")
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == leftTableView ? 1 : brushData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == leftTableView ? lineWidthOptions.count : brushData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell", for: indexPath) as! LeftTableViewCell
            let option = lineWidthOptions[indexPath.row]
            cell.nameLabel.text = option.label
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightTableViewCell", for: indexPath) as! RightTableViewCell
            //cell.nameLabel.text = brushData[indexPath.section][indexPath.row].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == leftTableView ? 0 : 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableView != leftTableView else { return nil }
        let headerView = TableViewHeaderView()
            headerView.nameLabel.text = "Brushes \(section)"
            //
            return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard tableView == rightTableView, !isScrollDown, !isManualScrolling, !isAutoScrolling else { return }
        updateLeftTableViewSelection(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard tableView == rightTableView, isScrollDown, !isManualScrolling, !isAutoScrolling else { return }
        updateLeftTableViewSelection(forSection: section + 1)
    }
    
    private func updateLeftTableViewSelection(forSection section: Int) {
        guard section < lineWidthOptions.count else { return }
        isAutoScrolling = true
        leftTableView.selectRow(at: IndexPath(row: section, section: 0), animated: true, scrollPosition: .none)
        isAutoScrolling = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView {
            selectIndex = indexPath.row
            isManualScrolling = true
            rightTableView.scrollToRow(at: IndexPath(row: 0, section: selectIndex), at: .top, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.isManualScrolling = false
            }
            let selectedOption = lineWidthOptions[indexPath.row]
            guard let view = self.view as? SimpleDrawCanvas else { return }
            view.strokeWidth = selectedOption.width
        } else {
            let selectedBrushItem = brushData[indexPath.section][indexPath.row]
            let vc = BrushDetailsViewController()
            vc.brushItem = selectedBrushItem
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.modalTransitionStyle = .coverVertical
            vc.sheetPresentationController?.prefersGrabberVisible = true
            //navigationController?.pushViewController(vc, animated: true)
            present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension TableViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView, tableView == rightTableView else { return }
        
        isScrollDown = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
        
        if let firstVisibleIndexPath = rightTableView.indexPathsForVisibleRows?.first, !isManualScrolling, !isAutoScrolling {
            updateLeftTableViewSelection(forSection: firstVisibleIndexPath.section)
        }
    }
}
