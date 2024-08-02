//
//  SwipingController.swift
//  Test
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var onFinish: (() -> Void)?
    
    // MARK: - Data
    
    let pages = [
        Page(imageName: "11", headerText: "\nSketchBook for Everybody!", bodyText: "At Autodesk, we believe creativity starts with an idea. From quick conceptual sketches to fully finished artwork, sketching is at the heart of the creative process."),
        Page(imageName: "12", headerText: "\nSketchBook for Everybody!", bodyText: "At Autodesk, we believe creativity starts with an idea. From quick conceptual sketches to fully finished artwork, sketching is at the heart of the creative process."),
        Page(imageName: "13", headerText: "\nSketchBook for Everybody!", bodyText: "At Autodesk, we believe creativity starts with an idea. From quick conceptual sketches to fully finished artwork, sketching is at the heart of the creative process."),
        Page(imageName: "11", headerText: "\nSketchBook for Everybody!", bodyText: "At Autodesk, we believe creativity starts with an idea. From quick conceptual sketches to fully finished artwork, sketching is at the heart of the creative process."),
    ]
    
    // MARK: - UI Components
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6950279387)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6950279387)
        button.addTarget(self, action: #selector(handleNextOrSkip), for: .touchUpInside)
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6950279387)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        return button
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pc.addTarget(self, action: #selector(handlePageControlChange), for: .valueChanged)
        return pc
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseIdentifier")
        if let layout: UICollectionViewFlowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        setupBottomControls()
        setupViews()
        setupConstraints()
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.isPagingEnabled = true
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyCornerRadius(to: nextButton, roundingCorners: [.topLeft, .bottomLeft, .bottomRight], radius: 20)
        applyCornerRadius(to: previousButton, roundingCorners: [.topRight, .bottomRight, .topLeft], radius: 20)
        applyCornerRadius(to: skipButton, roundingCorners: [.bottomLeft, .topLeft], radius: 20)
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.axis = .horizontal
        bottomControlsStackView.alignment = .center
        bottomControlsStackView.distribution = .equalCentering
        bottomControlsStackView.spacing = 20

        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            pageControl.heightAnchor.constraint(equalToConstant: 50),
            
            previousButton.heightAnchor.constraint(equalToConstant: 50),
            previousButton.widthAnchor.constraint(equalToConstant: 100),
            
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }

    func setupViews() {
        view.addSubview(skipButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 60),
            skipButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func handlePrev() {
        generateHapticFeedback(.light)
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateNextButtonTitle(animated: true)
    }
    
    @objc private func handleNextOrSkip() {
        generateHapticFeedback(.light)
        if pageControl.currentPage == pages.count - 1 {
            handleSkip()
        } else {
            let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
            let indexPath = IndexPath(item: nextIndex, section: 0)
            pageControl.currentPage = nextIndex
            collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            updateNextButtonTitle(animated: true)
        }
    }
    
    @objc func handleSkip() {
        let homeViewController = CustomTabBarController()
        generateHapticFeedback(.medium)
        
        guard let windowScene = view.window?.windowScene else { return }
        if let window = windowScene.windows.first {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = homeViewController
            }, completion: { _ in
                self.onFinish?()
            })
        }
    }
    
    @objc func handlePageControlChange() {
        let currentPage = pageControl.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateNextButtonTitle(animated: true)
        generateHapticFeedback(.soft)
    }
    
    // MARK: - Helper Functions
    
    private func updateNextButtonTitle(animated: Bool) {
        if pageControl.currentPage == pages.count - 1 {
            if animated {
                UIView.transition(with: nextButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    self.nextButton.setTitle("SKIP", for: .normal)
                    self.nextButton.backgroundColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
                    //self.previousButton.backgroundColor = #colorLiteral(red: 0.8720760747, green: 1, blue: 0.8688191583, alpha: 1)
                    self.nextButton.setTitleColor(.white, for: .normal)
                    //self.previousButton.setTitleColor(.black, for: .normal)
                })
            } else {
                nextButton.setTitle("SKIP", for: .normal)
                nextButton.backgroundColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
                nextButton.setTitleColor(.white, for: .normal)
            }
        } else {
            if animated {
                UIView.transition(with: nextButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    self.nextButton.setTitle("NEXT", for: .normal)
                    self.nextButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6950279387)
                    //self.previousButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6950279387)
                    self.nextButton.setTitleColor(UIColor.black, for: .normal)
                    //self.previousButton.setTitleColor(UIColor.white, for: .normal)
                })
            } else {
                nextButton.setTitle("NEXT", for: .normal)
                nextButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6950279387)
                nextButton.setTitleColor(UIColor.black, for: .normal)
            }
        }
        applyCornerRadius(to: nextButton, roundingCorners: [.topLeft, .bottomLeft, .bottomRight], radius: 20)
    }
    
    private func applyCornerRadius(to button: UIButton, roundingCorners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: button.bounds,
                                byRoundingCorners: roundingCorners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        button.layer.mask = mask
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeAreaInsets = view.safeAreaInsets
        let width = view.frame.width - safeAreaInsets.left - safeAreaInsets.right
        let height = view.frame.height - safeAreaInsets.top - safeAreaInsets.bottom
        return CGSize(width: width, height: height)
    }

    // MARK: - UIScrollViewDelegate
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        updateNextButtonTitle(animated: true)
        generateHapticFeedback(.soft)
    }
    
    // MARK: - View Transition
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }) { (_) in }
    }
}
