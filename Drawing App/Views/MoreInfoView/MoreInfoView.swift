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
    
    // Wallet Stack View
    private lazy var walletStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: walletButtons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Wallet Buttons
    private lazy var walletButtons: [UIButton] = {
        let coinbaseButton = createWalletButton(title: "Coinbase", address: "aiddiin.cb.id")
        let ethButton = createWalletButton(title: "ETH", address: "0x5E9f94e175a98564bE3962c4a7D1afA4c87F6b70")
        let btcButton = createWalletButton(title: "BTC", address: "bc1qvkq8uktdufujxme8xqwf3agq6366zsextye2lx")
        return [coinbaseButton, ethButton, btcButton]
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
        
        // Add wallet stack view to content view
        contentView.addSubview(walletStackView)
        
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
    
    // MARK: - Helper Methods
    
    private func createWalletButton(title: String, address: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.3528300911)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.yellow.cgColor
        button.layer.borderWidth = 0.7
        
        button.addAction(UIAction(handler: { _ in
            self.copyToClipboard(text: address)
        }), for: .touchUpInside)
        return button
    }
    
    private func copyToClipboard(text: String) {
        // Copy to clipboard
        UIPasteboard.general.string = text
        
        // Create an alert
        let alert = UIAlertController(title: "Copied 📋", message: "Wallet Address:\n\(text)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Find the top-most view controller to present the alert
        if let topViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })     // Get all UIWindowScene instances
            .flatMap({ $0.windows })                  // Get all windows for each scene
            .first(where: { $0.isKeyWindow })?.rootViewController { // Find the key window's root view controller
            
            // Find the top-most presented view controller if there is one
            var currentViewController = topViewController
            while let presentedViewController = currentViewController.presentedViewController {
                currentViewController = presentedViewController
            }
            
            // Present the alert from the top-most view controller
            currentViewController.present(alert, animated: true, completion: nil)
        }
        
        // Generate haptic feedback
        generateHapticFeedback(.soft)
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
            
            // Wallet stack view constraints
            walletStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            walletStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            walletStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            walletStackView.heightAnchor.constraint(equalToConstant: 50),
            
            celebrationBT.topAnchor.constraint(equalTo: walletStackView.bottomAnchor, constant: 10),
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
