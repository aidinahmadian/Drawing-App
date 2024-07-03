//
//  TestViewController.swift
//  Test
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let helloLabel: UILabel = {
            let hl = UILabel()
            hl.text = "home"
            hl.translatesAutoresizingMaskIntoConstraints = false
            hl.textColor = .black
            return hl
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            setupViews()
            setupConstraints()
        }
        
        func setupViews() {
            view.addSubview(helloLabel)
        }
        
        func setupConstraints() {
            helloLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    
    }
