//
//  MoreInfoVC.swift
//  Drawing App
//
//  Created by Aidin Ahmadian on 7/22/24.
//

import UIKit

class MoreInfoVC: UIViewController {
    
    private let moreInfoView = MoreInfoView()
    
    override func loadView() {
        view = moreInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreInfoView.wallpaperButton.addTarget(self, action: #selector(startRainingEmojis), for: .touchUpInside)
        moreInfoView.pixelPalsButton.addTarget(self, action: #selector(startRainingEmojis), for: .touchUpInside)
        moreInfoView.backToTutorialVC.addTarget(self, action: #selector(backToTutorialVCButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func backToTutorialVCButtonTapped() {
            let alert = UIAlertController(title: "Go Back to Tutorial Page?", message: "If you go back to the tutorial, any unsaved progress will be lost. Are you sure you want to continue?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in
                self.presentSwipingController()
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
        private func presentSwipingController() {
            let swipingController = SwipingController()
            
            swipingController.onFinish = {
                swipingController.dismiss(animated: true, completion: nil)
            }
            
            swipingController.modalTransitionStyle = .crossDissolve
            swipingController.modalPresentationStyle = .fullScreen
            present(swipingController, animated: true, completion: nil)
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
}
