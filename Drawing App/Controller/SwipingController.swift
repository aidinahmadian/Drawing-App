//
//  SwipingController.swift
//  Test
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

//MARK: - Setup Swiping View Controller

import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Retrieve Data
    
    let pages = [
        Page(imageName: "11", headerText: "SketchBook for Everybody!", bodyText: "At Autodesk, we believe creativity starts with an idea. From quick conceptual sketches to fully finished artwork, sketching is at the heart of the creative process."),
        Page(imageName: "12", headerText: "SketchBook for Everybody!", bodyText: "At Autodesk, we believe creativity starts with an idea. From quick conceptual sketches to fully finished artwork, sketching is at the heart of the creative process."),
        Page(imageName: "13", headerText: "SketchBook for Everybody!", bodyText: "At Autodesk, we believe creativity starts with an idea. From quick conceptual sketches to fully finished artwork, sketching is at the heart of the creative process."),
        Page(imageName: "11", headerText: "SketchBook for Everybody!", bodyText: "At Autodesk, we believe creativity starts with an idea. From quick conceptual sketches to fully finished artwork, sketching is at the heart of the creative process."),
        Page(imageName: "12", headerText: "SketchBook for Everybody!", bodyText: "At Autodesk, we believe creativity starts with an idea. From quick conceptual sketches to fully finished artwork, sketching is at the heart of the creative process."),
        Page(imageName: "13", headerText: "SketchBook for Everybody!", bodyText: "At Autodesk, we believe creativity starts with an idea. From quick conceptual sketches to fully finished artwork, sketching is at the heart of the creative process.")
    ]
    
    //MARK: - Setup SwipingController Buttons/Functions

    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(#colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
     let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SKIP", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSkip() {
        print("Skip Button pressed")
        let homeViewController = CustomTabBarController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.5710545182, green: 0.2737172544, blue: 0.9993438125, alpha: 1)
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    //MARK: - Setup BottomControls

    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        bottomControlsStackView.backgroundColor = .systemBackground
        
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        
    }
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
        if let layout: UICollectionViewFlowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        setupBottomControls()
        setupViews()
        setupConstraints()
        
        collectionView?.backgroundColor = .systemBackground
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.isPagingEnabled = true
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isHidden = true
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupView/Constraints Functions
    
    //Views
    func setupViews() {
        view.addSubview(skipButton)
    }
    
    //Constraints
    
    func setupConstraints() {
        skipButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20).isActive = true
        skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
