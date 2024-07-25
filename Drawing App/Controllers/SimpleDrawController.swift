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
    
    override func loadView() {
        view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
        setupLayout()
        setupNavigationBarTitle(title: "Scribble")
        canvas.backgroundColor = .white
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewWasTouched),
            name: Notification.Name(SimpleDrawCanvas.viewWasTouched),
            object: nil
        )
    }
    
    // Setup Methods
    override func setupNavBarButtons() {
        navigationItem.rightBarButtonItems = createNavBarButtonItems()
    }
    
    private func createNavBarButtonItems() -> [UIBarButtonItem] {
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
            UIBarButtonItem(image: UIImage(systemName: "pencil.tip"), style: .plain, target: self, action: #selector(tipButtonTapped)),
            UIBarButtonItem(image: UIImage(systemName: "paintbrush.fill"), style: .plain, target: self, action: #selector(colorButtonTapped)),
            UIBarButtonItem(image: UIImage(systemName: "scribble.variable"), style: .plain, target: self, action: #selector(brushButtonTapped))
        ]
        
        return buttonItems
    }
    
    // Action Methods
    @objc private func handleUndo() {
        generateHapticFeedback(.soft)
        print("Undo Lines")
        canvas.undo()
    }
    
    @objc private func handleClear() {
        generateHapticFeedback(.rigid)
        print("Clear Canvas")
        canvas.clear()
    }
    
    @objc private func tipButtonTapped(_ sender: UIBarButtonItem) {
        presentLineWidthPicker(sender: sender)
    }
    
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
    
    @objc private func colorButtonTapped(_ sender: UIBarButtonItem) {
        presentColorPicker(sender: sender)
        generateHapticFeedback(.selection)
    }
    
    private func presentColorPicker(sender: UIBarButtonItem) {
        guard let view = view as? SimpleDrawCanvas else { return }
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.strokeColor
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc private func brushButtonTapped(_ sender: UIBarButtonItem) {
        presentBrushPicker(sender: sender)
        generateHapticFeedback(.selection)
    }
    
    private func presentBrushPicker(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Select Brush", message: nil, preferredStyle: .actionSheet)
        
        let brushes: [(String, Brush)] = [
            ("Line", LineBrush()),
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
