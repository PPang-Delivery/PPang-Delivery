//
//  ConversationTableViewCell.swift
//  messenger
//
//  Created by 마석우 on 2022/10/20.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    static let identifier = "conversationTableViewCell"
    
    public var userImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = true
 
        return image
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(messageLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        userNameLabel.frame = CGRect(x: userImageView.right + 10, y: 10, width: contentView.width-20-userImageView.width, height: (contentView.height-20)/2)
        messageLabel.frame = CGRect(x: userImageView.right+10, y: userNameLabel.bottom+10, width: contentView.width-20, height: (contentView.height-20)/2)
    }
    
    public func configure(with model: ChatAppUser) {
        self.messageLabel.text = "hello"
        
        self.userNameLabel.text = model.email
//        let path = model.profileUrl
//        guard let url = URL(string: path) else {
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                guard error == nil, let data = data else {
//                    print("failed to load image")
//                    return
//                }
//                let image = UIImage(data: data)
//                self.userImageView.image = image
//            }
//        }.resume()
    }
}
