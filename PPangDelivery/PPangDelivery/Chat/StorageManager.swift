//
//  StorageManager.swift
//  messenger
//
//  Created by 마석우 on 2022/10/19.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        storage.child("images/\(fileName)").putData(data) { metadata, error in
            guard error == nil else {
                print("faiiled")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            print("upload pcitu")
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("failed to get download url")
                    completion(.failure(StorageError.failedToDownload))
                    return
                }
                
                let urlString = url.absoluteString
                print(urlString)
                completion(.success("urlString"))
            }
        }
    }
    
    enum StorageError: Error {
        case failedToUpload
        case failedToDownload
    }
    
//    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
//        let ref = storage.child(path)
//        guard let url = URL(string: path) else {
//            completion(.failure(StorageError.failedToDownload))
//            return
//        }
//        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
//            guard let data = data, error == nil else {
//                
//            }
//            
//        })
//        ref.downloadURL { url, error in
//            guard let url = url else {
//                completion(.failure(StorageError.failedToDownload))
//                return
//            }
//            
//            completion(.success(url))
//        }
//    }
}
