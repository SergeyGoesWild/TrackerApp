//
//  OnboardingScreen.swift
//  Tracker
//
//  Created by Sergey Telnov on 23/12/2024.
//

import Foundation
import UIKit

class OnboardingScreen: UIViewController {
    private var pageViewController: UIPageViewController!
    private var pages: [UIViewController] = []
    private let customPageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page1 = OnboardingPage(textTitle: "Отслеживайте только то, что хотите",
                                   image: UIImage(named: "Onboarding01") ?? UIImage())
        let page2 = OnboardingPage(textTitle: "Даже если это не литры воды и йога",
                                   image: UIImage(named: "Onboarding02") ?? UIImage())
        pages = [page1, page2]
        
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.setViewControllers(
            [pages[0]],
            direction: .forward,
            animated: true,
            completion: nil
        )
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        setupPageControl()
    }
    
    private func setupPageControl() {
        customPageControl.numberOfPages = pages.count
        customPageControl.currentPage = 0
        customPageControl.currentPageIndicatorTintColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        customPageControl.pageIndicatorTintColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.30)
        customPageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customPageControl)
        
        NSLayoutConstraint.activate([
            customPageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -140),
            customPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customPageControl.heightAnchor.constraint(equalToConstant: 6),
        ])
    }
}

extension OnboardingScreen: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentIndex + 1]
    }
}

extension OnboardingScreen: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentVC) else { return }
        
        customPageControl.currentPage = currentIndex
    }
}
