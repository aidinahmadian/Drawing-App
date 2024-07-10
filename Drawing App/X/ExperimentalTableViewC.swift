//
//  ExperimentalTableViewC.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/10/24.
//

//import Foundation
//import UIKit
//
//protocol BrushSelectionDelegate: AnyObject {
//    func didSelectBrush(_ brush: Any)
//}
//
//class TableViewController: UIViewController {
//    
//    // MARK: - Properties
//    
//    var canvas: SimpleDrawCanvas!
//    weak var delegate: BrushSelectionDelegate?
//    
//    fileprivate lazy var leftTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = 55
//        tableView.showsVerticalScrollIndicator = false
//        tableView.separatorColor = UIColor.clear
//        tableView.register(LeftTableViewCell.self, forCellReuseIdentifier: "LeftTableViewCell")
//        tableView.bounces = true
//        return tableView
//    }()
//    
//    fileprivate lazy var rightTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = 80
//        tableView.showsVerticalScrollIndicator = false
//        tableView.register(RightTableViewCell.self, forCellReuseIdentifier: "RightTableViewCell")
//        tableView.bounces = true
//        return tableView
//    }()
//    
//    fileprivate let brushOptions: [BrushItem] = [
//        BrushItem(name: "Line", brush: LineBrush()),
//        BrushItem(name: "Dotted", brush: DottedBrush()),
//        BrushItem(name: "Chalk", brush: ChalkBrush()),
//        BrushItem(name: "Rust", brush: RustBrush()),
//        BrushItem(name: "Square Texture", brush: SquareTextureBrush()),
//        BrushItem(name: "Pencil", brush: PencilBrush()),
//        BrushItem(name: "Charcoal", brush: CharcoalBrush()),
//        BrushItem(name: "Pastel", brush: PastelBrush()),
//        BrushItem(name: "Watercolor", brush: WatercolorBrush()),
//        BrushItem(name: "Splatter", brush: SplatterBrush()),
//        BrushItem(name: "Ink", brush: InkBrush())
//    ]
//    
//        fileprivate let lineWidthOptions: [LineWidthOption] = (1...14).map { width in
//            LineWidthOption(width: Float(width), label: "\(width).0 Points")
//        }
//    
//    fileprivate var selectIndex = 0
//    fileprivate var isScrollDown = true
//    fileprivate var lastOffsetY: CGFloat = 0.0
//    fileprivate var isManualScrolling = false
//    fileprivate var isAutoScrolling = false
//    fileprivate var isUserInteraction = false
//    
//    // MARK: - Lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//    
//    // MARK: - UI Setup
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.title = "Brush Library"
//        navigationItem.largeTitleDisplayMode = .never
//        
//        view.addSubview(leftTableView)
//        view.addSubview(rightTableView)
//        
//        setupConstraints()
//        
//        leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
//    }
//    
//    private func setupConstraints() {
//        leftTableView.translatesAutoresizingMaskIntoConstraints = false
//        rightTableView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            leftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            leftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            leftTableView.widthAnchor.constraint(equalToConstant: 80),
//            leftTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            rightTableView.topAnchor.constraint(equalTo: leftTableView.topAnchor, constant: 0),
//            rightTableView.leadingAnchor.constraint(equalTo: leftTableView.trailingAnchor, constant: 5),
//            rightTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),
//            rightTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//}
//
//// MARK: - UITableViewDataSource & UITableViewDelegate
//
//extension TableViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        //return 1 // One section for brushes
//        return tableView == leftTableView ? 1 : brushOptions.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableView == leftTableView ? lineWidthOptions.count : brushOptions.count
//    }
//    
//    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    //        return tableView == leftTableView ? lineWidthOptions.count : brushData[section].count
//    //    }
//    //
//    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    //        if tableView == leftTableView {
//    //            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell", for: indexPath) as! LeftTableViewCell
//    //            let option = lineWidthOptions[indexPath.row]
//    //            cell.nameLabel.text = option.label
//    //            return cell
//    //        } else {
//    //            let cell = tableView.dequeueReusableCell(withIdentifier: "RightTableViewCell", for: indexPath) as! RightTableViewCell
//    //            cell.nameLabel.text = brushData[indexPath.section][indexPath.row].name
//    //            return cell
//    //        }
//    //    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if tableView == leftTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell", for: indexPath) as! LeftTableViewCell
//            let option = lineWidthOptions[indexPath.row]
//            cell.nameLabel.text = option.label
//            return cell
//        } else {
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RightTableViewCell", for: indexPath) as! RightTableViewCell
//            let brush = brushOptions[indexPath.row]
//            cell.nameLabel.text = brush.name
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedBrushItem = brushOptions[indexPath.row]
//        delegate?.didSelectBrush(selectedBrushItem.brush)
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//// MARK: - UIScrollViewDelegate
//
//extension TableViewController {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let tableView = scrollView as? UITableView, tableView == rightTableView else { return }
//        
//        isScrollDown = lastOffsetY < scrollView.contentOffset.y
//        lastOffsetY = scrollView.contentOffset.y
//    }
//}
//
//class RightTableViewCell: UITableViewCell {
//    
//    lazy var nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureUI()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configureUI() {
//        contentView.addSubview(nameLabel)
//        
//        NSLayoutConstraint.activate([
//            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
//            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
//        ])
//    }
//}
