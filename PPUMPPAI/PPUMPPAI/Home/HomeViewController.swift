//
//  HomeViewController.swift
//  PPUMPPAI
//
//  Created by 마석우 on 2022/10/02.
//

import UIKit

class HomeViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setup()
        layout()
    }
    
    func setup() {
        view.backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Home"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
    }
    
    func layout() {
        view.addSubview(label)
        
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
