//
//  MoreInfoView.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/23/24.
//

import UIKit

class MoreInfoView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let thankYouLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank You"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        
        let text = """
        
        Your support means the world to me, and if you would like to contribute to the continued growth and improvement of DrawingApp, here are a few ways you can do so:
        - Provide Feedback: Your insights are invaluable. Please share your thoughts, suggestions, and any issues you encounter. This helps us make DrawingApp better for everyone.
        - Make a Donation: If you’re able to, consider making a financial contribution. Every bit helps us maintain and enhance the app, bringing you more features and a better experience.
        
        If you’d like to support me, there’s some options below!
        - Aidin (u/Aidin)
        """
        
        let attributedText = NSMutableAttributedString(string: text)
        
        let provideFeedbackRange = (text as NSString).range(of: "Provide Feedback:")
        let makeDonationRange = (text as NSString).range(of: "Make a Donation:")
        
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        attributedText.addAttribute(.font, value: boldFont, range: provideFeedbackRange)
        attributedText.addAttribute(.font, value: boldFont, range: makeDonationRange)
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let wallpaperButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Thanks For Your Support 🩵", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pixelPalsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check Out My Other Projects ✨", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemPink
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupGradientBackground()
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(heartImageView)
        contentView.addSubview(thankYouLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(wallpaperButton)
        contentView.addSubview(pixelPalsButton)
        setupConstraints()
    }
    
    private func setupGradientBackground() {
        //gradientLayer.colors = [#colorLiteral(red: 0.6807965636, green: 0.6584963202, blue: 0.9920480847, alpha: 1).cgColor, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        gradientLayer.colors = [#colorLiteral(red: 0.8549019608, green: 0.8862745098, blue: 0.9725490196, alpha: 1).cgColor, #colorLiteral(red: 0.8392156863, green: 0.6431372549, blue: 0.6431372549, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 0.7)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            wallpaperButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            wallpaperButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            wallpaperButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            wallpaperButton.heightAnchor.constraint(equalToConstant: 50),
            
            pixelPalsButton.topAnchor.constraint(equalTo: wallpaperButton.bottomAnchor, constant: 10),
            pixelPalsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pixelPalsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            pixelPalsButton.heightAnchor.constraint(equalToConstant: 50),
            pixelPalsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
