//
//  ViewController.swift
//  messenger
//
//  Created by 마석우 on 2022/10/16.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore
import JGProgressHUD

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
class ConversationsViewController: UIViewController, NavigationDelegate {
    
    let spinner = JGProgressHUD(style: .dark)
    
    private var users = [ChatAppUser]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.backgroundColor = .white
        table.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
        
        return table
    }()
    
    let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("place").getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("documents error")
                return
            }
            for document in snapshot.documents {
                print(document.data())
            }
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchConversations()
        startListeningForConversation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }

    private func startListeningForConversation() {
        guard let selfUid = Auth.auth().currentUser?.uid else {
            return
        }
        DataManager.shared.dataRef.child("users/\(selfUid)").observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String: Any] {
                self.users.removeAll()
                if let chatUsers = value["chatUsers"] as? [String: Any] {
                    for (_, value) in chatUsers {
                        print(value)
                        if let value = value as? [String: String] {
                            if let uid = value["uid"], let email = value["email"] {
                                let user = ChatAppUser(email: email, uid: uid)
                                self.users.append(user)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    private func fetchConversations() {
        tableView.isHidden = false
    }
}

extension ConversationsViewController: UITableViewDelegate {
    
}

extension ConversationsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        let model = users[indexPath.row]
        cell.configure(with: model)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = users[indexPath.row]
        let vc = ChatCollectionViewController()
        vc.destinationUid = model.uid
        self.tabBarController?.tabBar.isHidden = true
        vc.title = model.email
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        
//        present(nc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 
    }
    
    func didTappedBackButton() {
        self.tabBarController?.tabBar.isHidden = false
    }
}


//func didTappedPin() {
//    guard let selfUid = FirebaseAuth.Auth.auth().currentUser?.uid else {
//        return
//    }
//    let pinUid = "ehrkwehrjkwejr"
//    let pinEmail = "skjfndj@naver.com"
//    DataManager.shared.dataRef.child("users/\(selfUid)/chatUsers/\(pinUid)").setValue([
//        "email": pinEmail,
//        "uid": pinUid
//    ])
//    
//    DataManager.shared.dataRef.child("users/\(selfUid)").observeSingleEvent(of: .value) { snapshot in
//        guard let value = snapshot.value as? [String: Any] else {
//            return
//        }
//        if let chatUsers = value["chatUsers"] as? [String: Any] {
//
//            chatUsers.description.append(contentsOf: <#T##S#>)
//            for (_, value) in chatUsers {
//                print(value)
//                if let value = value as? [String: String] {
//                    if let uid = value["uid"], let email = value["email"] {
//                        let user = ChatAppUser(email: email, uid: uid)
//
//                    }
//                }
//            }
//        }
//    }

