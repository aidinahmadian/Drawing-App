//
//  PageCell.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit
import AVKit

// MARK: - PageCell: Custom UICollectionViewCell

class PageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // Page property to configure the cell when set
    var page: Page? {
        didSet {
            guard let page = page else { return }
            configurePage(page)
        }
    }
    
    // MARK: - UI Components
    
    // Image view for displaying the main image
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Text view for displaying the description text
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    // Video player controller for displaying video content
    private let videoPlayerController: AVPlayerViewController = {
        let vc = AVPlayerViewController()
        vc.showsPlaybackControls = false
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.videoGravity = .resizeAspectFill
        vc.view.backgroundColor = .white
        return vc
    }()
    
    // MARK: - Initializers
    
    // Initializer for creating the cell programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupDefaultText()
        backgroundColor = .white
    }
    
    // Initializer when creating the cell from a storyboard or XIB file
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    // Configure the cell with a Page object
    private func configurePage(_ page: Page) {
        configureImageView(with: page.imageName)
        configureVideoPlayer(with: page.videoName)
        configureDescriptionText(header: page.headerText, body: page.bodyText)
    }
    
    // Configure the main image view with an image name
    private func configureImageView(with imageName: String?) {
        if let imageName = imageName {
            mainImageView.image = UIImage(named: imageName)
            mainImageView.isHidden = false
            videoPlayerController.view.isHidden = true
        }
    }
    
    // Configure the video player with a video name
    private func configureVideoPlayer(with videoName: String?) {
        guard let videoName = videoName, let videoURL = Bundle.main.url(forResource: videoName, withExtension: nil) else {
            return
        }
        
        let player = AVPlayer(url: videoURL)
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        videoPlayerController.player = player
        videoPlayerController.view.isHidden = false
        mainImageView.isHidden = true
        player.play()
    }
    
    // Configure the description text with a header and body
    private func configureDescriptionText(header: String, body: String) {
        let attributedText = NSMutableAttributedString(
            string: header,
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        )
        attributedText.append(NSAttributedString(
            string: "\n\n\n\(body)",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        ))
        descriptionTextView.attributedText = attributedText
    }
    
    // Handle the event when the video player reaches the end
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    
    // MARK: - Layout Setup
    
    // Setup the layout of the cell's subviews
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
            mainImageView.heightAnchor.constraint(equalToConstant: 350),
            mainImageView.widthAnchor.constraint(equalToConstant: 350)
        ])
        
        topImageContainerView.addSubview(videoPlayerController.view)
        NSLayoutConstraint.activate([
            videoPlayerController.view.topAnchor.constraint(equalTo: topImageContainerView.topAnchor),
            videoPlayerController.view.leadingAnchor.constraint(equalTo: topImageContainerView.leadingAnchor),
            videoPlayerController.view.trailingAnchor.constraint(equalTo: topImageContainerView.trailingAnchor),
            videoPlayerController.view.bottomAnchor.constraint(equalTo: topImageContainerView.bottomAnchor)
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
    
    // Setup the default text for the descriptionTextView
    private func setupDefaultText() {
        descriptionTextView.attributedText = PageCell.defaultAttributedText()
    }
    
    // Generate the default attributed text
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
