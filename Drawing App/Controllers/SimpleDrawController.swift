//
//  SimpleDrawController.swift
//  Test
//
//  Created by aidin ahmadian on 7/26/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class SimpleDrawController: BaseDrawController {
    
    // Properties
    private let canvas = SimpleDrawCanvas()
    private var isGridVisible = false
    private var areNavBarButtonsExpanded = false
    private var navBarButtonItems: [UIBarButtonItem] = []
    private var titleView: UIView?
    private var gridButton: UIBarButtonItem?
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBarButtons()
        setupLayout()
        setupNavigationBarTitle(title: "Scribble")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewWasTouched),
            name: Notification.Name(SimpleDrawCanvas.viewWasTouched),
            object: nil
        )
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        canvas.backgroundColor = .white
    }
    
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
        
        let gridAction = UIAction(title: "Toggle Grid", image: UIImage(systemName: "grid")) { _ in
            self.toggleGrid()
        }
        
        // Create a menu with the actions
        let menu = UIMenu(title: "", children: [trashAction, undoAction, redoAction])
        
        // Create a bar button item with the menu
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark.bin"), menu: menu)
        
        // Define other bar button items
        gridButton = UIBarButtonItem(image: UIImage(systemName: "grid.circle"), style: .plain, target: self, action: #selector(toggleGrid))
        let buttonItems = [
            cancelButton,
            UIBarButtonItem(image: UIImage(systemName: "pencil.tip"), style: .plain, target: self, action: #selector(tipButtonTapped)),
            UIBarButtonItem(image: UIImage(systemName: "paintbrush.fill"), style: .plain, target: self, action: #selector(colorButtonTapped)),
            UIBarButtonItem(image: UIImage(systemName: "scribble.variable"), style: .plain, target: self, action: #selector(brushButtonTapped)),
            gridButton!
        ]
        
        return buttonItems
    }
    
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
    
    // MARK: - Action Methods
    @objc private func toggleNavBarButtons() {
        NavBarAnimationManager.toggleNavBarButtons(for: self, navBarButtonItems: navBarButtonItems, areNavBarButtonsExpanded: areNavBarButtonsExpanded, titleView: titleView) { expanded in
            self.areNavBarButtonsExpanded = expanded
        }
    }
    
    @objc private func handleUndo() {
        generateHapticFeedback(.soft)
        canvas.undo()
    }
    
    @objc private func handleRedo() {
        generateHapticFeedback(.soft)
        canvas.redo()
    }
    
    @objc private func handleClear() {
        let alert = UIAlertController(title: "Clear Canvas", message: "Are you sure you want to clear the canvas? This action cannot be undone.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            generateHapticFeedback(.rigid)
            self.canvas.clear()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func toggleGrid() {
        generateHapticFeedback(.selection)
        isGridVisible.toggle()
        canvas.isGridVisible = isGridVisible
        canvas.setNeedsDisplay()
        
        // Update grid button image
        let gridImageName = isGridVisible ? "grid.circle.fill" : "grid.circle"
        gridButton?.image = UIImage(systemName: gridImageName)
    }
    
    @objc private func tipButtonTapped(_ sender: UIBarButtonItem) {
        presentLineWidthPicker(sender: sender)
    }
    
    @objc private func colorButtonTapped(_ sender: UIBarButtonItem) {
        presentColorPicker(sender: sender)
        generateHapticFeedback(.selection)
    }
    
    @objc private func brushButtonTapped(_ sender: UIBarButtonItem) {
        presentBrushPicker(sender: sender)
        generateHapticFeedback(.selection)
    }
    
    // MARK: - Helper Methods
    private func presentLineWidthPicker(sender: UIBarButtonItem) {
        guard let view = view as? SimpleDrawCanvas else { return }
        
        let items: [Float] = [1.0, 2.0, 4.0, 8.0, 16.0]
        let selectedValue = view.strokeWidth
        let controller = ArrayChoiceTableViewController(
            items,
            selectedValue: selectedValue,
            header: "Line Width",
            labels: { (item: Float) -> NSAttributedString in
                let labelText = "\(item) points"
                let attributedString = NSMutableAttributedString(string: labelText, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.darkGray])
                
                if item == view.strokeWidth {
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
        ) { value in
            view.strokeWidth = value
        }
        
        presentPopover(controller, sender: sender)
        generateHapticFeedback(.selection)
    }
    
    private func presentColorPicker(sender: UIBarButtonItem) {
        guard let view = view as? SimpleDrawCanvas else { return }
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.strokeColor
        present(colorPicker, animated: true, completion: nil)
    }
    
    private func presentBrushPicker(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Select Brush", message: nil, preferredStyle: .actionSheet)
        
        let brushes: [(String, Brush)] = [
            ("Line", LineBrush()),
            ("Straight Line", StraightLineBrush()),
            ("Circle", CircleBrush()),
            ("Dotted", DottedBrush()),
            ("Chalk", ChalkBrush()),
            ("Rust", RustBrush()),
            ("Square Texture", SquareTextureBrush()),
            ("Pencil", PencilBrush()),
            ("Charcoal", CharcoalBrush()),
            ("Pastel", PastelBrush()),
            ("Watercolor", WatercolorBrush()),
            ("Splatter", SplatterBrush()),
            ("Ink", InkBrush())
        ]
        
        brushes.forEach { brush in
            alert.addAction(UIAlertAction(title: brush.0, style: .default) { _ in
                self.canvas.setBrush(brush.1)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        generateHapticFeedback(.selection)
    }
    
}

// MARK: - UIColorPickerViewControllerDelegate
extension SimpleDrawController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        updateCanvasColor(with: viewController.selectedColor)
        generateHapticFeedback(.selection)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        updateCanvasColor(with: viewController.selectedColor)
        generateHapticFeedback(.selection)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private func updateCanvasColor(with color: UIColor) {
        guard let view = view as? SimpleDrawCanvas else { return }
        view.strokeColor = color
    }
}
