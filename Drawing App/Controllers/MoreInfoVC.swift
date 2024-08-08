//
//  MoreInfoVC.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/22/24.
//

import UIKit
import SafariServices

class MoreInfoVC: UIViewController {
    
    private let moreInfoView = MoreInfoView()
    
    override func loadView() {
        view = moreInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreInfoView.celebrationBT.addTarget(self, action: #selector(startRainingEmojis), for: .touchUpInside)
        moreInfoView.otherProjectsBT.addTarget(self, action: #selector(otherProjcsAction), for: .touchUpInside)
    }
    
    @objc private func startRainingEmojis() {
        generateHapticFeedback(.success)
        let emojiArray = ["🥳", "🎈", "✨", "🌟", "💫", "🎊", "🍾", "🎉", "👻", "❤️‍🔥", "🤩", "🤑"]
        
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
    
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        
        if let topController = UIApplication.shared.topMostViewController() {
            topController.present(safariVC, animated: true, completion: nil)
        } else {
            print("Unable to find the top view controller")
        }
    }
    
    @objc func otherProjcsAction() {
        showSafariVC(for: "https://github.com/aidinahmadian")
    }
}

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
