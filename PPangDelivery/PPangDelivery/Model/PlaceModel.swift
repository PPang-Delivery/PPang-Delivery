//
//  PlaceModel.swift
//  PPangDelivery
//
//  Created by Chan on 2022/10/21.
//

import Foundation
import FirebaseFirestore

struct PlaceModel {
    var category : String
    var createdTime : Timestamp
    var dueTime : Timestamp
    var id : Int
    var location : GeoPoint
    var numberOfMember : Int
    var show : Bool
    var userInputData : String
}
