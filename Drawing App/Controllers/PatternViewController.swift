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
    private var areNavBarButtonsExpanded = false
    private var navBarButtonItems: [UIBarButtonItem] = []
    private var titleView: UIView?
    
    private var selectedLineWidth: CGFloat?
    private var selectedTurn: Int?
    
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
        let expandButton = UIBarButtonItem(image: UIImage(systemName: "shippingbox.and.arrow.backward.fill"), style: .plain, target: self, action: #selector(toggleNavBarButtons))
        
        navigationItem.rightBarButtonItems = [expandButton]
        navBarButtonItems = createNavBarButtonItems()
    }
    
    private func createNavBarButtonItems() -> [UIBarButtonItem] {
        // Define actions for the dropdown menu
        let trashAction = UIAction(title: "Trash", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.handleClear()
        }
        
        let undoAction = UIAction(title: "Undo", image: UIImage(systemName: "arrow.uturn.backward.circle")) { _ in
            self.handleUndo()
        }
        
        let redoAction = UIAction(title: "Redo", image: UIImage(systemName: "arrow.uturn.forward.circle")) { _ in
            self.handleRedo()
        }
        
        // Create a menu with the actions
        let menu = UIMenu(title: "", children: [undoAction, redoAction, trashAction])
        
        // Create a bar button item with the menu
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark.bin"), menu: menu)
        
        // Define line width picker menu
        let lineWidthActions = createLineWidthActions()
        let lineWidthMenu = UIMenu(title: "Line Width", children: lineWidthActions)
        let lineWidthButton = UIBarButtonItem(image: UIImage(systemName: "lineweight"), menu: lineWidthMenu)
        
        // Define turn picker menu
        let turnActions = createTurnActions()
        let turnMenu = UIMenu(title: "Number of Lines", children: turnActions)
        let turnButton = UIBarButtonItem(image: UIImage(systemName: "line.3.crossed.swirl.circle.fill"), menu: turnMenu)
        
        // Define other bar button items
        let buttonItems = [
            turnButton,
            lineWidthButton,
            UIBarButtonItem(image: UIImage(systemName: "paintpalette"), style: .plain, target: self, action: #selector(handleColor)),
            UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(handleSave)),
            cancelButton,
        ]
        
        return buttonItems
    }
    
    private func createLineWidthActions() -> [UIAction] {
        let lineWidths: [CGFloat] = [1.0, 2.0, 4.0, 8.0, 16.0]
        
        return lineWidths.map { lineWidth in
            let isSelected = lineWidth == selectedLineWidth
            let action = UIAction(
                title: "\(lineWidth) points",
                image: isSelected ? UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) : nil
            ) { _ in
                self.selectedLineWidth = lineWidth
                self.patternView.lineWidth = lineWidth
                self.updateLineWidthMenu()
            }
            return action
        }
    }
    
    private func createTurnActions() -> [UIAction] {
        let turns: [Int] = [1, 2, 3, 4, 8, 16, 32]
        
        return turns.map { turn in
            let isSelected = turn == selectedTurn
            let action = UIAction(
                title: "\(turn)x",
                image: isSelected ? UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) : nil
            ) { _ in
                self.selectedTurn = turn
                self.patternView.turns = turn
                self.updateTurnMenu()
            }
            return action
        }
    }
    
    private func updateLineWidthMenu() {
        let lineWidthActions = createLineWidthActions()
        let lineWidthMenu = UIMenu(title: "Line Width", children: lineWidthActions)
        
        if let lineWidthButton = navBarButtonItems.first(where: { $0.image == UIImage(systemName: "pencil.tip") }) {
            lineWidthButton.menu = lineWidthMenu
        }
    }
    
    private func updateTurnMenu() {
        let turnActions = createTurnActions()
        let turnMenu = UIMenu(title: "Number of Lines", children: turnActions)
        
        if let turnButton = navBarButtonItems.first(where: { $0.image == UIImage(systemName: "light.max") }) {
            turnButton.menu = turnMenu
        }
    }
    
    @objc private func toggleNavBarButtons() {
        NavBarAnimationManager.toggleNavBarButtons(for: self, navBarButtonItems: navBarButtonItems, areNavBarButtonsExpanded: areNavBarButtonsExpanded, titleView: titleView) { expanded in
            self.areNavBarButtonsExpanded = expanded
        }
    }
    
    override func setupNavigationBarTitle(title: String) {
        let titleButton = UIButton(type: .system)
        titleButton.translatesAutoresizingMaskIntoConstraints = false

        // Create an attributed string with underline
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.customFont(name: "Milanello", size: 24),
                .foregroundColor: UIColor(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        titleButton.setAttributedTitle(attributedTitle, for: .normal)
        
        // Create the menu
        let titleMenu = createTitleMenu()
        titleButton.menu = titleMenu
        titleButton.showsMenuAsPrimaryAction = true
        
        // Container view for the button
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            titleButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Add container view to the navigation bar
        let leftItem = UIBarButtonItem(customView: containerView)
        navigationItem.leftBarButtonItem = leftItem
        
        titleView = containerView // Keep a reference to the title view
    }
    
    private func createTitleMenu() -> UIMenu {
        let item1 = UIAction(title: "Option 1") { _ in
            // Handle option 1
        }
        let item2 = UIAction(title: "Option 2") { _ in
            // Handle option 2
        }
        let item3 = UIAction(title: "Option 3") { _ in
            // Handle option 3
        }
        
        return UIMenu(title: "", children: [item1, item2, item3])
    }
    
    @objc private func handleClear() {
        let alert = UIAlertController(title: "Clear Canvas", message: "Are you sure you want to clear the canvas? This action cannot be undone.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            generateHapticFeedback(.rigid)
            self.patternView.clear()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func handleUndo() {
        generateHapticFeedback(.soft)
        patternView.undo()
    }
    
    @objc private func handleRedo() {
        generateHapticFeedback(.soft)
        patternView.redo()
    }
    
    @objc private func handleColor(_ sender: UIBarButtonItem) {
        guard let view = view as? PatternView else { return }
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.lineColor
        present(colorPicker, animated: true)
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
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        guard let view = self.view as? PatternView else { return }
        view.lineColor = viewController.selectedColor
        generateHapticFeedback(.selection)
    }
}
