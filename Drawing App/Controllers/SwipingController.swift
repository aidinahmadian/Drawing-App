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
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
        private let nextButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("NEXT", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.setTitleColor(UIColor.black, for: .normal)
            button.addTarget(self, action: #selector(handleNextOrSkip), for: .touchUpInside)
            return button
        }()
    
        private let skipButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
            button.tintColor = .gray
            button.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6950279387)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 25
            button.layer.opacity = 0.9
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 5, height: 5)
            button.layer.shadowRadius = 10
            button.layer.shadowOpacity = 0.3
            button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
            return button
        }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
        //pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.8352941176, green: 0.7254901961, blue: 0.5254901961, alpha: 1)
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
        collectionView?.backgroundColor = .systemBackground
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.isPagingEnabled = true
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyCornerRadiusToNextButton()
    }
    
    // MARK: - Setup Functions
    
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
    
    func setupViews() {
        view.addSubview(skipButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            skipButton.widthAnchor.constraint(equalToConstant: 50),
            skipButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateNextButtonTitle(animated: true)
    }
    
    @objc private func handleNextOrSkip() {
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
    }
    
    // MARK: - Helper Functions
    
    private func updateNextButtonTitle(animated: Bool) {
        if pageControl.currentPage == pages.count - 1 {
            if animated {
                UIView.transition(with: nextButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    self.nextButton.setTitle("SKIP", for: .normal)
                    self.nextButton.backgroundColor = #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1)
                    self.nextButton.setTitleColor(.white, for: .normal)
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
                    self.nextButton.backgroundColor = .clear
                    self.nextButton.setTitleColor(UIColor.black, for: .normal)
                })
            } else {
                nextButton.setTitle("NEXT", for: .normal)
                nextButton.backgroundColor = .clear
                nextButton.setTitleColor(UIColor.black, for: .normal)
            }
        }
        applyCornerRadiusToNextButton()
    }
    
    private func applyCornerRadiusToNextButton() {
        let path = UIBezierPath(roundedRect: nextButton.bounds,
                                byRoundingCorners: [.topLeft, .bottomLeft],
                                cornerRadii: CGSize(width: 20, height: 20))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        nextButton.layer.mask = mask
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
