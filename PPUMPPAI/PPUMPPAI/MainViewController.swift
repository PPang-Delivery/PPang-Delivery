//
//  MainViewController.swift
//  PPUMPPAI
//
//  Created by 빵딜 on 2022/10/01.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    
    let homeVC = HomeViewController()
    let mapVC = MapViewController()
    let chatVC = ChatViewController()
    let profileVC = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTabBar()

        homeVC.setTabBarImage(imageName: "house.fill", title: "Home")
        mapVC.setTabBarImage(imageName: "map.fill", title: "Map")
        chatVC.setTabBarImage(imageName: "message.fill", title: "Message")
        profileVC.setTabBarImage(imageName: "person.fill", title: "My")

        let nc1 = UINavigationController(rootViewController: homeVC)
        let nc2 = UINavigationController(rootViewController: mapVC)
        let nc3 = UINavigationController(rootViewController: chatVC)
        let nc4 = UINavigationController(rootViewController: profileVC)

        let navBarAppearance = UINavigationBarAppearance()

//        navBarAppearance.configureWithTransparentBackground()
//        navBarAppearance.configureWithOpaqueBackground()
//        navBarAppearance.backgroundColor = .black
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.appColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appColor]
        navBarAppearance.backgroundEffect = .init(style: .dark)
        
        nc1.navigationBar.standardAppearance = navBarAppearance
        nc1.navigationBar.scrollEdgeAppearance = navBarAppearance
        nc2.navigationBar.standardAppearance = navBarAppearance
        nc2.navigationBar.scrollEdgeAppearance = navBarAppearance
        nc3.navigationBar.standardAppearance = navBarAppearance
        nc3.navigationBar.scrollEdgeAppearance = navBarAppearance
        nc4.navigationBar.standardAppearance = navBarAppearance
        nc4.navigationBar.scrollEdgeAppearance = navBarAppearance
        
//        nc1.view.addSubview(makeBlurView(nc1.navigationBar.bounds))
//        nc2.navigationBar.insertSubview(makeBlurView(nc2.navigationBar.bounds), at: 0)
//        nc3.navigationBar.insertSubview(makeBlurView(nc3.navigationBar.bounds), at: 0)
//        nc4.navigationBar.insertSubview(makeBlurView(nc4.navigationBar.bounds), at: 0)
        
        nc1.navigationBar.topItem?.title = "Home"
//        nc1.navigationBar.prefersLargeTitles = true
        nc2.navigationBar.topItem?.title = "Map"
//        nc2.navigationBar.prefersLargeTitles = true
        nc3.navigationBar.topItem?.title = "Chat"
        nc3.navigationBar.prefersLargeTitles = true
        nc4.navigationBar.topItem?.title = "Profile"
        nc4.navigationBar.prefersLargeTitles = true

        nc1.navigationBar.tintColor = appColor
        nc2.navigationBar.tintColor = appColor
        nc3.navigationBar.tintColor = appColor
        nc4.navigationBar.tintColor = appColor
        
        viewControllers = [nc1, nc2, nc3, nc4]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundEffect = .init(style: .dark)
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = appColor
    }
    
}
