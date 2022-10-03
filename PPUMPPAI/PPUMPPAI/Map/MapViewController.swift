//
//  MapViewController.swift
//  PPUMPPAI
//
//  Created by 마석우 on 2022/10/02.
//

import UIKit

class MapViewController: UIViewController {
    
    let label = UILabel()
    let v = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
    
    func setup() {
        view.backgroundColor = .white
        v.backgroundColor = .red
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Map"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        
        v.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        view.addSubview(label)
        view.addSubview(v)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 10),

            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            v.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            v.widthAnchor.constraint(equalToConstant: 100),
            v.heightAnchor.constraint(equalToConstant: 100)
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
