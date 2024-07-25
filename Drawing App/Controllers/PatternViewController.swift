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
        // Define actions for the dropdown menu
        let trashAction = UIAction(title: "Trash", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.handleClear()
        }
        
        let undoAction = UIAction(title: "Undo", image: UIImage(systemName: "arrow.uturn.backward.circle")) { _ in
            self.handleUndo()
        }
        
        // Create a menu with the actions
        let menu = UIMenu(title: "", children: [trashAction, undoAction])
        
        // Create a bar button item with the menu
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), menu: menu)

        // Define other bar button items
        let buttonItems = [
            cancelButton,
            UIBarButtonItem(image: UIImage(systemName: "pencil.tip"), style: .plain, target: self, action: #selector(handleTip)),
            UIBarButtonItem(image: UIImage(systemName: "paintbrush.fill"), style: .plain, target: self, action: #selector(handleColor)),
            UIBarButtonItem(image: UIImage(systemName: "light.max"), style: .plain, target: self, action: #selector(handleTurn)),
            UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle.fill"), style: .plain, target: self, action: #selector(handleSave))
        ]
        
        navigationItem.rightBarButtonItems = buttonItems
    }
    
    // Action Methods
    @objc private func handleClear() {
        generateHapticFeedback(.rigid)
        (view as? PatternView)?.clear()
    }
    
    @objc private func handleUndo() {
        generateHapticFeedback(.soft)
        (view as? PatternView)?.undo()
    }
    
    @objc private func handleTip(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }

        let items: [CGFloat] = [1.0, 2.0, 4.0, 8.0, 16.0]
        let selectedValue = view.lineWidth
        let controller = ArrayChoiceTableViewController(
            items,
            selectedValue: selectedValue,
            header: "Line Width",
            labels: { (value: CGFloat) -> NSAttributedString in
                let labelText = "\(value) points"
                let attributedString = NSMutableAttributedString(string: labelText, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.darkGray])

                if value == view.lineWidth {
                    let attachment = NSTextAttachment()
                    if let checkmarkImage = UIImage(systemName: "checkmark.circle.fill") {
                        let tintedImage = checkmarkImage.withTintColor(UIColor.systemGreen, renderingMode: .alwaysOriginal)
                        attachment.image = tintedImage
                    }

                    let attachmentString = NSAttributedString(attachment: attachment)
                    attributedString.append(NSAttributedString(string: " "))
                    attributedString.append(attachmentString)
                }

                return attributedString
            }
        ) { view.lineWidth = $0 }

        presentPopover(controller, sender: sender)
        generateHapticFeedback(.selection)
    }


    @objc private func handleColor(_ sender: UIBarButtonItem) {
        guard let view = view as? PatternView else { return }
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.lineColor
        present(colorPicker, animated: true)
        generateHapticFeedback(.selection)
    }
    
    @objc private func handleTurn(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }

        let items: [Int] = [1, 2, 3, 4, 8, 16, 32]
        let selectedValue = view.turns
        let controller = ArrayChoiceTableViewController(
            items,
            selectedValue: selectedValue,
            header: "Brushes",
            labels: { (value: Int) -> NSAttributedString in
                let labelText = "\(value)x"
                let attributedString = NSMutableAttributedString(string: labelText, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.darkGray])

                if value == view.turns {
                    let attachment = NSTextAttachment()
                    if let checkmarkImage = UIImage(systemName: "checkmark.circle.fill") {
                        let tintedImage = checkmarkImage.withTintColor(UIColor.systemGreen, renderingMode: .alwaysOriginal)
                        attachment.image = tintedImage
                    }

                    let attachmentString = NSAttributedString(attachment: attachment)
                    attributedString.append(NSAttributedString(string: " "))
                    attributedString.append(attachmentString)
                }

                return attributedString
            }
        ) { view.turns = $0 }

        presentPopover(controller, sender: sender)
        generateHapticFeedback(.selection)
    }

    
    @objc private func handleSave(_ sender: UIBarButtonItem) {
        guard let view = view as? PatternView, let image = view.getImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        animateSaveLabel()
        generateHapticFeedback(.success)
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
        generateHapticFeedback(.selection)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    viewController.dismiss(animated: true, completion: nil)
                }
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        guard let view = self.view as? PatternView else { return }
        view.lineColor = viewController.selectedColor
        generateHapticFeedback(.selection)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    viewController.dismiss(animated: true, completion: nil)
                }
    }
}
