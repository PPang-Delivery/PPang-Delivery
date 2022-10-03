//
//  UIViewController+Utils.swift
//  PPUMPPAI
//
//  Created by 마석우 on 2022/10/01.
//

import Foundation
import UIKit

extension UIViewController {
    func setStatusBar() {
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithTransparentBackground() // to hide Navigation Bar Line also
//        navBarAppearance.backgroundColor = appColor
//        UINavigationBar.appearance().standardAppearance = navBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        guard let statusSize = (UIApplication.shared.delegate as! AppDelegate).window?.windowScene?.statusBarManager?.statusBarFrame else {
            return
        }
        
        let style: UIBlurEffect.Style
        let statusBar = UIView(frame: statusSize)
        statusBar.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        statusBar.insertSubview(blurView, at: 0)
        blurView.heightAnchor.constraint(equalTo: statusBar.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: statusBar.widthAnchor).isActive = true
        
//        statusBar.backgroundColor = appColor
        
        view.addSubview(statusBar)
    }
    
    func setTabBarImage(imageName: String, title: String) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        let barItem = UITabBarItem(title: title, image: image, tag: 0)

        tabBarItem = barItem
    }
}
