//
//  WelcomeController.swift
//  Drawing App
//
//  Created by aidin ahmadian on 7/22/20.
//  Copyright © 2020 aidin ahmadian. All rights reserved.
//

import UIKit
import AVKit

// MARK: - WelcomeController
class WelcomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var onFinish: (() -> Void)?
    
    // Data model representing pages with video, header, and body text
    private let pages = [
        Page(videoName: "Video1.mp4", headerText: "\nEvery Masterpiece Begins with a Single Stroke!", bodyText: "We believe every masterpiece begins with a single stroke. Whether you're sketching freehand or utilizing our Symmetrix pattern tool, our app is designed to bring your creative ideas to life."),
        Page(videoName: "Video2.mp4", headerText: "\nInspiration Strikes Anytime!", bodyText: "We know that inspiration strikes at any moment. From initial doodles to polished designs, our app offers the tools you need, including the unique Symmetrix pattern feature, to create stunning artwork."),
        Page(videoName: "Video6.mp4", headerText: "\nCelebrate the Spark of Creativity!", bodyText: "We celebrate the spark of creativity. With options to draw freely or use our advanced Symmetrix pattern tool, artists can seamlessly transform their concepts into beautiful finished pieces."),
        Page(videoName: "Video7.mp4", headerText: "\nSupporting Your Artistic Journey!", bodyText: "Creativity is our core. Whether you're capturing a fleeting idea with a quick sketch or using our Symmetrix pattern view for detailed symmetrical designs, our app supports every step of your artistic journey.")
    ]
    
    // MARK: - UI Components
    
    // Previous button configuration
    private let previousButton: UIButton = {
        let button = createButton(title: "PREV")
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    // Next button configuration
    private let nextButton: UIButton = {
        let button = createButton(title: "NEXT")
        button.addTarget(self, action: #selector(handleNextOrSkip), for: .touchUpInside)
        return button
    }()
    
    // Skip button configuration
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6950279387)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        return button
    }()
    
    // Page control configuration
    private lazy var pageControl: UIPageControl = {
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
    
    // Custom initializer with a UICollectionViewFlowLayout
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    // Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyCornerRadius()
    }
    
    // MARK: - Setup Functions
    
    // Configures the collection view properties and layout
    private func configureCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.isPagingEnabled = true
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isHidden = true
    }
    
    // Adds skip button and bottom controls to the view
    private func setupViews() {
        view.addSubview(skipButton)
        setupBottomControls()
    }
    
    // Sets up constraints for UI elements
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 60),
            skipButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Sets up bottom control buttons (previous, next, and page control)
    private func setupBottomControls() {
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
            nextButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Button Actions
    
    // Handles the previous button tap
    @objc private func handlePrev() {
        generateHapticFeedback(.light)
        let nextIndex = max(pageControl.currentPage - 1, 0)
        scrollToPage(at: nextIndex)
    }
    
    // Handles the next button or skip button tap
    @objc private func handleNextOrSkip() {
        generateHapticFeedback(.light)
        if pageControl.currentPage == pages.count - 1 {
            handleSkip()
        } else {
            let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
            scrollToPage(at: nextIndex)
        }
    }
    
    // Handles the skip button tap and transitions to the home view controller
    @objc private func handleSkip() {
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
    
    // Handles page control value change
    @objc private func handlePageControlChange() {
        let currentPage = pageControl.currentPage
        scrollToPage(at: currentPage)
        generateHapticFeedback(.soft)
    }
    
    // MARK: - Helper Functions
    
    // Scrolls the collection view to a specific page
    private func scrollToPage(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = index
        updateNextButtonTitle(animated: true)
    }
    
    // Updates the next button title and appearance based on the current page
    private func updateNextButtonTitle(animated: Bool) {
        let isLastPage = pageControl.currentPage == pages.count - 1
        let title = isLastPage ? "SKIP" : "NEXT"
        let backgroundColor = isLastPage ? #colorLiteral(red: 0.2, green: 0.262745098, blue: 0.2196078431, alpha: 1) : #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6950279387)
        let titleColor: UIColor = isLastPage ? .white : .black
        
        if animated {
            UIView.transition(with: nextButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.nextButton.setTitle(title, for: .normal)
                self.nextButton.backgroundColor = backgroundColor
                self.nextButton.setTitleColor(titleColor, for: .normal)
            })
        } else {
            nextButton.setTitle(title, for: .normal)
            nextButton.backgroundColor = backgroundColor
            nextButton.setTitleColor(titleColor, for: .normal)
        }
        applyCornerRadius()
    }
    
    // Applies corner radius to specified buttons
    private func applyCornerRadius() {
        applyCornerRadius(to: nextButton, roundingCorners: [.topLeft, .bottomLeft, .bottomRight], radius: 20)
        applyCornerRadius(to: previousButton, roundingCorners: [.topRight, .bottomRight, .topLeft], radius: 20)
        applyCornerRadius(to: skipButton, roundingCorners: [.bottomLeft, .topLeft], radius: 20)
    }
    
    // Helper function to create a button with specific title
    private static func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.6950279387)
        return button
    }
    
    // Applies corner radius to a specified button with specific rounded corners and radius
    private func applyCornerRadius(to button: UIButton, roundingCorners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: button.bounds,
                                byRoundingCorners: roundingCorners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        button.layer.mask = mask
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    // Configures the size for collection view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeAreaInsets = view.safeAreaInsets
        let width = view.frame.width - safeAreaInsets.left - safeAreaInsets.right
        let height = view.frame.height - safeAreaInsets.top - safeAreaInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    // MARK: - UICollectionViewDataSource
    
    // Returns the number of items in the section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    // Configures the cell for each item
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }

    // MARK: - UIScrollViewDelegate
    
    // Handles the scroll view will end dragging event
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        updateNextButtonTitle(animated: true)
        generateHapticFeedback(.selection)
    }
    
    // MARK: - View Transition
    
    // Handles view transitions, especially for orientation changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            let currentPageIndex = self.pageControl.currentPage
            if currentPageIndex == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: currentPageIndex, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        })
    }
}
