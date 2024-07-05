//
//  TestViewController.swift
//  Test
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit
import Combine

class TestViewController: UIViewController {
    
    let helloLabel: UILabel = {
            let hl = UILabel()
            hl.text = "home"
            hl.translatesAutoresizingMaskIntoConstraints = false
            hl.textColor = .black
            return hl
        }()
    
    private let colorPickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handleCP), for: .touchUpInside)
        return button
    }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            setupViews()
            setupConstraints()
        }
    
    var cancellable: AnyCancellable?
    
    @objc private func handleCP() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.view.backgroundColor!
        picker.delegate = self
        
        //  Subscribing selectedColor property changes.
        self.cancellable = picker.publisher(for: \.selectedColor)
            .sink { color in
                
                //  Changing view color on main thread.
                DispatchQueue.main.async {
                    self.view.backgroundColor = color
                    self.helloLabel.text = color.toHexString() // Update the label with HEX value
                }
            }
        
        self.present(picker, animated: true, completion: nil)
    }
        
        func setupViews() {
            view.addSubview(helloLabel)
            view.addSubview(colorPickerButton)
        }
        
        func setupConstraints() {
            helloLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            colorPickerButton.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 10).isActive = true
            colorPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    
    }


extension TestViewController: UIColorPickerViewControllerDelegate {
    
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
                self.view.backgroundColor = selectedColor
                helloLabel.text = selectedColor.toHexString() // Update the label with HEX value
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.cancellable?.cancel()
            print(self.cancellable == nil)
        }
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            let selectedColor = viewController.selectedColor
            self.view.backgroundColor = selectedColor
            helloLabel.text = selectedColor.toHexString() // Update the label with HEX value
        }
}


extension UIColor {
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
}
