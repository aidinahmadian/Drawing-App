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
        DSL.text = "Draw Somthing!"
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
        navigationController?.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 90, height: view.frame.height))
        titleLabel.text = "Pattern"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWasTouched), name: Notification.Name(PatternView.viewWasTouched), object: nil)
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
        let controller = ArrayChoiceTableViewController(items, header: "Line width", labels: { "\($0) points" + ($0 == view.lineWidth ? "*" : "") }) { (value) in
            view.lineWidth = value
        }
        presentPopover(controller, sender: sender)
    }
    
    @objc func handleColor(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }
        
        let items:[UIColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)]
        let controller = ArrayChoiceTableViewController(items, header: "Line color", labels: { value in "" }) { value in
            view.lineColor = value
        }
        presentPopover(controller, sender: sender)
    }
    
    @objc func handleTurn(_ sender: UIBarButtonItem) {
        guard let view = self.view as? PatternView else { return }
        
        let items:[Int] = [1, 2, 3, 4, 8, 16, 32]
        let controller = ArrayChoiceTableViewController(items, header: "Brushes", labels: { "\($0)x" + ($0 == view.turns ? "*" : "") }) { (value) in
            view.turns = value
        }
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
