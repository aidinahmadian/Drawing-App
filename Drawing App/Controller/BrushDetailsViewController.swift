//
//  DetailViewController.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/5/24.
//

import UIKit

class BrushDetailsViewController: UIViewController {
    
    var brushItem: BrushItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let brushItem = brushItem {
            title = brushItem.name
            // Use the brushItem data to update the UI
            setupUI()
        }
    }
    
    private func setupUI() {
        // Add UI elements and layout code here
        let label = UILabel()
        label.text = brushItem?.name
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
