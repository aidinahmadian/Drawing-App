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
    let canvas = SimpleDrawCanvas()
    
    override func loadView() {
        self.view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
        setupLayout()
        setupNavigationBarTitle(title: "Scribble")
        canvas.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWasTouched), name: Notification.Name(SimpleDrawCanvas.viewWasTouched), object: nil)
    }
    
    // Setup Methods
    override func setupNavBarButtons() {
        let undoButtonItem = UIBarButtonItem(title: "Undo", style: .plain, target: self, action: #selector(handleUndo))
        let clearButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(handleClear))
        
        let strokeImage = UIImage(systemName: "pencil.tip")
        let strokeButtonItem = UIBarButtonItem(image: strokeImage, style: .plain, target: self, action: #selector(tipButtonTapped))
        
        let colorImage = UIImage(systemName: "paintbrush.fill")
        let colorImageButtonItem = UIBarButtonItem(image: colorImage, style: .plain, target: self, action: #selector(colorButtonTapped))
        
        let brushImage = UIImage(systemName: "scribble")
        let brushButtonItem = UIBarButtonItem(image: brushImage, style: .plain, target: self, action: #selector(brushButtonTapped))
        
        navigationItem.rightBarButtonItems = [undoButtonItem, clearButtonItem, strokeButtonItem, colorImageButtonItem, brushButtonItem]
    }
    
    // Action Methods
    @objc fileprivate func handleUndo() {
        print("Undo Lines")
        canvas.undo()
    }
    
    @objc fileprivate func handleClear() {
        print("Clear Canvas")
        canvas.clear()
    }
    
    @objc func tipButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SimpleDrawCanvas else { return }
        
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
    
    @objc func colorButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SimpleDrawCanvas else { return }
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.strokeColor
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func brushButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Select Brush", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Line", style: .default, handler: { _ in
            self.canvas.setBrush(LineBrush())
        }))
        alert.addAction(UIAlertAction(title: "Dotted", style: .default, handler: { _ in
            self.canvas.setBrush(DottedBrush())
        }))
        alert.addAction(UIAlertAction(title: "Chalk", style: .default, handler: { _ in
            self.canvas.setBrush(ChalkBrush())
        }))
        alert.addAction(UIAlertAction(title: "Rust", style: .default, handler: { _ in
            self.canvas.setBrush(RustBrush())
        }))
        alert.addAction(UIAlertAction(title: "Square Texture", style: .default, handler: { _ in
            self.canvas.setBrush(SquareTextureBrush())
        }))
        alert.addAction(UIAlertAction(title: "Pencil", style: .default, handler: { _ in
            self.canvas.setBrush(PencilBrush())
        }))
        alert.addAction(UIAlertAction(title: "Charcoal", style: .default, handler: { _ in
            self.canvas.setBrush(CharcoalBrush())
        }))
        alert.addAction(UIAlertAction(title: "Pastel", style: .default, handler: { _ in
            self.canvas.setBrush(PastelBrush())
        }))
        alert.addAction(UIAlertAction(title: "Watercolor", style: .default, handler: { _ in
            self.canvas.setBrush(WatercolorBrush())
        }))
        alert.addAction(UIAlertAction(title: "Splatter", style: .default, handler: { _ in
            self.canvas.setBrush(SplatterBrush())
        }))
        alert.addAction(UIAlertAction(title: "Ink", style: .default, handler: { _ in
            self.canvas.setBrush(InkBrush())
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SimpleDrawController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        guard let view = self.view as? SimpleDrawCanvas else { return }
        view.strokeColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        guard let view = self.view as? SimpleDrawCanvas else { return }
        view.strokeColor = viewController.selectedColor
    }
}
