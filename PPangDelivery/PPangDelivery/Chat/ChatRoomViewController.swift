//
//  ChatRoomViewController.swift
//  PPangDelivery
//
//  Created by 지상률 on 2022/10/21.
//

import Foundation
import UIKit

class ChatRoomViewController: UIViewController, ChatMassegeDelegate {
  
    let chatView = subView()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatView.delegate = self
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        
        chatView.backgroundColor = .black
//        chatView.layer.cornerRadius = 15
        view.addSubview(chatView)
        view.addSubview(label)
    
        NSLayoutConstraint.activate([
            chatView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: chatView.trailingAnchor, multiplier: 0),
//            chatView.heightAnchor.constraint(equalToConstant: 50),
            chatView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func didTappedButton(textView: UITextView) {
        label.text = textView.text
    }
}
