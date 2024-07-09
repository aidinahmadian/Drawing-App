//
//  SimpleDrawController.swift
//  Test
//
//  Created by aidin ahmadian on 7/26/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class SimpleDrawController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Properties
    
    let canvas = SimpleDrawCanvas()
    
    let drawSomethingLabel: UILabel! = {
        let label = UILabel()
        label.text = "Draw Something!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.backgroundColor = .red
        return label
    }()
    
    let savedLabel: UILabel! = {
        let label = UILabel()
        label.text = "Saved To Camera Roll"
        label.backgroundColor = #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.isHidden = true
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        self.view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
        setupLayout()
        setupNavigationBarTitle()
        canvas.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWasTouched), name: Notification.Name(SimpleDrawCanvas.viewWasTouched), object: nil)
    }
    
    // MARK: - Setup Methods
    
    func setupNavBarButtons() {
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
    
    func setupNavigationBarTitle() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Scribble"
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
    }
    
    fileprivate func setupLayout() {
        view.addSubview(drawSomethingLabel)
        drawSomethingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawSomethingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(savedLabel)
        savedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        savedLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        savedLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        savedLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
    }
    
    // MARK: - Action Methods
    
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
        let brushes: [(title: String, brush: Brush)] = [
            ("Line", LineBrush()),
            ("Dotted", DottedBrush()),
            ("Chalk", ChalkBrush()),
            ("Rust", RustBrush()),
            ("Square Texture", SquareTextureBrush()),
            ("Pencil", PencilBrush()),
            ("Charcoal", CharcoalBrush()),
            ("Pastel", PastelBrush())
        ]
        
        let alert = UIAlertController(title: "Select Brush", message: nil, preferredStyle: .actionSheet)
        
        for (title, brush) in brushes {
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { _ in
                self.canvas.setBrush(brush)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    
    @objc func viewWasTouched(notification: NSNotification) {
        self.drawSomethingLabel.isHidden = true
    }
    
    // MARK: - Utility Methods
    
    func presentPopover(_ controller: UIViewController, sender: UIBarButtonItem) {
        self.dismiss(animated: false)
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 200)
        if let presentationController = controller.popoverPresentationController {
            presentationController.delegate = self
            presentationController.barButtonItem = sender
            presentationController.permittedArrowDirections = [.down, .up]
        }
        self.present(controller, animated: true)
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
