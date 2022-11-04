//
//  DataManager.swift
//  messenger
//
//  Created by 마석우 on 2022/10/17.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth


extension Int {
    var toDayTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let date = Date(timeIntervalSince1970: Double(self / 1000))
        
        return dateFormatter.string(from: date)
    }
}
struct ChatAppUser {
    let email: String
    let uid: String
//    let profilePictureUrl: String
    
}

struct ChatModel {
    public var users: [String: Bool]
    public var comments: [String: Comment]
    
    struct Comment {
        public var uid: String
        public var message: String
        public var timestamp: Int
    }
}

final class DataManager {
    static let shared = DataManager()
    
    public let dataRef = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        let safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        return safeEmail
    }
    
    enum DataError: Error {
        case notExistChatRoom
        case failedToDownload
    }

}
extension DataManager {
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)  ) {
        let safeEmail = email.replacingOccurrences(of: ".", with: "-")
        print(safeEmail)
        dataRef.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard ((snapshot.value as? [String: Any]) != nil) else {
                completion(false)
                return
            }
            let value = snapshot.value as? [String: Any]
            print(value)
            completion(true)
        }
    }
    
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        let uid = FirebaseAuth.Auth.auth().currentUser?.uid
        
        dataRef.child("users").child(uid!).setValue([
            "userName" : "\(user.email)", "uid": user.uid
        ]) { error, _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            
        }
        completion(true)
    }
}

