//
//  SimpleDrawController.swift
//  Test
//
//  Created by aidin ahmadian on 7/26/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

// Controller for the SimpleDraw functionality
class SimpleDrawController: BaseDrawController, BrushSelectionDelegate, UIColorPickerViewControllerDelegate, ColorPickerViewControllerDelegate {
    
    // MARK: - Properties
    
    // Canvas for drawing
    private let canvas = SimpleDrawCanvas()
    
    // UI state properties
    private var isGridVisible = false
    private var gridButton: UIBarButtonItem?
    private var isMoveMode = false
    
    // UI elements
    private var toggleLabel: UILabel!
    private var blurEffectView: UIVisualEffectView!
    private var brushNameLabel: UILabel!
    private var cancelButton: UIButton!
    
    // Selected brush and line width properties
    private var selectedBrushTitle: String? = "Line"
    private var selectedLineWidth: Float? = 4.0
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBarButtons()
        setupNavigationBarTitle(title: "Scribble")
        updateBrushNameLabel(with: selectedBrushTitle!)
        updateBrushMenu()
        updateLineWidthMenu()
        
        // Observe touch notifications from the canvas
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewWasTouched),
            name: Notification.Name(SimpleDrawCanvas.viewWasTouched),
            object: nil
        )
    }
    
    // MARK: - Setup Methods
    
    // Setup the main view components
    private func setupView() {
        canvas.backgroundColor = .white
        configureToggleLabel()
        configureBlurEffectView()
        configureBrushNameLabel() // Configure brush label and cancel button
    }
    
    // Configure the toggle label for move mode
    private func configureToggleLabel() {
        toggleLabel = UILabel()
        toggleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleLabel.textAlignment = .center
        toggleLabel.textColor = UIColor.black
        
        // Setup icon for the label
        let imageAttachment = NSTextAttachment()
        if let image = UIImage(systemName: "arrow.up.and.down.and.arrow.left.and.right") {
            imageAttachment.image = image
            let imageAspectRatio = image.size.width / image.size.height
            let imageHeight: CGFloat = 16.0
            let imageWidth = imageHeight * imageAspectRatio
            imageAttachment.bounds = CGRect(x: 0, y: -2.0, width: imageWidth, height: imageHeight)
        }
        
        // Combine icon and text
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: " Move Mode Enabled")
        completeText.append(textAfterIcon)
        
        toggleLabel.attributedText = completeText
    }
    
    // Configure the blur effect view for move mode
    private func configureBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.borderWidth = 1.0
        blurEffectView.layer.borderColor = UIColor.orange.cgColor
        blurEffectView.layer.cornerRadius = 12
        blurEffectView.layer.masksToBounds = true
        view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(toggleLabel)
        blurEffectView.alpha = 0.0
        setupBlurEffectViewConstraints()
    }
    
    // Setup constraints for the blur effect view and toggle label
    private func setupBlurEffectViewConstraints() {
        NSLayoutConstraint.activate([
            blurEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blurEffectView.widthAnchor.constraint(equalToConstant: 220),
            blurEffectView.heightAnchor.constraint(equalToConstant: 40),
            toggleLabel.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor),
            toggleLabel.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor),
            toggleLabel.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
            toggleLabel.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor)
        ])
    }
    
    // Configure the label that displays the selected brush and the cancel button
    private func configureBrushNameLabel() {
        brushNameLabel = UILabel()
        brushNameLabel.translatesAutoresizingMaskIntoConstraints = false
        brushNameLabel.textAlignment = .center
        brushNameLabel.textColor = .black
        brushNameLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        brushNameLabel.layer.cornerRadius = 12
        brushNameLabel.layer.borderWidth = 1.0
        brushNameLabel.layer.borderColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        brushNameLabel.layer.masksToBounds = true
        brushNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        brushNameLabel.text = "Selected Brush: Line"
        
        view.addSubview(brushNameLabel)
        
        // Configure the cancel button
        cancelButton = UIButton(type: .system)
        cancelButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        cancelButton.tintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(hideBrushNameLabel), for: .touchUpInside)
        
        view.addSubview(cancelButton)
        
        // Add constraints
        NSLayoutConstraint.activate([
            brushNameLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            brushNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            brushNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 250),
            brushNameLabel.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.leadingAnchor.constraint(equalTo: brushNameLabel.trailingAnchor, constant: -15),
            cancelButton.topAnchor.constraint(equalTo: brushNameLabel.topAnchor, constant: -10),
            cancelButton.widthAnchor.constraint(equalToConstant: 24),
            cancelButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Update Methods
    
    // Update the brush name label with the current brush name
    private func updateBrushNameLabel(with brushName: String) {
        brushNameLabel.text = "Selected Brush: \(brushName)"
        brushNameLabel.isHidden = false
        cancelButton.isHidden = false
    }
    
    // Update the brush menu with the current selections
    private func updateBrushMenu() {
        let brushActions = createBrushActions()
        let brushMenu = UIMenu(title: "Select Brush", children: brushActions)
        if let brushButton = navBarButtonItems.first(where: { $0.image == UIImage(systemName: "scribble.variable") }) {
            brushButton.menu = brushMenu
        }
    }
    
    // Update the line width menu with the current selections
    private func updateLineWidthMenu() {
        let lineWidthActions = createLineWidthActions()
        let lineWidthMenu = UIMenu(title: "Line Width", children: lineWidthActions)
        if let lineWidthButton = navBarButtonItems.first(where: { $0.image == UIImage(systemName: "lineweight") }) {
            lineWidthButton.menu = lineWidthMenu
        }
    }
    
    // MARK: - Action Methods
    
    // Toggle the visibility of navigation bar buttons
    @objc private func toggleNavBarButtons() {
        NavBarAnimationManager.toggleNavBarButtons(for: self, navBarButtonItems: navBarButtonItems, areNavBarButtonsExpanded: areNavBarButtonsExpanded, titleView: titleView) { expanded in
            self.areNavBarButtonsExpanded = expanded
        }
    }
    
    // Handle the undo action
    @objc private func handleUndo() {
        generateHapticFeedback(.soft)
        canvas.undo()
    }
    
    // Handle the redo action
    @objc private func handleRedo() {
        generateHapticFeedback(.soft)
        canvas.redo()
    }
    
    // Handle the clear canvas action
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
    
    // Toggle the visibility of the grid
    @objc private func toggleGrid() {
        generateHapticFeedback(.selection)
        isGridVisible.toggle()
        canvas.isGridVisible = isGridVisible
        canvas.setNeedsDisplay()
        
        let gridImageName = isGridVisible ? "grid.circle.fill" : "grid.circle"
        gridButton?.image = UIImage(systemName: gridImageName)
    }
    
    // Toggle the move mode
    @objc private func toggleMode(_ sender: UIBarButtonItem) {
        isMoveMode.toggle()
        generateHapticFeedback(.selection)
        sender.image = isMoveMode ? UIImage(systemName: "arrow.down.left.arrow.up.right.circle.fill") : UIImage(systemName: "arrow.down.left.arrow.up.right.circle")
        canvas.isMoveMode = isMoveMode
        
        let offscreenYPosition = view.safeAreaLayoutGuide.layoutFrame.origin.y - blurEffectView.bounds.height
        let onScreenYPosition = view.safeAreaLayoutGuide.layoutFrame.origin.y + 10
        
        if isMoveMode {
            blurEffectView.transform = CGAffineTransform(translationX: 0, y: offscreenYPosition)
            blurEffectView.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: {
                self.blurEffectView.alpha = 1.0
                self.blurEffectView.transform = CGAffineTransform.identity
                self.blurEffectView.frame.origin.y = onScreenYPosition
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: {
                self.blurEffectView.alpha = 0.0
                self.blurEffectView.transform = CGAffineTransform(translationX: 0, y: offscreenYPosition).scaledBy(x: 0.5, y: 0.5)
            }, completion: { _ in
                self.blurEffectView.isHidden = true
            })
        }
    }
    
    // Present the color picker for selecting a stroke color
    @objc private func colorButtonTapped(_ sender: UIBarButtonItem) {
        presentColorPicker(sender: sender)
        generateHapticFeedback(.selection)
    }
    
    // Hide the brush name label
    @objc private func hideBrushNameLabel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.brushNameLabel.alpha = 0.0
            self.cancelButton.alpha = 0.0
        }) { _ in
            self.brushNameLabel.isHidden = true
            self.cancelButton.isHidden = true
            self.brushNameLabel.alpha = 1.0
            self.cancelButton.alpha = 1.0
        }
        generateHapticFeedback(.selection)
    }
    
    // Open the brush selection table view
    @objc func openTableViewController(_ sender: UIBarButtonItem? = nil) {
        let tableViewController = TableViewController()
        tableViewController.canvas = self.canvas
        tableViewController.delegate = self
        let navController = UINavigationController(rootViewController: tableViewController)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - BrushSelectionDelegate Method
    
    // Handle brush selection from the table view
    func didSelectBrush(_ brush: Brush) {
        canvas.setBrush(brush)
        print("Selected brush: \(brush)")
    }
    
    // MARK: - Helper Methods
    
    // Present the system color picker for selecting a color
    private func presentColorPicker(sender: UIBarButtonItem) {
        guard let view = view as? SimpleDrawCanvas else { return }
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.strokeColor
        present(colorPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIColorPickerViewControllerDelegate
    
    // Update the canvas color when the color picker is finished
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        updateCanvasColor(with: viewController.selectedColor)
        generateHapticFeedback(.selection)
    }
    
    // Update the canvas color when a color is selected
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        updateCanvasColor(with: viewController.selectedColor)
        generateHapticFeedback(.selection)
    }
    
    // Update the canvas color using the custom color picker
    func colorPickerViewController(_ viewController: ColorPickerViewController, didSelectColor color: UIColor) {
        canvas.strokeColor = color
    }
    
    // Apply the selected color to the canvas
    private func updateCanvasColor(with color: UIColor) {
        guard let view = view as? SimpleDrawCanvas else { return }
        view.strokeColor = color
    }
    
    // Create the navigation bar button items
    override func setupNavBarButtons() {
        let expandButton = UIBarButtonItem(image: UIImage(systemName: "shippingbox.and.arrow.backward.fill"), style: .plain, target: self, action: #selector(toggleNavBarButtons))
        navigationItem.rightBarButtonItems = [expandButton]
        navBarButtonItems = createNavBarButtonItems()
    }
    
    // Create and return the navigation bar button items
    private func createNavBarButtonItems() -> [UIBarButtonItem] {
        let trashAction = UIAction(title: "Trash", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.handleClear()
        }
        
        let undoAction = UIAction(title: "Undo", image: UIImage(systemName: "arrow.uturn.backward.circle")) { _ in
            self.handleUndo()
        }
        
        let redoAction = UIAction(title: "Redo", image: UIImage(systemName: "arrow.uturn.forward.circle")) { _ in
            self.handleRedo()
        }
        
        let menu = UIMenu(title: "", children: [undoAction, redoAction, trashAction])
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark.bin"), menu: menu)
        
        let brushActions = createBrushActions()
        let brushMenu = UIMenu(title: "Select Brush", children: brushActions)
        let brushButton = UIBarButtonItem(image: UIImage(systemName: "scribble.variable"), menu: brushMenu)
        
        let lineWidthActions = createLineWidthActions()
        let lineWidthMenu = UIMenu(title: "Line Width", children: lineWidthActions)
        let lineWidthButton = UIBarButtonItem(image: UIImage(systemName: "lineweight"), menu: lineWidthMenu)
        
        gridButton = UIBarButtonItem(image: UIImage(systemName: "grid.circle"), style: .plain, target: self, action: #selector(toggleGrid))
        let modeToggleButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.left.arrow.up.right.circle"), style: .plain, target: self, action: #selector(toggleMode))
        
        return [
            brushButton,
            lineWidthButton,
            UIBarButtonItem(image: UIImage(systemName: "paintpalette"), style: .plain, target: self, action: #selector(colorButtonTapped)),
            gridButton!,
            modeToggleButton,
            cancelButton,
        ]
    }
    
    // Create and return actions for selecting brushes
    private func createBrushActions() -> [UIMenuElement] {
        let brushes: [(String, Brush, String?)] = [
            // Shapes
            ("Arrow", ArrowBrush(), nil),
            ("Circle", CircleBrush(), nil),
            ("Rectangle", RectangleBrush(), nil),
            ("Triangle", TriangleBrush(), nil),
            ("Star", StarBrush(), nil),
            ("Hexagon", HexagonBrush(), nil),
            ("Spiral", SpiralBrush(), nil),
            // Other Brushes
            ("Line", LineBrush(), nil),
            ("Straight Line", StraightLineBrush(), nil),
            ("Dotted", DottedBrush(), nil),
            ("Rust", RustBrush(), nil),
            ("Watercolor", WatercolorBrush(), nil),
            ("Splatter", SplatterBrush(), nil),
            ("Ink", InkBrush(), nil),
            ("Eraser", EraserBrush(), "eraser")
        ]
        
        let shapeBrushes = brushes.filter { ["Arrow", "Circle", "Rectangle", "Triangle", "Star", "Hexagon", "Spiral"].contains($0.0) }
        let otherBrushes = brushes.filter { !["Arrow", "Circle", "Rectangle", "Star", "Hexagon", "Triangle", "Spiral"].contains($0.0) }
        
        let shapeActions = shapeBrushes.map { brush in
            let isSelected = brush.0 == selectedBrushTitle
            let attributes: UIMenuElement.Attributes = isSelected ? .disabled : []
            return UIAction(
                title: brush.0,
                image: isSelected ? UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) : nil,
                attributes: attributes
            ) { _ in
                self.selectedBrushTitle = brush.0
                self.canvas.setBrush(brush.1)
                self.updateBrushMenu()
                self.updateBrushNameLabel(with: brush.0) // Update the label
            }
        }
        
        let otherActions = otherBrushes.map { brush in
            let isSelected = brush.0 == selectedBrushTitle
            let attributes: UIMenuElement.Attributes = isSelected ? .disabled : []
            return UIAction(
                title: brush.0,
                image: brush.2 != nil ? UIImage(systemName: brush.2!) : (isSelected ? UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) : nil),
                attributes: attributes
            ) { _ in
                self.selectedBrushTitle = brush.0
                self.canvas.setBrush(brush.1)
                self.updateBrushMenu()
                self.updateBrushNameLabel(with: brush.0) // Update the label
            }
        }
        
        let customBrushAction = UIAction(title: "Custom Brushes", image: UIImage(systemName: "list.dash")) { _ in
            self.openTableViewController()
        }
        
        return [customBrushAction] + [UIMenu(title: "Shapes", children: shapeActions)] + otherActions
    }
    
    // Create and return actions for selecting line widths
    private func createLineWidthActions() -> [UIAction] {
        let lineWidths: [Float] = [1.0, 2.0, 4.0, 6.0, 8.0, 10.0, 16.0]
        
        return lineWidths.map { lineWidth in
            let isSelected = lineWidth == selectedLineWidth
            let attributes: UIMenuElement.Attributes = isSelected ? .disabled : []
            return UIAction(
                title: "\(lineWidth) points",
                image: isSelected ? UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) : nil,
                attributes: attributes
            ) { _ in
                self.selectedLineWidth = lineWidth
                self.canvas.strokeWidth = lineWidth
                self.updateLineWidthMenu()
            }
        }
    }
}
