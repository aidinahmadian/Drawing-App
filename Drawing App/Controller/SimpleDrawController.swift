//
//  SimpleDrawController.swift
//  Test
//
//  Created by aidin ahmadian on 7/26/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class SimpleDrawController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    //MARK: - Setup MainView / Buttons / Slider
    
    let canvas = SimpleDrawCanvas()
    
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
    
    // MARK: - Setup NavigationBar Buttons
    
    func setupNavBarButtons() {

        let undoButtonItem = UIBarButtonItem(title: "Undo", style: .plain, target: self, action: #selector(handleUndo))
        let clearButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(handleClear))
        
        let strokeImage = UIImage(systemName: "pencil.tip")
        let strokeButtonItem = UIBarButtonItem(image: strokeImage, style: .plain, target: self, action: #selector(tipButtonTapped))
        
        let colorImage = UIImage(systemName: "paintbrush.fill")
        let colorImageButtonItem = UIBarButtonItem(image: colorImage, style: .plain, target: self, action: #selector(colorButtonTapped))
        
        navigationItem.rightBarButtonItems = [undoButtonItem, clearButtonItem, strokeButtonItem, colorImageButtonItem]
    }
    
    // MARK: - Setup Button/Slider Functions
    
    @objc fileprivate func  handleUndo() {
        print("Undo Lines")
        canvas.undo()
    }
    
    @objc fileprivate func handleClear() {
        print("Clear Canvas")
        canvas.clear()
    }
    
    @objc func tipButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SimpleDrawCanvas else { return }
        
        let items:[Float] = [1.0, 2.0, 4.0, 8.0, 16.0]

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
        
        let items:[UIColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)]
        
        let controller = ArrayChoiceTableViewController(
            items,
            header: "Line color",
            labels: { item in
                item == view.strokeColor ? " ✔️" : ""
            }
        ) { value in
            view.strokeColor = value
        }

        presentPopover(controller, sender: sender)
    }

    // MARK: - UIViewController
    
    override func loadView() {
        self.view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
        setupLayout()
        canvas.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 246.5, height: view.frame.height))
        titleLabel.text = "Scribble"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWasTouched), name: Notification.Name(SimpleDrawCanvas.viewWasTouched), object: nil)
    }
    
    @objc func viewWasTouched(notification: NSNotification) {
        self.drawSomethingLabel.isHidden = true
    }
    
    // MARK: - Setup Layout
    
    fileprivate func setupLayout() {
        
        view.addSubview(drawSomethingLabel)
        drawSomethingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawSomethingLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -271).isActive = true
        
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
}
