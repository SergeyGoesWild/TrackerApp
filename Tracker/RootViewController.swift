//
//  ViewController.swift
//  Tracker
//
//  Created by Sergey Telnov on 04/11/2024.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMainScreen()
    }
    
    func loadMainScreen(){
        let tabBarController = UITabBarController()
        let border = CALayer()
        border.backgroundColor = UIColor(red: 0.70, green: 0.70, blue: 0.70, alpha: 1.00).cgColor
        border.frame = CGRect(x: 0, y: 0, width: tabBarController.tabBar.bounds.width, height: 1.0)
        tabBarController.tabBar.layer.addSublayer(border)
        
        let trackersViewController = TrackersVC()
        let trackersNavController = UINavigationController(rootViewController: trackersViewController)
        trackersNavController.isNavigationBarHidden = true
        trackersNavController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "TrackerTabIcon.png"), tag: 0)
        
        let statViewController = StatVC()
        let statNavController = UINavigationController(rootViewController: statViewController)
        statNavController.isNavigationBarHidden = true
        statNavController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "StatTabIcon.png"), tag: 1)
        
        tabBarController.viewControllers = [trackersNavController, statNavController]
        
        addChild(tabBarController)
        tabBarController.view.frame = view.bounds
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
    }
}

