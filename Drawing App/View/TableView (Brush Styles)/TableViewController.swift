//
//  TableViewController.swift
//  Test
//
//  Created by aidin ahmadian on 7/20/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Setup Swipeable (Left) TableView
    
    fileprivate lazy var leftTableView : UITableView = {
        let leftTableView = UITableView()
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.frame = CGRect(x: 2, y: 0, width: 80, height: ScreenHeight)
        leftTableView.rowHeight = 55
        leftTableView.showsVerticalScrollIndicator = false
        leftTableView.separatorColor = UIColor.clear
        leftTableView.register(LeftTableViewCell.self, forCellReuseIdentifier: kLeftTableViewCell)
        leftTableView.bounces = false
        return leftTableView
    }()
    
    // MARK: - Setup Swipeable (Right) TableView
    
    fileprivate lazy var rightTableView : UITableView = {
        let rightTableView = UITableView()
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.frame = CGRect(x: 85, y: 64, width: ScreenWidth - 88, height: ScreenHeight - 64)
        rightTableView.rowHeight = 80
        rightTableView.showsVerticalScrollIndicator = false
        rightTableView.register(RightTableViewCell.self, forCellReuseIdentifier: kRightTableViewCell)
        rightTableView.bounces = true
        return rightTableView
    }()
    
    fileprivate lazy var categoryData = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V"]
    fileprivate lazy var foodData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    
    fileprivate var selectIndex = 0
    fileprivate var isScrollDown = true
    fileprivate var lastOffsetY : CGFloat = 0.0
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //configureData()
        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
        
        leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
    }
}

//MARK: - Retrieve Data

//extension TableViewController {
//
//    fileprivate func configureData () {
//
//        guard let path = Bundle.main.path(forResource: "meituan", ofType: "json") else { return }
//
//        guard let data = NSData(contentsOfFile: path) as Data? else { return }
//
//        guard let anyObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else { return }
//
//        guard let dict = anyObject as? [String : Any] else { return }
//
//        guard let datas = dict["data"] as? [String : Any] else { return }
//
//        guard let foods = datas["food_spu_tags"] as? [[String : Any]] else { return }
//
//        for food in foods {
//
//            let model = CategoryModel(dict: food)
//            categoryData.append(model)
//
//            guard let spus = model.spus else { continue }
//            var datas = [FoodModel]()
//            for fModel in spus {
//                datas.append(fModel)
//            }
//            foodData.append(datas)
//        }
//    }
//}

//MARK: - TableView DataSource Delegate
extension TableViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if leftTableView == tableView {
            return 1
        } else {
            return categoryData.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if leftTableView == tableView {
            return categoryData.count
        } else {
            return foodData[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if leftTableView == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: kLeftTableViewCell, for: indexPath) as! LeftTableViewCell
            //cell.imageView?.image = UIImage.init(named: "face")
            cell.nameLabel.text = categoryData[indexPath.row]
            //let model = categoryData[indexPath.row]
            //cell.nameLabel.text = model.name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kRightTableViewCell, for: indexPath) as! RightTableViewCell
            //cell.textLabel?.text = rightTableViewDatas[indexPath.row]
            cell.nameLabel.text = foodData[indexPath.row]
//            let model = foodData[indexPath.section][indexPath.row]
//            cell.setDatas(model)
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if leftTableView == tableView {
            return 0
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if leftTableView == tableView {
            return nil
        }
        let headerView = TableViewHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 20))
        //let model = categoryData[section]
        headerView.nameLabel.text = categoryData[section]
        return headerView
    }
    
    // TableView section title will be displayed soon
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // The current tableView is RightTableView, the scrolling direction of RightTableView is upward, and the rightTableView is scrolled by user dragging ((mainly judging RightTableView scrolling by user dragging or clicking LeftTableView)
        if (rightTableView == tableView)
            && !isScrollDown
            && (rightTableView.isDragging || rightTableView.isDecelerating) {
            selectRow(index: section)
        }
    }
    
    // TableView section title display end
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        // The current tableView is RightTableView, the scrolling direction of RightTableView is downward, and the RightTableView is scrolled by the user dragging ((mainly judging whether the RightTableView user drags and scrolls, or clicks LeftTableView to scroll)
        if (rightTableView == tableView)
            && isScrollDown
            && (rightTableView.isDragging || rightTableView.isDecelerating) {
            selectRow(index: section + 1)
        }
    }
    
    // When dragging the right TableView, handle the left TableView
    private func selectRow(index : Int) {
        leftTableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .top)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if leftTableView == tableView {
            selectIndex = indexPath.row
            rightTableView.scrollToRow(at: IndexPath(row: 0, section: selectIndex), at: .top, animated: true)
            leftTableView.scrollToRow(at: IndexPath(row: selectIndex, section: 0), at: .top, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = "Brush Library"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // Mark the scroll direction of RightTableView, whether it is up or down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let tableView = scrollView as! UITableView
        if rightTableView == tableView {
            isScrollDown = lastOffsetY < scrollView.contentOffset.y
            lastOffsetY = scrollView.contentOffset.y
        }
    }
}
