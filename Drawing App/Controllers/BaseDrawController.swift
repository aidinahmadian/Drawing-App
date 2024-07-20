//
//  BaseDrawController.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/20/24.
//

import UIKit

class BaseDrawController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // Common Properties
    let drawSomethingLabel: UILabel = {
        let label = UILabel()
        label.text = "Draw Something!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()
    
    let savedLabel: UILabel = {
        let label = UILabel()
        label.text = "Saved To Camera Roll"
        label.backgroundColor = UIColor(red: 0.571, green: 0.274, blue: 0.999, alpha: 1)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.isHidden = true
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.tintColor = UIColor(red: 0.571, green: 0.274, blue: 0.999, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWasTouched), name: Notification.Name(rawValue: "viewWasTouched"), object: nil)
    }
    
    // Setup Methods
    func setupNavBarButtons() {
        //
    }
    
    func setupNavigationBarTitle(title: String) {
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
    }
    
    func setupLayout() {
        view.addSubview(drawSomethingLabel)
        drawSomethingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawSomethingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(savedLabel)
        savedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        savedLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        savedLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        savedLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
    }
    
    @objc func viewWasTouched(notification: NSNotification) {
        drawSomethingLabel.isHidden = true
    }
    
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
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
