//
//  ViewController.swift
//  Tracker
//
//  Created by Sergey Telnov on 04/11/2024.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarController = UITabBarController()
        
        let trackersViewController = TrackersViewController()
        let trackersNavController = UINavigationController(rootViewController: trackersViewController)
        trackersNavController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "TrackerTabIcon.png"), tag: 0)
        
        let statViewController = StatViewController()
        let statNavController = UINavigationController(rootViewController: statViewController)
        statNavController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "StatTabIcon.png"), tag: 1)
        
        tabBarController.viewControllers = [trackersNavController, statNavController]
        view.addSubview(tabBarController.view)
    }
    
    
}

