//
//  SimpleDrawController.swift
//  Test
//
//  Created by aidin ahmadian on 7/26/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class SimpleDrawController: BaseDrawController, BrushSelectionDelegate, UIColorPickerViewControllerDelegate {
    
    // Properties
    private let canvas = SimpleDrawCanvas()
    private var isGridVisible = false
    private var gridButton: UIBarButtonItem?
    private var toggleLabel: UILabel!
    private var blurEffectView: UIVisualEffectView!
    private var selectedBrushTitle: String?
    private var selectedLineWidth: Float?
    private var isMoveMode = false
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBarButtons()
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
        configureToggleLabel()
        configureBlurEffectView()
    }
    
    private func configureToggleLabel() {
        toggleLabel = UILabel()
        toggleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleLabel.textAlignment = .center
        toggleLabel.textColor = UIColor.black

        let imageAttachment = NSTextAttachment()
        if let image = UIImage(systemName: "arrow.up.and.down.and.arrow.left.and.right") {
            imageAttachment.image = image

            let imageAspectRatio = image.size.width / image.size.height
            let imageHeight: CGFloat = 16.0
            let imageWidth = imageHeight * imageAspectRatio
            
            imageAttachment.bounds = CGRect(x: 0, y: -2.0, width: imageWidth, height: imageHeight)
        }

        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: " Move Mode Enabled")
        completeText.append(textAfterIcon)

        toggleLabel.attributedText = completeText
    }

    private func configureBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.borderWidth = 0.8
        blurEffectView.layer.borderColor = UIColor.orange.cgColor
        blurEffectView.layer.cornerRadius = 12
        blurEffectView.layer.masksToBounds = true
        view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(toggleLabel)
        
        blurEffectView.alpha = 0.0
        setupBlurEffectViewConstraints()
    }

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
    
    override func setupNavBarButtons() {
        let expandButton = UIBarButtonItem(image: UIImage(systemName: "shippingbox.and.arrow.backward.fill"), style: .plain, target: self, action: #selector(toggleNavBarButtons))
        navigationItem.rightBarButtonItems = [expandButton]
        navBarButtonItems = createNavBarButtonItems()
    }
    
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
        
        let buttonItems = [
            brushButton,
            lineWidthButton,
            UIBarButtonItem(image: UIImage(systemName: "paintpalette"), style: .plain, target: self, action: #selector(colorButtonTapped)),
            gridButton!,
            modeToggleButton,
            cancelButton,
        ]
        return buttonItems
    }
    
    private func createBrushActions() -> [UIMenuElement] {
        let brushes: [(String, Brush)] = [
            // Shapes
            ("Arrow", ArrowBrush()),
            ("Circle", CircleBrush()),
            ("Rectangle", RectangleBrush()),
            ("Triangle", TriangleBrush()),
            ("Star", StarBrush()),
            ("Hexagon", HexagonBrush()),
            ("Spiral", SpiralBrush()),
            // Other Brushes
            ("Line", LineBrush()),
            ("Straight Line", StraightLineBrush()),
            ("Dotted", DottedBrush()),
            ("Rust", RustBrush()),
            ("Watercolor", WatercolorBrush()),
            ("Splatter", SplatterBrush()),
            ("Ink", InkBrush()),
        ]

        let shapeBrushes = brushes.filter { ["Arrow" ,"Circle", "Rectangle", "Triangle", "Star", "Hexagon", "Spiral"].contains($0.0) }
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
            }
        }

        let shapesMenu = UIMenu(title: "Shapes", children: shapeActions)
        
        let otherActions = otherBrushes.map { brush in
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
            }
        }

        let customBrushAction = UIAction(title: "Custom Brushes", image: UIImage(systemName: "list.dash")) { _ in
            self.openTableViewController()
        }

        return [customBrushAction] + [shapesMenu] + otherActions
    }
    
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
    
    private func updateBrushMenu() {
        let brushActions = createBrushActions()
        let brushMenu = UIMenu(title: "Select Brush", children: brushActions)
        
        if let brushButton = navBarButtonItems.first(where: { $0.image == UIImage(systemName: "scribble.variable") }) {
            brushButton.menu = brushMenu
        }
    }
    
    private func updateLineWidthMenu() {
        let lineWidthActions = createLineWidthActions()
        let lineWidthMenu = UIMenu(title: "Line Width", children: lineWidthActions)
        
        if let lineWidthButton = navBarButtonItems.first(where: { $0.image == UIImage(systemName: "pencil.tip") }) {
            lineWidthButton.menu = lineWidthMenu
        }
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
        
        let gridImageName = isGridVisible ? "grid.circle.fill" : "grid.circle"
        gridButton?.image = UIImage(systemName: gridImageName)
    }
    
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
    
    @objc private func colorButtonTapped(_ sender: UIBarButtonItem) {
        presentColorPicker(sender: sender)
        generateHapticFeedback(.selection)
    }
    
    // MARK: - New Action Method
    @objc func openTableViewController(_ sender: UIBarButtonItem? = nil) {
        let tableViewController = TableViewController()
        tableViewController.canvas = self.canvas
        tableViewController.delegate = self
        let navController = UINavigationController(rootViewController: tableViewController)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - BrushSelectionDelegate Method
    func didSelectBrush(_ brush: Brush) {
        canvas.setBrush(brush)
        print("Selected brush: \(brush)")
    }
    
    // MARK: - Helper Methods
    private func presentColorPicker(sender: UIBarButtonItem) {
        guard let view = view as? SimpleDrawCanvas else { return }
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.strokeColor
        present(colorPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIColorPickerViewControllerDelegate
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        updateCanvasColor(with: viewController.selectedColor)
        generateHapticFeedback(.selection)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        updateCanvasColor(with: viewController.selectedColor)
        generateHapticFeedback(.selection)
    }
    
    private func updateCanvasColor(with color: UIColor) {
        guard let view = view as? SimpleDrawCanvas else { return }
        view.strokeColor = color
    }
}
