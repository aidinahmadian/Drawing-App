//
//  PageCell.swift
//  Test
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {

    // MARK: - Properties

    var page: Page? {
        didSet {
            guard let unwrappedPage = page else { return }
            configurePage(unwrappedPage)
        }
    }

    // MARK: - UI Components

    private let mainImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "picone"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.attributedText = defaultAttributedText()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configurePage(_ page: Page) {
        mainImageView.image = UIImage(named: page.imageName)
        
        let attributedText = NSMutableAttributedString(
            string: page.headerText,
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        )
        attributedText.append(NSAttributedString(
            string: "\n\n\n\(page.bodyText)",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        ))
        
        descriptionTextView.attributedText = attributedText
        descriptionTextView.textAlignment = .center
    }

    // MARK: - Layout Setup

    private func setupLayout() {
        let topImageContainerView = UIView()
        addSubview(topImageContainerView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topImageContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topImageContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topImageContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
        
        topImageContainerView.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor),
            //mainImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor)
            mainImageView.heightAnchor.constraint(equalToConstant: 350),
            mainImageView.widthAnchor.constraint(equalToConstant: 350),
        ])
        
        addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Helper Methods

    private static func defaultAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: "TEST",
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        )
        attributedText.append(NSAttributedString(
            string: "\n\n\nTEST",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        ))
        return attributedText
    }
}
