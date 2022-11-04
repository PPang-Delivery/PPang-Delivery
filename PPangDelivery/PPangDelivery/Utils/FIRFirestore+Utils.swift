//
//  FIRFirestore+Utils.swift
//  PPangDelivery
//
//  Created by Chan on 2022/10/21.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

class Firestore_Utils: Firestore {
	func firebaseUpdateQuery(_ collection: String, _ field: String, _ updateData: [String:String]){
		let dbCollection = Firestore.firestore().collection(collection)
		
		dbCollection.whereField(field, isEqualTo: 0).getDocuments { (querySnapshot, err) in
			if err != nil {
				print("“Error”")
				return
			} else {
				for document in querySnapshot!.documents {
					print("\(document.documentID) => \(document.data())")
				}
			}
			for i in querySnapshot!.documents {
				DispatchQueue.main.async {
					i.reference.updateData(updateData)
				}
			}
		}
	}
}

class FirebaseService: NSObject {
    static let shared = FirebaseService()

    override init() {
         FirebaseApp.configure()
    }
}

