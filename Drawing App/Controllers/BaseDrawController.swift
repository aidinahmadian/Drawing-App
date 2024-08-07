//
//  BaseDrawController.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/20/24.
//

//import UIKit
//
//class BaseDrawController: UIViewController, UIPopoverPresentationControllerDelegate {
//    
//    // Common Properties
//    let drawSomethingLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Draw Something!"
//        label.font = UIFont.customFont(name: "HelveticaNeue", size: 18)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .gray
//        return label
//    }()
//    
//    let savedLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Saved To Camera Roll"
//        label.backgroundColor = UIColor(red: 0.571, green: 0.274, blue: 0.999, alpha: 1)
//        label.textAlignment = .center
//        label.layer.cornerRadius = 8
//        label.clipsToBounds = true
//        label.isHidden = true
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        navigationController?.view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.isTranslucent = false
//        //navigationController?.navigationBar.tintColor = UIColor(red: 0.571, green: 0.274, blue: 0.999, alpha: 1)
//        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
//        //navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.1607843137, blue: 0.3568627451, alpha: 1)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(viewWasTouched), name: Notification.Name(rawValue: "viewWasTouched"), object: nil)
//    }
//    
//    // Setup Methods
//    func setupNavBarButtons() {
//        //
//    }
//    
//    func setupNavigationBarTitle(title: String) {
//        let titleLabel = UILabel()
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.text = title
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        titleLabel.textAlignment = .left
//        titleLabel.textColor = .black
//        
//        let containerView = UIView()
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(titleLabel)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
//        ])
//        
//        let leftItem = UIBarButtonItem(customView: containerView)
//        navigationItem.leftBarButtonItem = leftItem
//    }
//    
//    func setupLayout() {
//        view.addSubview(drawSomethingLabel)
//        drawSomethingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        drawSomethingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        
//        view.addSubview(savedLabel)
//        savedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        savedLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
//        savedLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        savedLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
//    }
//    
//    @objc func viewWasTouched(notification: NSNotification) {
//        drawSomethingLabel.isHidden = true
//    }
//    
//    func presentPopover(_ controller: UIViewController, sender: UIBarButtonItem) {
//        self.dismiss(animated: false)
//        controller.modalPresentationStyle = .popover
//        controller.preferredContentSize = CGSize(width: 300, height: 200)
//        if let presentationController = controller.popoverPresentationController {
//            presentationController.delegate = self
//            presentationController.barButtonItem = sender
//            presentationController.permittedArrowDirections = [.down, .up]
//        }
//        self.present(controller, animated: true)
//    }
//    
//    // MARK: - UIPopoverPresentationControllerDelegate
//    
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }
//}

import UIKit

class BaseDrawController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // Common Properties
    let drawSomethingLabel: UILabel = {
        let label = UILabel()
        label.text = "Draw Something!"
        label.font = UIFont.customFont(name: "HelveticaNeue", size: 18)
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
    
    var areNavBarButtonsExpanded = false
    var navBarButtonItems: [UIBarButtonItem] = []
    var titleView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWasTouched), name: Notification.Name("viewWasTouched"), object: nil)
        
        setupLayout()
    }
    
    // Setup Methods
    func setupNavBarButtons() {
        // Override in subclasses to set up nav bar buttons
    }
    
    func setupNavigationBarTitle(title: String) {
        let titleButton = UIButton(type: .system)
        titleButton.translatesAutoresizingMaskIntoConstraints = false

        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.customFont(name: "Milanello", size: 24),
                .foregroundColor: UIColor(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        titleButton.setAttributedTitle(attributedTitle, for: .normal)
        
        let titleMenu = createTitleMenu()
        titleButton.menu = titleMenu
        titleButton.showsMenuAsPrimaryAction = true
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleButton)
        
        NSLayoutConstraint.activate([
            titleButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        let leftItem = UIBarButtonItem(customView: containerView)
        navigationItem.leftBarButtonItem = leftItem
        
        titleView = containerView
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
    
    func createTitleMenu() -> UIMenu {
        let item1 = UIAction(title: "Playground", image: UIImage(systemName: "bubbles.and.sparkles")) { [weak self] _ in
            guard let self = self else { return }
            let cpvc = ColorPickerViewController()
            generateHapticFeedback(.selection)
            self.present(cpvc, animated: true, completion: nil)
        }

        let item2 = UIAction(title: "Support Me", image: UIImage(systemName: "heart")) { [weak self] _ in
            guard let self = self else { return }
            let moreInfoVC = MoreInfoVC()
            generateHapticFeedback(.selection)
            self.present(moreInfoVC, animated: true, completion: nil)
        }

        let item3 = UIAction(title: "Introduction Page", image: UIImage(systemName: "lightbulb.min")) { [weak self] _ in
            guard let self = self else { return }

            let alert = UIAlertController(title: "Go Back to Tutorial Page?", message: "If you go back to the tutorial, any unsaved progress will be lost. Are you sure you want to continue?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { [weak self] _ in
                guard let self = self else { return }
                self.presentIntroductionController()
            }))

            generateHapticFeedback(.selection)
            self.present(alert, animated: true, completion: nil)
        }

        return UIMenu(title: "", children: [item1, item2, item3])
    }

    private func presentIntroductionController() {
        let introductionController = SwipingController()

        introductionController.onFinish = {
            introductionController.dismiss(animated: true, completion: nil)
        }

        introductionController.modalTransitionStyle = .crossDissolve
        introductionController.modalPresentationStyle = .fullScreen
        present(introductionController, animated: true, completion: nil)
    }

    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
