//
//  SymmetrixViewController.swift
//  Test
//
//  Created by aidin ahmadian on 7/21/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class PatternViewController: UIViewController, UIPopoverPresentationControllerDelegate {
        
    // MARK: - Main ViewControlle --> Setup Labels
    
    let patternView = PatternView()
    
    override func loadView() {
        self.view = patternView
    }
    
    let drawSomethingLabel: UILabel! = {
        let DSL = UILabel()
        DSL.text = "Draw Something!"
        DSL.translatesAutoresizingMaskIntoConstraints = false
        DSL.textColor = .gray
        return DSL
    }()
    
    let savedLabel: UILabel! = {
        let SL = UILabel()
        SL.text = "Saved To Camera Roll"
        SL.backgroundColor = #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1)
        SL.textAlignment = .center
        SL.layer.cornerRadius = 8
        SL.clipsToBounds = true
        SL.isHidden = true
        SL.textColor = .white
        SL.translatesAutoresizingMaskIntoConstraints = false
        return SL
    }()

    // MARK: - UIViewController - (viewDidLoad)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupNavBarButtons()
        setupNavigationBarTitle()
        navigationController?.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWasTouched), name: Notification.Name(PatternView.viewWasTouched), object: nil)
    }
    
    func setupNavigationBarTitle() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Pattern"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Constraints for titleLabel within containerView
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)  // Optional: Ensures the label doesn't overflow
        ])

        // Set containerView as the custom view for leftBarButtonItem
        let leftItem = UIBarButtonItem(customView: containerView)
        navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func viewWasTouched(notification: NSNotification) {
        self.drawSomethingLabel.isHidden = true
    }

    // MARK: - Setup NavigationBar Buttons
    
    func setupNavBarButtons() {
        let clearImage = UIImage(systemName: "trash")
        let clearImageButtonItem = UIBarButtonItem(image: clearImage, style: .plain, target: self, action: #selector(handleClear))
        
        let tipImage = UIImage(systemName: "pencil.tip")
        let tipImageButtonItem = UIBarButtonItem(image: tipImage, style: .plain, target: self, action: #selector(handleTip))
        
        let colorImage = UIImage(systemName: "paintbrush.fill")
        let colorImageButtonItem = UIBarButtonItem(image: colorImage, style: .plain, target: self, action: #selector(handleColor))
        
        let turnImage = UIImage(systemName: "light.max")
        let turnImageButtonItem = UIBarButtonItem(image: turnImage, style: .plain, target: self, action: #selector(handleTurn))
        
        let saveImage = UIImage(systemName: "arrow.down.circle.fill")
        let saveImageButtonItem = UIBarButtonItem(image: saveImage, style: .plain, target: self, action: #selector(handleSave))
        
        navigationItem.rightBarButtonItems = [clearImageButtonItem, tipImageButtonItem, colorImageButtonItem, turnImageButtonItem, saveImageButtonItem]
    }
    
    @objc func handleClear(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }
        view.clear()
    }
    
    @objc func handleTip(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }

        let items:[CGFloat] = [1.0, 2.0, 4.0, 8.0, 16.0]
        let controller = ArrayChoiceTableViewController(
            items,
            header: "Line width",
            labels: { "\($0) points\($0 == view.lineWidth ? " ✔️" : "")" }
        ) { view.lineWidth = $0 }

        presentPopover(controller, sender: sender)
    }
    
    @objc func handleColor(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = view.lineColor
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func handleTurn(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }
        
        let items:[Int] = [1, 2, 3, 4, 8, 16, 32]
        let controller = ArrayChoiceTableViewController(
            items,
            header: "Brushes",
            labels: { "\($0)x\($0 == view.turns ? " ✔️" : "")" }
        ) { view.turns = $0 }

        presentPopover(controller, sender: sender)
    }
    
    @objc func handleSave(_ sender: UIButton) {
        guard let view = self.view as? PatternView, let image = view.getImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        savedLabel.isHidden = false
        savedLabel.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
            self.savedLabel.alpha = 0.0
        }) { _ in
            self.savedLabel.isHidden = true
        }
    }
    
    //MARK: - Setup Layout
    
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
    
    // MARK: - Utility
    
    func presentPopover(_ controller: UIViewController, sender: UIBarButtonItem) {
        self.dismiss(animated: false)
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 200)
        if let presentationController = controller.popoverPresentationController {
            presentationController.delegate = self
            presentationController.barButtonItem = sender
            //presentationController.sourceView = sender
            presentationController.permittedArrowDirections = [.down, .up]
        }
        self.present(controller, animated: true)
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension PatternViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        guard let view = self.view as? PatternView else { return }
        view.lineColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        guard let view = self.view as? PatternView else { return }
        view.lineColor = viewController.selectedColor
    }
}
