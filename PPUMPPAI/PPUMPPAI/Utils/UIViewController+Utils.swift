//
//  UIViewController+Utils.swift
//  PPUMPPAI
//
//  Created by 마석우 on 2022/10/01.
//

import Foundation
import UIKit

extension UIViewController {
    func setTabBarImage(imageName: String, title: String) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        let barItem = UITabBarItem(title: title, image: image, tag: 0)

        tabBarItem = barItem
    }
}
