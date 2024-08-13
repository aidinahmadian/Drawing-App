//
//  MoreInfoView.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/23/24.
//

import UIKit
import SafariServices

// Custom UIView class for displaying more information
class MoreInfoView: UIView {
    
    // MARK: - UI Elements
    
    private let scrollView = UIScrollView() // Scrollable container
    private let contentView = UIView() // Container for all content inside the scroll view
    
    // HeartImage View
    let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // ThankYou Label
    let thankYouLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank You"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Message Label with attributed text
    let messageLabel: UILabel = {
        let label = UILabel()
        
        // Message text
        let text = """
        
        Your support means the world to me. If you’d like to help with the growth and improvement of DrawingApp, here are a few ways you can contribute:
        
        - Provide Feedback: Your insights are invaluable. Please share your thoughts, suggestions, and any issues you encounter. This helps me make DrawingApp better for everyone.
        - Make a Donation: If you’re able to, consider making a financial contribution. Every bit helps me maintain and enhance the app, bringing you more features and a better experience.
        
        If you’d like to support me, there’s some options below!
        - Aidin (u/Aidin)
        """
        
        // Attributing bold font to specific parts of the text
        let attributedText = NSMutableAttributedString(string: text)
        let provideFeedbackRange = (text as NSString).range(of: "Provide Feedback:")
        let makeDonationRange = (text as NSString).range(of: "Make a Donation:")
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        attributedText.addAttribute(.font, value: boldFont, range: provideFeedbackRange)
        attributedText.addAttribute(.font, value: boldFont, range: makeDonationRange)
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Celebration Button
    let celebrationBT: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Celebration Button 🎉", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // OtherProjects Button
    let otherProjectsBT: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check Out My Other Projects ✨", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemPink
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        // button.addTarget(self, action: #selector(otherProjcsAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Gradient Layer for background
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        setupGradientBackground()
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(heartImageView)
        contentView.addSubview(thankYouLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(celebrationBT)
        contentView.addSubview(otherProjectsBT)
        setupConstraints()
    }
    
    private func setupGradientBackground() {
        // Configure gradient colors and direction
        gradientLayer.colors = [#colorLiteral(red: 0.8549019608, green: 0.8862745098, blue: 0.9725490196, alpha: 1).cgColor, #colorLiteral(red: 0.8392156863, green: 0.6431372549, blue: 0.6431372549, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 0.7)
        layer.insertSublayer(gradientLayer, at: 0) // Insert gradient as the bottom-most layer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds // Ensure the gradient covers the entire view
    }
    
    // MARK: - Constraints Setup
    
    private func setupConstraints() {
        // Disable autoresizing mask constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate layout constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            heartImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            heartImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heartImageView.widthAnchor.constraint(equalToConstant: 50),
            heartImageView.heightAnchor.constraint(equalToConstant: 50),
                        
            thankYouLabel.topAnchor.constraint(equalTo: heartImageView.bottomAnchor, constant: 20),
            thankYouLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: thankYouLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            celebrationBT.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            celebrationBT.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            celebrationBT.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            celebrationBT.heightAnchor.constraint(equalToConstant: 50),
            
            otherProjectsBT.topAnchor.constraint(equalTo: celebrationBT.bottomAnchor, constant: 10),
            otherProjectsBT.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            otherProjectsBT.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            otherProjectsBT.heightAnchor.constraint(equalToConstant: 50),
            otherProjectsBT.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
