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
        let buttonItems = [
            ("Undo", nil, #selector(handleUndo)),
            ("Clear", nil, #selector(handleClear)),
            (nil, "pencil.tip", #selector(tipButtonTapped)),
            (nil, "paintbrush.fill", #selector(colorButtonTapped)),
            (nil, "scribble.variable", #selector(brushButtonTapped))
        ].map { (title, imageName, selector) in
            if let title = title {
                return UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
            } else if let imageName = imageName {
                return UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: selector)
            }
            fatalError("Either title or imageName must be provided")
        }
        
        return buttonItems
    }
    
    // Action Methods
    @objc private func handleUndo() {
        print("Undo Lines")
        canvas.undo()
    }
    
    @objc private func handleClear() {
        print("Clear Canvas")
        canvas.clear()
    }
    
    @objc private func tipButtonTapped(_ sender: UIBarButtonItem) {
        presentLineWidthPicker(sender: sender)
    }
    
    private func presentLineWidthPicker(sender: UIBarButtonItem) {
        guard let view = view as? SimpleDrawCanvas else { return }
        
        let items: [Float] = [1.0, 2.0, 4.0, 8.0, 16.0]
        let controller = ArrayChoiceTableViewController(
            items,
            header: "Line width",
            labels: { item in
                "\(item) points" + (item == view.strokeWidth ? " ✔️" : "")
            }
        ) { value in
            view.strokeWidth = value
        }
        
        presentPopover(controller, sender: sender)
    }
    
    @objc private func colorButtonTapped(_ sender: UIBarButtonItem) {
        presentColorPicker(sender: sender)
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
    }
}

extension SimpleDrawController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        updateCanvasColor(with: viewController.selectedColor)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        updateCanvasColor(with: viewController.selectedColor)
    }
    
    private func updateCanvasColor(with color: UIColor) {
        guard let view = view as? SimpleDrawCanvas else { return }
        view.strokeColor = color
    }
}
