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
