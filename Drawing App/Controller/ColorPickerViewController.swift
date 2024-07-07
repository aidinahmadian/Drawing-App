//
//  TestViewController.swift
//  Test
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit
import Combine

class ColorPickerViewController: UIViewController {
    
    private let colorPickerlabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Your Color"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.attributedText = NSAttributedString(
            string: "Choose Your Color",
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let tapToCopylabel: UILabel = {
        let label = UILabel()
        label.text = "(Tap to copy!)"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        //label.isUserInteractionEnabled = true
        return label
    }()
    
    private let colorPickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Color Picker", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleCP), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        
        return button
    }()
    
    private var gradientView: GradientView!
    private var cancellable: AnyCancellable?
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapToCopylabel.startBlink()
        gradientView = GradientView(frame: self.view.bounds)
        gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(gradientView)
        
        setupViews()
        setupConstraints()
        setupGradientLayer()
        startGradientAnimation()
        setupGestureRecognizers()
    }
    
    @objc private func handleCP() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = .white
        picker.delegate = self
        
        cancellable = picker.publisher(for: \.selectedColor)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] color in
                self?.updateGradientColor(to: color)
            }
        
        present(picker, animated: true, completion: nil)
    }
    
    private func setupViews() {
        // Create a blur effect
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.layer.masksToBounds = true
        
        // Create a noise effect view
        let noiseView = NoiseView()
        noiseView.translatesAutoresizingMaskIntoConstraints = false
        noiseView.layer.cornerRadius = 10
        noiseView.layer.masksToBounds = true
        
        view.addSubview(blurEffectView)
        view.addSubview(noiseView)
        view.addSubview(colorPickerlabel)
        view.addSubview(tapToCopylabel)
        view.addSubview(colorPickerButton)
        
        // Set constraints for the blur effect view to match the label's frame
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: colorPickerlabel.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: colorPickerlabel.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: colorPickerlabel.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: colorPickerlabel.trailingAnchor),
            noiseView.topAnchor.constraint(equalTo: colorPickerlabel.topAnchor),
            noiseView.bottomAnchor.constraint(equalTo: colorPickerlabel.bottomAnchor),
            noiseView.leadingAnchor.constraint(equalTo: colorPickerlabel.leadingAnchor),
            noiseView.trailingAnchor.constraint(equalTo: colorPickerlabel.trailingAnchor)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorPickerlabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            colorPickerlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPickerlabel.widthAnchor.constraint(equalToConstant: 250),
            colorPickerlabel.heightAnchor.constraint(equalToConstant: 60),
            
            tapToCopylabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapToCopylabel.topAnchor.constraint(equalTo: colorPickerlabel.bottomAnchor, constant: 10),
            
            //colorPickerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            colorPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPickerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            colorPickerButton.widthAnchor.constraint(equalToConstant: 250),
            colorPickerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupGradientLayer() {
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = colorPickerButton.bounds
        gradientLayer.colors = [
            #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1).cgColor,
            #colorLiteral(red: 1, green: 0.9725490196, blue: 0.9529411765, alpha: 1).cgColor
        ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.cornerRadius = 10
            
        colorPickerButton.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        func startGradientAnimation() {
            let color1 = #colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1).cgColor
            let color2 = #colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 1, alpha: 1).cgColor
            
            let gradientAnimation = CABasicAnimation(keyPath: "colors")
            gradientAnimation.duration = 4.0
            gradientAnimation.toValue = [color2, color1]
            gradientAnimation.fillMode = .forwards
            gradientAnimation.isRemovedOnCompletion = false
            gradientAnimation.autoreverses = true
            gradientAnimation.repeatCount = Float.infinity
            
            gradientLayer.add(gradientAnimation, forKey: "colorChange")
        }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            gradientLayer.frame = colorPickerButton.bounds
        }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
        colorPickerlabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleLabelTap() {
        guard let labelText = colorPickerlabel.text else { return }
        
        UIPasteboard.general.string = labelText
        let alert = UIAlertController(
            title: "Copied",
            message: "HEX value copied to clipboard \n(\(labelText))",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func updateGradientColor(to color: UIColor) {
        gradientView.updateGradientColor(at: 0, to: color) // Change the first color
        colorPickerlabel.text = color.toHexString() // Update the label with HEX value
        colorPickerlabel.attributedText = NSAttributedString(
            string: color.toHexString(),
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
    }
    
}

extension ColorPickerViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        updateGradientColor(to: viewController.selectedColor)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.cancellable?.cancel()
            print(self?.cancellable == nil)
        }
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        updateGradientColor(to: viewController.selectedColor)
    }
}
