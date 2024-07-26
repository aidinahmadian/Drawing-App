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
        let expandButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.stack.badge.plus"), style: .plain, target: self, action: #selector(toggleNavBarButtons))
        
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
        let lineWidthButton = UIBarButtonItem(image: UIImage(systemName: "pencil.tip"), menu: lineWidthMenu)
        
        // Define turn picker menu
        let turnActions = createTurnActions()
        let turnMenu = UIMenu(title: "Number of Lines", children: turnActions)
        let turnButton = UIBarButtonItem(image: UIImage(systemName: "light.max"), menu: turnMenu)
        
        // Define other bar button items
        let buttonItems = [
            cancelButton,
            lineWidthButton,
            UIBarButtonItem(image: UIImage(systemName: "paintbrush.fill"), style: .plain, target: self, action: #selector(handleColor)),
            turnButton,
            UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle.fill"), style: .plain, target: self, action: #selector(handleSave))
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
    
    // Override the setupNavigationBarTitle method to keep a reference to the title view
    override func setupNavigationBarTitle(title: String) {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        let leftItem = UIBarButtonItem(customView: containerView)
        navigationItem.leftBarButtonItem = leftItem
        
        titleView = containerView // Keep a reference to the title view
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
