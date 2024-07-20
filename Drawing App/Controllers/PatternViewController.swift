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
    private let patternView = PatternView()
    
    // Lifecycle
    override func loadView() {
        view = patternView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
        setupLayout()
        setupNavigationBarTitle(title: "Pattern")
        NotificationCenter.default.addObserver(self, selector: #selector(viewWasTouched), name: .init(PatternView.viewWasTouched), object: nil)
    }
    
    // Setup Methods
    override func setupNavBarButtons() {
        let buttonItems = [
            ("trash", #selector(handleClear)),
            ("pencil.tip", #selector(handleTip)),
            ("paintbrush.fill", #selector(handleColor)),
            ("light.max", #selector(handleTurn)),
            ("arrow.down.circle.fill", #selector(handleSave))
        ].map { (systemName, selector) in
            UIBarButtonItem(image: UIImage(systemName: systemName), style: .plain, target: self, action: selector)
        }
        
        navigationItem.rightBarButtonItems = buttonItems
    }
    
    // Action Methods
    @objc private func handleClear(_ sender: UIBarButtonItem) {
        (view as? PatternView)?.clear()
    }
    
    @objc private func handleTip(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }

        let items: [CGFloat] = [1.0, 2.0, 4.0, 8.0, 16.0]
        let controller = ArrayChoiceTableViewController(
            items,
            header: "Line width",
            labels: { "\($0) points\($0 == view.lineWidth ? " ✔️" : "")" }
        ) { view.lineWidth = $0 }

        presentPopover(controller, sender: sender)
    }
    
    @objc private func handleColor(_ sender: UIBarButtonItem) {
        guard let view = view as? PatternView else { return }
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.lineColor
        present(colorPicker, animated: true)
    }
    
    @objc private func handleTurn(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }
        
        let items: [Int] = [1, 2, 3, 4, 8, 16, 32]
        let controller = ArrayChoiceTableViewController(
            items,
            header: "Brushes",
            labels: { "\($0)x\($0 == view.turns ? " ✔️" : "")" }
        ) { view.turns = $0 }

        presentPopover(controller, sender: sender)
    }
    
    @objc private func handleSave(_ sender: UIBarButtonItem) {
        guard let view = view as? PatternView, let image = view.getImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        animateSaveLabel()
    }
    
    private func animateSaveLabel() {
        savedLabel.isHidden = false
        savedLabel.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn) {
            self.savedLabel.alpha = 0.0
        } completion: { _ in
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
