//
//  AppDelegate.swift
//  PPUMPPAI
//
//  Created by 빵딜 on 2022/10/01.
//

import UIKit

let appColor: UIColor = .appColor
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let mainVC = MainViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
//        mainVC.setStatusBar()
        window?.rootViewController = mainVC
//        mainVC.selectedIndex = 1
        return true
    }

}
