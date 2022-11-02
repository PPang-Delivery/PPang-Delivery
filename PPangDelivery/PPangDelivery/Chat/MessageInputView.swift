//
//  MessageInputView.swift
//  FirebaseTest
//
//  Created by 마석우 on 2022/10/14.
//

import UIKit

extension UIColor {
    static var sma = UIColor(named: "sma")
    static var box = UIColor(named: "box")
}
protocol MessageInputViewDelegate: NSObject {
    func didTappedButton(textView: UITextView)
    func messageInputTextChanged(textView: UITextView, isIncreased: Bool)
}

class MessageInputView: UIView {
    
    weak var delegate: MessageInputViewDelegate?
    
    let textBox = UITextView()
    
    let button = UIButton()
    let placeHolder = UILabel()
    
    var viewHeight: NSLayoutConstraint?
    var textBoxHeight: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        textBox.delegate = self

        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension MessageInputView {
    func style() {
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        textBox.translatesAutoresizingMaskIntoConstraints = false
        textBox.layer.shadowColor = UIColor.gray.cgColor;
        textBox.backgroundColor = .box
        textBox.textColor = .black
        textBox.font = UIFont.preferredFont(forTextStyle: .body)
        textBox.layer.cornerRadius = 21

        textBox.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 40)
        textBox.isScrollEnabled = false
        
        placeHolder.translatesAutoresizingMaskIntoConstraints = false
        placeHolder.isUserInteractionEnabled = false // placeholder를 터치했을 때 반응하지 않도록 설정, (텍스브뷰가 클릭되게끔)
        //        placeHolder.isEnabled = true
        placeHolder.text = "문자 메시지"
        placeHolder.textColor = .lightGray
        placeHolder.textAlignment = .left
        //        placeHolder.backgroundColor = .red
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(didTappedChatButton), for: .primaryActionTriggered)
        
    }
    
    func layout() {
        
        addSubview(textBox)
        addSubview(button)
        addSubview(placeHolder)

        viewHeight = heightAnchor.constraint(equalToConstant: 50) // 현재 view의 height constraint를 변수에 저장
        viewHeight?.isActive = true
        textBoxHeight = textBox.heightAnchor.constraint(equalToConstant: 150) //textBox의 height constraint를 변수에 저장
        textBoxHeight?.isActive = true
//
        NSLayoutConstraint.activate([
            textBox.widthAnchor.constraint(equalToConstant: 250),
            bottomAnchor.constraint(equalToSystemSpacingBelow: textBox.bottomAnchor, multiplier: 0.5),
            textBox.centerXAnchor.constraint(equalTo: centerXAnchor),

            textBox.trailingAnchor.constraint(equalToSystemSpacingAfter: button.trailingAnchor, multiplier: 0.5),
            textBox.bottomAnchor.constraint(equalToSystemSpacingBelow: button.bottomAnchor, multiplier: 0.5),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34),

            placeHolder.centerYAnchor.constraint(equalTo: textBox.centerYAnchor),
            placeHolder.leadingAnchor.constraint(equalToSystemSpacingAfter: textBox.leadingAnchor, multiplier: 1.9)

        ])
        
        textViewDidChange(textBox)
        button.isHidden = true
    }
    
    @objc func didTappedChatButton() {
        delegate?.didTappedButton(textView: textBox)
        textBox.endEditing(true)
        textViewDidChange(textBox)
    }
}

extension MessageInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolder.isHidden = false
        } else {
            placeHolder.isHidden = true
        }
        if !textView.text.isEmpty {
            button.isHidden = false
        } else {
            button.isHidden = true
        }
        let size = CGSize(width: 250, height: 100)
        let estimatedSize = textView.sizeThatFits(size) // textView의 알맞는 현재 사이즈를 받아온다. 입력된 text 수의 따라 사이즈가 달라지는 거 같다.
//        textView.constraints.forEach { (constraint) in
//            if constraint.firstAttribute == .height {
//                if estimatedSize.height < 150 {
//                    constraint.constant = estimatedSize.height
//                    viewHeight?.constant = estimatedSize.height + 8
//                    layoutIfNeeded()
//                    print(estimatedSize.height)
//                }
//            }
//        }
        if estimatedSize.height < 150, textBoxHeight?.constant != estimatedSize.height { // 만약 estimatedSize의 height가 150보다 작다면 view와 textBox의 height constraint를 estimatedSize.height로 변경해준다.
            let isNegative = textBoxHeight!.constant > estimatedSize.height ? true : false
            textBoxHeight?.constant = estimatedSize.height
            viewHeight?.constant = estimatedSize.height + 8
            delegate?.messageInputTextChanged(textView: textView, isIncreased: isNegative)
            layoutIfNeeded()
//            print(estimatedSize.height)
        }
        if estimatedSize.height > 150 {
            textBox.isScrollEnabled = true
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let text = textView.text, !text.isEmpty else {
            print("heello")
            return false
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
