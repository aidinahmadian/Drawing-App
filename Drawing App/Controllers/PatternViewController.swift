//
//  SymmetrixViewController.swift
//  Test
//
//  Created by aidin ahmadian on 7/21/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class PatternViewController: BaseDrawController {
    
    // Properties
    let patternView = PatternView()
    
    override func loadView() {
        self.view = patternView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
        setupLayout()
        setupNavigationBarTitle(title: "Pattern")
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWasTouched), name: Notification.Name(PatternView.viewWasTouched), object: nil)
    }
    
    // Setup Methods
    override func setupNavBarButtons() {
        let clearImage = UIImage(systemName: "trash")
        let clearImageButtonItem = UIBarButtonItem(image: clearImage, style: .plain, target: self, action: #selector(handleClear))
        
        let tipImage = UIImage(systemName: "pencil.tip")
        let tipImageButtonItem = UIBarButtonItem(image: tipImage, style: .plain, target: self, action: #selector(handleTip))
        
        let colorImage = UIImage(systemName: "paintbrush.fill")
        let colorImageButtonItem = UIBarButtonItem(image: colorImage, style: .plain, target: self, action: #selector(handleColor))
        
        let turnImage = UIImage(systemName: "light.max")
        let turnImageButtonItem = UIBarButtonItem(image: turnImage, style: .plain, target: self, action: #selector(handleTurn))
        
        let saveImage = UIImage(systemName: "arrow.down.circle.fill")
        let saveImageButtonItem = UIBarButtonItem(image: saveImage, style: .plain, target: self, action: #selector(handleSave))
        
        navigationItem.rightBarButtonItems = [clearImageButtonItem, tipImageButtonItem, colorImageButtonItem, turnImageButtonItem, saveImageButtonItem]
    }
    
    // Action Methods
    @objc func handleClear(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }
        view.clear()
    }
    
    @objc func handleTip(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }

        let items: [CGFloat] = [1.0, 2.0, 4.0, 8.0, 16.0]
        let controller = ArrayChoiceTableViewController(
            items,
            header: "Line width",
            labels: { "\($0) points\($0 == view.lineWidth ? " ✔️" : "")" }
        ) { view.lineWidth = $0 }

        presentPopover(controller, sender: sender)
    }
    
    @objc func handleColor(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.lineColor
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func handleTurn(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }
        
        let items: [Int] = [1, 2, 3, 4, 8, 16, 32]
        let controller = ArrayChoiceTableViewController(
            items,
            header: "Brushes",
            labels: { "\($0)x\($0 == view.turns ? " ✔️" : "")" }
        ) { view.turns = $0 }

        presentPopover(controller, sender: sender)
    }
    
    @objc func handleSave(_ sender: UIButton) {
        guard let view = self.view as? PatternView, let image = view.getImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        savedLabel.isHidden = false
        savedLabel.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
            self.savedLabel.alpha = 0.0
        }) { _ in
            self.savedLabel.isHidden = true
        }
    }
}

extension PatternViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        guard let view = self.view as? PatternView else { return }
        view.lineColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        guard let view = self.view as? PatternView else { return }
        view.lineColor = viewController.selectedColor
    }
}
