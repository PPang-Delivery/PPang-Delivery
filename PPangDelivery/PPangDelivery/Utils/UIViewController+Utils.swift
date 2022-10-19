//
//  UIViewController+Utils.swift
//  PPangDelivery
//
//  Created by 빵딜 on 2022/10/01.
//

import Foundation
import UIKit

// MARK: - 사용하고 싶은 ViewController에 사용
/*
#if DEBUG
import SwiftUI
extension UIViewController {
	private struct Preview: UIViewControllerRepresentable {
			let viewController: UIViewController

			func makeUIViewController(context: Context) -> UIViewController {
				return viewController
			}

			func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
			}
		}

		func toPreview() -> some View {
			Preview(viewController: self)
		}
}

import SwiftUI

struct VCPreView:PreviewProvider {
	static var previews: some View {
		ProfileViewController().toPreview()
	}
}
#endif
*/

extension UIViewController {
    func setTabBarImage(imageName: String, title: String) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        let barItem = UITabBarItem(title: title, image: image, tag: 0)

        tabBarItem = barItem
    }
}
