//
//  ColorPickerViewController.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

// Protocol definition for the ColorPickerViewController delegate
protocol ColorPickerViewControllerDelegate: AnyObject {
    func colorPickerViewController(_ viewController: ColorPickerViewController, didSelectColor color: UIColor)
}

// Main view controller for color picking functionality
class ColorPickerViewController: UIViewController {
    
    // Delegate to handle color selection events
    weak var delegate: ColorPickerViewControllerDelegate?
    
    // Instance of a custom filter launcher
    let filterLaucher = FilterLauncher()
    
    // UI components
    private var gradientView: GradientView!
    private var buttonGradientLayer: CAGradientLayer!
    
    // Label to display color picker prompt
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
    
    // Label to display tap-to-copy hint
    private let tapToCopylabel: UILabel = {
        let label = UILabel()
        label.text = "(Tap to copy!)"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // Button to open the color picker
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
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup gradient background and UI components
        gradientView = GradientView(frame: self.view.bounds)
        gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(gradientView)
        
        setupViews()
        setupConstraints()
        setupGradientLayer()
        startGradientAnimation()
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tapToCopylabel.startBlink() // Start blinking animation for tap-to-copy label
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonGradientLayer.frame = colorPickerButton.bounds // Adjust gradient layer to button bounds
    }
    
    // MARK: - Setup Functions
    
    // Setup and layout the UI components
    private func setupViews() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.layer.masksToBounds = true
        
        let noiseView = NoiseView()
        noiseView.translatesAutoresizingMaskIntoConstraints = false
        noiseView.layer.cornerRadius = 10
        noiseView.layer.masksToBounds = true
        
        view.addSubview(blurEffectView)
        view.addSubview(noiseView)
        view.addSubview(colorPickerlabel)
        view.addSubview(tapToCopylabel)
        view.addSubview(colorPickerButton)
        
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
    
    // Setup Auto Layout constraints for UI components
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorPickerlabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            colorPickerlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPickerlabel.widthAnchor.constraint(equalToConstant: 250),
            colorPickerlabel.heightAnchor.constraint(equalToConstant: 60),
            
            tapToCopylabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapToCopylabel.topAnchor.constraint(equalTo: colorPickerlabel.bottomAnchor, constant: 10),
            
            colorPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPickerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            colorPickerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            colorPickerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            colorPickerButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    // Setup the gradient layer for the color picker button
    private func setupGradientLayer() {
        buttonGradientLayer = CAGradientLayer()
        buttonGradientLayer.frame = colorPickerButton.bounds
        buttonGradientLayer.colors = [
            #colorLiteral(red: 0.7275679111, green: 0.9335718155, blue: 0.9355692267, alpha: 1).cgColor,
            #colorLiteral(red: 0.9540683627, green: 0.8185382485, blue: 0.9542558789, alpha: 1).cgColor
        ]
        buttonGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        buttonGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        buttonGradientLayer.cornerRadius = 10
        colorPickerButton.layer.insertSublayer(buttonGradientLayer, at: 0)
    }
    
    // Start the gradient animation for the button
    private func startGradientAnimation() {
        let color1 = #colorLiteral(red: 0.9485061765, green: 0.8026962876, blue: 0.7942721248, alpha: 1).cgColor
        let color2 = #colorLiteral(red: 0.9406943321, green: 0.9392179847, blue: 0.7521005869, alpha: 1).cgColor
        
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.duration = 3.5
        gradientAnimation.toValue = [color1, color2]
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = Float.infinity
        
        buttonGradientLayer.add(gradientAnimation, forKey: "colorChange")
    }
    
    // Setup gesture recognizers for interactive elements
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
        colorPickerlabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Action Handlers
    
    // Handle the filter button tap event
    @objc private func didFilterBtnTapped() {
        filterLaucher.showFilter() // Display the filter options
    }
    
    // Handle the color picker button tap event
    @objc private func handleCP() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = .white
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // Handle the label tap event to copy the color HEX value
    @objc private func handleLabelTap() {
        generateHapticFeedback(.success)
        guard let labelText = colorPickerlabel.text else { return }
        
        let hexValue = labelText.replacingOccurrences(of: "#", with: "")
        
        UIPasteboard.general.string = hexValue
        let alert = UIAlertController(
            title: "Copied 📋",
            message: "HEX value copied to clipboard \n(\(hexValue))",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Update the gradient color and label when a new color is selected
    private func updateGradientColor(to color: UIColor) {
        gradientView.updateGradientColor(at: 0, to: color) // Change the first color in the gradient view
        colorPickerlabel.text = color.toHexString() // Update the label with HEX value
        colorPickerlabel.attributedText = NSAttributedString(
            string: color.toHexString(),
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        
        // Animate the gradient layer on the button
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.duration = 4.0
        gradientAnimation.toValue = [color.cgColor, UIColor.white.cgColor]
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = Float.infinity
        
        buttonGradientLayer.add(gradientAnimation, forKey: "colorChange")
    }
}

// MARK: - UIColorPickerViewControllerDelegate

// Extension to handle color picker events
extension ColorPickerViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        updateGradientColor(to: selectedColor)
        generateHapticFeedback(.selection)
        delegate?.colorPickerViewController(self, didSelectColor: selectedColor)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        updateGradientColor(to: selectedColor)
        generateHapticFeedback(.selection)
        delegate?.colorPickerViewController(self, didSelectColor: selectedColor)
    }
}
