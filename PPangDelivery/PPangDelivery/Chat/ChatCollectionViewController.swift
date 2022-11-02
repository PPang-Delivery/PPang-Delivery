//
//  ChatCollectionViewController.swift
//  messenger
//
//  Created by 마석우 on 2022/10/29.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol NavigationDelegate: NSObject {
    func didTappedBackButton()
}

class ChatCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var delegate: NavigationDelegate?
    
    var destinationUid: String?
    
    var chatRoomUid: String?
    let messageInputBar = MessageInputView()
    let uid = FirebaseAuth.Auth.auth().currentUser?.uid
    
    var messages = [ChatModel.Comment]()
    var textArray = [String]()
    
    private let chatCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = .box
        //        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        
        //        collectionView.becomeFirstResponder()n
        return collectionView
    }()
    
    
    var height: CGFloat = 0.0
    
    var participantId: String?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.textLabel.text = message.message
        setupChatCell(cell: cell, message: message)
        
        if message.message.count >  0 {
            cell.containerViewWidthAnchor?.constant = measuredFrameHeightForEachMessage(message: message.message).width + 32
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30), height: 200)
    }
    
    private func measuredFrameHeightForEachMessage(message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func setupChatCell(cell: ChatMessageCell, message: ChatModel.Comment) {
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else {
            print("uid error")
            return
        }
        if message.uid == uid{
            cell.containerView.backgroundColor = .sma
            cell.textLabel.textColor = UIColor.white
            cell.containerViewRightAnchor?.isActive = true
            cell.containerViewLeftAnchor?.isActive = false
        } else {
            cell.containerView.backgroundColor = UIColor.lightGray
            cell.textLabel.textColor = UIColor.black
            cell.containerViewRightAnchor?.isActive = false
            cell.containerViewLeftAnchor?.isActive = true
        }
    }
    
    //    @objc
    //    func chatCollectionViewTapped() {
    //        chatTextField.resignFirstResponder()
    //    }
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageInputBar.delegate = self
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        chatCollectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: "chatCell")
        
        chatCollectionView.translatesAutoresizingMaskIntoConstraints = false
        chatCollectionView.alwaysBounceVertical = true
        style()
        layout()
        let layout = chatCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize.width = view.frame.width
        chatCollectionView.alwaysBounceVertical = true
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        delegate?.didTappedBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkChatRoom() { results in
            switch results {
            case .success(let success):
                print(success)
            case .failure(let error):
                print("error")
                if error as! DataManager.DataError == DataManager.DataError.notExistChatRoom {
                    self.createRoom(text: "")
                }
            }
        }
        if self.messages.count > 0 {
            let index = IndexPath(row: self.messages.count == 0 ? 0 : self.messages.count - 1, section: 0)
            self.chatCollectionView.scrollToItem(at: index, at: .bottom, animated: false)
        }
    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        subscribeToKeyboardNotifications()
    //    }
    //
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //        unsubscribeFromKeyboardNotifications()
    //    }
    
    
    
    private func layout() {
        view.addSubview(chatCollectionView)
        view.addSubview(messageInputBar)
        
        
        messageInputBar.backgroundColor = .sma
        NSLayoutConstraint.activate([
            messageInputBar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: messageInputBar.trailingAnchor, multiplier: 0),
            messageInputBar.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1)
        ])
        
        view.backgroundColor = .sma
        NSLayoutConstraint.activate([
            chatCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chatCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            messageInputBar.topAnchor.constraint(equalToSystemSpacingBelow: chatCollectionView.bottomAnchor, multiplier: 1)
            
        ])
    }
    
    func createRoom(text: String) {
        let roomInfo: Dictionary<String, Any> = [
            "users": [uid: true, destinationUid: true],
            "destinationUid": self.destinationUid
        ]
        print("create room = \(chatRoomUid)")
        if let chatUid = chatRoomUid {
            let value: Dictionary<String, Any> = [
                "uid": uid,
                "message": text,
                "timestamp": ServerValue.timestamp()
            ]
            DataManager.shared.dataRef.child("chatrooms").child(chatUid).child("comments").childByAutoId().setValue(value)
        } else {
            self.messageInputBar.button.isEnabled = false
            DataManager.shared.dataRef.child("chatrooms").childByAutoId().setValue(roomInfo) { error, ref in
                guard error == nil else {
                    return
                }
                self.checkChatRoom { results in
                    switch results {
                    case .success(let success):
                        print(success)
                        self.chatCollectionView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func checkChatRoom(completion: ((Result<String, Error>) -> Void)?) {
        print("checkoroom")
        DataManager.shared.dataRef.child("chatrooms").queryOrdered(byChild: "users/\(uid!)").queryEqual(toValue: true).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot != nil else {
                return
            }
            if let data = snapshot.value as? [String: Any] {
                print(data)
                for (key, value) in data {
                    if  let chatData = value as? [String: Any] {
                        if let dstUid = chatData["destinationUid"] as? String {
                            if dstUid == self.destinationUid || self.uid == dstUid {
                                self.chatRoomUid = key
                                print("success get key")
                                self.messageInputBar.button.isEnabled = true
                                self.getMessage()
                                completion?(.success("success"))
                            }
                        }
                    }
                    print("chatroomUid = \(self.chatRoomUid)")
                }
                if self.chatRoomUid == nil {
                    completion?(.failure(DataManager.DataError.notExistChatRoom))
                }
            } else {
                completion?(.failure(DataManager.DataError.notExistChatRoom))
            }
        })
    }
    
    @objc func didTappedBackButton() {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
    func getComment(data: [String: Any]) {
        for (_, value) in data {
            if let comments = value as? [String: Any] {
                //                print("get comment")
                if let message = comments["message"] as? String, let uid = comments["uid"] as? String, let timestamp = comments["timestamp"] as? Int {
                    let comment = ChatModel.Comment(uid: uid, message: message, timestamp: timestamp)
                    self.messages.append(comment)
                }
            }
        }
        self.messages = messages.sorted(by: {
            $0.timestamp < $1.timestamp
        })
    }
    func getMessage() {
        guard let chatRoomUid = self.chatRoomUid else {
            print("failed to load messages")
            return
        }
        DataManager.shared.dataRef.child("chatrooms").child(chatRoomUid).child("comments").observe(DataEventType.value, with: { (snapshot) in
            self.messages.removeAll()
            if let value = snapshot.value as? [String: Any] {
                self.getComment(data: value)
                DispatchQueue.main.async {
                    self.chatCollectionView.reloadData()
                    DispatchQueue.main.async {
                        if self.messages.count > 0 {
                            let index = IndexPath(row: self.messages.count - 1, section: 0)
                            self.chatCollectionView.scrollToItem(at: index, at: .bottom, animated: false)
                        }
                    }
                }
            }
        })
    }
}

extension ChatCollectionViewController {
    
    func style() {
        view.backgroundColor = .black
        
        messageInputBar.backgroundColor = .white
        //        chatView.layer.cornerRadius = 15
        
    }
}

extension ChatCollectionViewController: MessageInputViewDelegate {
    func didTappedButton(textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        createRoom(text: text)
        //        messages.append(text)
//        if messages.count > 0 {
//            let index = IndexPath(row: messages.count - 1, section: 0)
//            chatCollectionView.scrollToItem(at: index, at: .bottom, animated: false)
//        }
    }
    
    func messageInputTextChanged(textView: UITextView, isIncreased: Bool) {
//        let rect = chatCollectionView.layer.visibleRect
//        view.layoutIfNeeded()
//        let layoutRect = chatCollectionView.layer.visibleRect
//        
//        if isIncreased {
//            chatCollectionView.scrollRectToVisible(layoutRect, animated: false)
//        } else {
//            chatCollectionView.scrollRectToVisible(rect, animated: false)
//        }
    }
}
