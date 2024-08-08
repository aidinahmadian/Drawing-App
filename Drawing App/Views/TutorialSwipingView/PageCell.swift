//
//  PageCell.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit
import AVKit

class PageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var page: Page? {
        didSet {
            guard let page = page else { return }
            configurePage(page)
        }
    }
    
    // MARK: - UI Components
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let videoPlayerController: AVPlayerViewController = {
        let vc = AVPlayerViewController()
        vc.showsPlaybackControls = false
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.videoGravity = .resizeAspectFill
        vc.view.backgroundColor = .white
        return vc
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupDefaultText()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configurePage(_ page: Page) {
        configureImageView(with: page.imageName)
        configureVideoPlayer(with: page.videoName)
        configureDescriptionText(header: page.headerText, body: page.bodyText)
    }
    
    private func configureImageView(with imageName: String?) {
        if let imageName = imageName {
            mainImageView.image = UIImage(named: imageName)
            mainImageView.isHidden = false
            videoPlayerController.view.isHidden = true
        }
    }
    
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
        //descriptionTextView.textAlignment = .center
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
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
    
    private func setupDefaultText() {
        descriptionTextView.attributedText = PageCell.defaultAttributedText()
    }
    
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
