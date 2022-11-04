//
//  PlaceModel.swift
//  PPangDelivery
//
//  Created by Chan on 2022/10/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PlaceModel: Codable{
    var category : String
    var createdTime : Timestamp
    var dueTime : Timestamp
    var uid : String
    var location : GeoPoint
    var numberOfMember : Int
    var show : Bool
    var userInputData : String
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}

//private protocol CodableTimestamp: Codable {
//    var seconds: Int64 { get }
//    var nanoseconds: Int32 { get }
//
//
//    init(seconds: Int64, nanoseconds: Int32)
//}

//private protocol CodableGeoPoint: Codable {
//    var latitude: Double { get }
//    var longitude: Double { get }
//
//    init(latitude: Double, longitude: Double)
//}
//
//extension CodableGeoPoint {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: GeoPointKeys.self)
//        let latitude = try container.decode(Double.self, forKey: .latitude)
//        let longitude = try container.decode(Double.self, forKey: .longitude)
//        self.init(latitude: latitude, longitude: longitude)
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: GeoPointKeys.self)
//        try container.encode(latitude, forKey: .latitude)
//        try container.encode(longitude, forKey: .longitude)
//    }
//}

//extension CodableTimestamp {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: TimestampKeys.self)
//        let seconds = try container.decode(Int64.self, forKey: .seconds)
//        let nanoseconds = try container.decode(Int32.self, forKey: .nanoseconds)
//        self.init(seconds: seconds, nanoseconds: nanoseconds)
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: TimestampKeys.self)
//        try container.encode(seconds, forKey: .seconds)
//        try container.encode(nanoseconds, forKey: .nanoseconds)
//    }
//}
//
//private enum TimestampKeys: String, CodingKey {
//    case seconds
//    case nanoseconds
//}

//private enum GeoPointKeys: String, CodingKey {
//    case latitude
//    case longitude
//}

//extension Timestamp: CodableTimestamp {}

//extension GeoPoint: CodableGeoPoint {}
