//
//  MoreInfoVC.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/22/24.
//

import UIKit
import SafariServices

// ViewController responsible for displaying more information and handling related actions
class MoreInfoVC: UIViewController {
    
    // Custom view that contains UI elements for the more info screen
    private let moreInfoView = MoreInfoView()
    
    // MARK: - View Lifecycle
    
    // Load the custom view when the view controller's view is requested
    override func loadView() {
        view = moreInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up button actions
        moreInfoView.celebrationBT.addTarget(self, action: #selector(startRainingEmojis), for: .touchUpInside)
        moreInfoView.otherProjectsBT.addTarget(self, action: #selector(otherProjcsAction), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    
    // Starts an animation where emojis "rain" down the screen
    @objc private func startRainingEmojis() {
        generateHapticFeedback(.success)
        
        let emojiArray = ["🥳", "🎈", "✨", "🌟", "💫", "🎊", "🍾", "🎉", "👻", "❤️‍🔥", "🤩", "🤑"]
        
        // Generate and animate 50 emoji labels falling down the screen
        for _ in 0..<50 {
            let emojiLabel = UILabel()
            emojiLabel.text = emojiArray.randomElement()
            emojiLabel.font = UIFont.systemFont(ofSize: 30)
            emojiLabel.frame = CGRect(x: CGFloat.random(in: 0...view.frame.width), y: -50, width: 50, height: 50)
            view.addSubview(emojiLabel)
            
            UIView.animate(withDuration: 1.5, delay: Double.random(in: 0...0.8), options: [.curveEaseIn], animations: {
                emojiLabel.frame.origin.y = self.view.frame.height + 50
            }, completion: { _ in
                emojiLabel.removeFromSuperview()
            })
        }
    }
    
    // Opens a Safari view controller to display the provided URL
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        
        // Present the Safari view controller from the topmost view controller
        if let topController = UIApplication.shared.topMostViewController() {
            topController.present(safariVC, animated: true, completion: nil)
        } else {
            print("Unable to find the top view controller")
        }
    }
    
    // Opens a Safari view controller to show other projects (GitHub page)
    @objc func otherProjcsAction() {
        showSafariVC(for: "https://github.com/aidinahmadian")
    }
}

// MARK: - UIApplication Extension

// Extension to find the topmost view controller in the application
extension UIApplication {
    func topMostViewController() -> UIViewController? {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        var topController: UIViewController? = window.rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        
        return topController
    }
}
