//
//  DetailViewController.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/5/24.
//

import UIKit

class BrushDetailsViewController: UIViewController {

    var brushItem: BrushItem?

    let dismissLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Swipe down to\ndismiss"
        return label
    }()

    let dismissIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "icons8-chevron-right-72()")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        if let brushItem = brushItem {
            title = brushItem.name
            setupUI()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dismissLabel.startBlink()
        dismissIcon.startBlink()
        dismissLabel.startBlinkingAnimations()
        dismissIcon.startBlinkingAnimations()
    }

    private func setupUI() {
        let label = createLabel(text: brushItem?.name, fontSize: 16)

        view.addSubview(label)
        view.addSubview(dismissLabel)
        view.addSubview(dismissIcon)

        NSLayoutConstraint.activate([
            dismissLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            dismissLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dismissIcon.topAnchor.constraint(equalTo: dismissLabel.bottomAnchor),
            dismissIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func createLabel(text: String?, fontSize: CGFloat, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
}