//
//  ChatMessageCell.swift
//  practiceWithoutStoryBoard
//
//  Created by 지상률 on 2022/10/25.
//

import Foundation
import UIKit

class ChatMessageCell: UICollectionViewCell {
    var containerView = UIView()
    var textLabel = UILabel()
    
    var containerViewWidthAnchor: NSLayoutConstraint?
    var containerViewRightAnchor: NSLayoutConstraint?
    var containerViewLeftAnchor: NSLayoutConstraint?
    var containerViewHeightAnchor: NSLayoutConstraint?
    var textLabelHeightAnchor: NSLayoutConstraint?
    
    
    func setUITraits() {
        containerView.layer.cornerRadius = 4
        
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
    }
    
    func setAnchor() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        containerViewLeftAnchor = containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4)
        containerViewRightAnchor = containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        containerViewWidthAnchor = containerView.widthAnchor.constraint(equalToConstant: 200)
        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: frame.height)
        containerViewWidthAnchor?.isActive = true
        containerViewHeightAnchor?.isActive = true
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        textLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4).isActive = true
        textLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        textLabelHeightAnchor = textLabel.heightAnchor.constraint(equalToConstant: frame.height)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        contentView.addSubview(textLabel)
        setAnchor()
        setUITraits()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func measuredFrameHeightForEachMessage(message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context:  nil)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        let height = measuredFrameHeightForEachMessage(message: textLabel.text!).height + 20
        var newFrame = layoutAttributes.frame
        newFrame.size.width = CGFloat(ceilf(Float(size.width)))
        newFrame.size.height = height
        containerViewHeightAnchor?.constant = height
        textLabelHeightAnchor?.constant = height
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
