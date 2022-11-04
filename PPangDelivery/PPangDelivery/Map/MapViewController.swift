//
//  MapViewController.swift
//  PPangDelivery
//
//  Created by 빵딜 on 2022/10/02.
//

import UIKit
import Foundation
import CoreLocation
import MapKit
import FirebaseAuth

import NMapsMap
import SnapKit
import Then
import FirebaseFirestoreSwift
import FirebaseFirestore

class MapViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewCameraDelegate, UISearchResultsUpdating {
        
    let db = FirebaseService()
    let orderTogetherMarker = NMFMarker()
    var naverMapView = NMFMapView()
    var centerPin = NMFMarker()
    var address = ""
    
    let searchController = UISearchController()
    
    let searchRequest = MKLocalSearch.Request()
    
    lazy var myLocationButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("My Location", for: .normal)
        btn.backgroundColor = UIColor.red
        return btn
    }()
    
    lazy var orderTogetherButton: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        return manager
    }()
    
    var coordinate = NMGLatLng(lat: 37.488205, lng: 127.064789)
    // MARK: - 개포 새롬관 NMGLatLng(lat: 37.488205, lng: 127.064789)
    var currentCameraPosition = NMGLatLng(lat: 37.488205, lng: 127.064789)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        markcenterPin()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .bookmark, state: .normal)
        navigationItem.searchController?.searchBar.showsCancelButton = false
        let dbCollection = Firestore.firestore().collection("place")
                var listho: [PlaceModel] = []
                
                dbCollection.addSnapshotListener { [self] snapshot, error in
                    guard let documents = snapshot?.documents else {
                        print("Error Firestore fetching document: \(String(describing: error))")
                        return
                    }
                    for i in documents {
                        if let model = try? i.data(as: PlaceModel.self) {
                            listho.append(model)
                        } else {
                            print("try errorrr")
                        }
                        
                    }
                    
                    
                    
        //            Firestore.firestore().collection("place").document(user.uid).getDocument { snapshot, error in
        //                guard let listho = try? snapshot?.data(as: User.self) else { return }
        //
        //                self.currentUser = userData
        //            }
                    
                    
        //            listho = documents.compactMap { doc -> PlaceModel? in
        //                do {
        //                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
        //                    let creditCard = try JSONDecoder().decode(PlaceModel.self, from: jsonData)
        //                    return creditCard
        //                } catch let error {
        //                    print("Error json parsing \(error)")
        //                    return nil
        //                }
        //            }
                    print(listho)
        //            for i in listho {
        //                print("ho")
        //                self.ho(i: i.location)
        //            }
        //            DispatchQueue.global(qos: .default).async {
                        // 백그라운드 스레드
                        for i in listho {
                            let marker = NMFMarker(position: NMGLatLng(lat: i.location.latitude,
                                                                       lng: i.location.longitude)
                            )

                            marker.captionText = i.category
                            marker.width = 30
                            marker.height = 30
                            marker.iconImage = NMFOverlayImage(image: UIImage(named: "jokbo")!)
        //                    marker.touchHandler = NMFOverlayTouchHandler {
        //
        //                    }
                            marker.touchHandler = {(overlay) -> Bool in
                                print("오버레이 터치됨")
                                return true
                            }
                            marker.mapView = self.naverMapView
                        }
        //            }
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
//    func dataSend(category: String, dueTime: Timestamp, numberOfMember: Int, userInputData: String) {
//        self.modelValue.category = category
//        self.modelValue.dueTime = dueTime
//        self.modelValue.numberOfMember = numberOfMember
//        self.modelValue.userInputData = userInputData
//    }
    
//    func sendCategory(category: String) {
//        modelValue.category = category
//    }
//
//    func sendDueTime(dueTiime: Timestamp) {
//        modelValue.dueTime = dueTiime
//    }
//
//    func sendNumberOfMember(numberOfMember: Int) {
//        modelValue.numberOfMember = numberOfMember
//    }
//
//    func sendUserInputData(userInputData: String) {
//        modelValue.userInputData = userInputData
//    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        address = text
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("ho")
    }
    
    func markcenterPin() {
        centerPin.position = NMGLatLng(
            lat: coordinate.lat,
            lng: coordinate.lng
        )
        centerPin.captionText = "여기서 빵해요"
        centerPin.mapView = naverMapView
    }
    
    func setup() {
        mapInit()
    }
    
    func layout() {
        naverMapView.addSubview(myLocationButton)
        
        myLocationButton.addTarget(self, action: #selector(didTappedCurrentLocation(_:)), for: .touchDown)
        myLocationButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        naverMapView.addSubview(orderTogetherButton)
        orderTogetherButton.addTarget(self, action: #selector(didTappedOrderTogether(_:)), for: .touchDown)
        orderTogetherButton.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(55)
            $0.bottom.equalTo(view.snp.centerY)
            $0.centerX.equalTo(view.snp.centerX)
        }
        naverMapView.addCameraDelegate(delegate: self)
        
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        print("카메라 이동끝")
        let cameraPosition = mapView.cameraPosition
        currentCameraPosition.lat = cameraPosition.target.lat
        currentCameraPosition.lng = cameraPosition.target.lng
        print(currentCameraPosition.lat, currentCameraPosition.lng)
        
        centerPin.position = NMGLatLng(lat: cameraPosition.target.lat, lng: cameraPosition.target.lng)

    }
    
    func mapInit() {
        naverMapView = NMFMapView(frame: view.frame)
        naverMapView.positionMode = .normal
        naverMapView.locationOverlay.anchor = CGPoint(x: 0.5, y: 0.5)
        naverMapView.locationOverlay.location = coordinate
        focusPurposeLocation(coordinate, 16)
        view.addSubview(naverMapView)
    }
    
    func focusPurposeLocation(_ coordinate: NMGLatLng, _ zoomSize: Double) {
        let focus = NMFCameraUpdate(scrollTo: coordinate, zoomTo: zoomSize)
        focus.animation = .easeIn
        focus.pivot = CGPoint(x: 0.5, y: 0.5)
        naverMapView.moveCamera(focus)
    }
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            DispatchQueue.main.async {
                print("restrict not deter")
                self.getLocationUsagePermission()
            }
        case .denied:
            print("GPS 권한 요청 거부됨")
            DispatchQueue.main.async {
                print("permission")
                self.getLocationUsagePermission()
            }
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위치 업데이트!")
            print("위도 : \(location.coordinate.latitude)")
            print("경도 : \(location.coordinate.longitude)")
            coordinate.lat = location.coordinate.latitude
            coordinate.lng = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error") // 위치 가져오기 실패
    }
    
//    let pushPlaceModel() -> Void) {
//        let tmp = PlaceModel(category: "chicken",
//                             createdTime: Timestamp(date: Date()),
//                             dueTime: Timestamp(date: Date()),
//                             uid: FirebaseAuth.Auth.auth().currentUser!.uid,
//                             location: GeoPoint(latitude: coordinate.lat, longitude: coordinate.lng),
//                             numberOfMember: 2,
//                             show: true,
//                             userInputData: "KFC")
//        modelValue.category = "chicken to pizza"
//        let dbcollection = Firestore.firestore().collection("place")
//        _ = try? dbcollection.addDocument(from: modelValue)
//
//    }

    @objc
    private func didTappedCurrentLocation(_ sender: UIButton) {
        focusPurposeLocation(coordinate, 16.5)
        searchRequest.naturalLanguageQuery = address
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [self] response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }

            for item in response.mapItems {
                print("강남역: ", item.placemark.coordinate.latitude, item.placemark.coordinate.longitude )
                self.focusPurposeLocation(NMGLatLng(lat: item.placemark.coordinate.latitude, lng: item.placemark.coordinate.longitude), 16)
            }
        }
    }

    
    @objc
    private func didTappedOrderTogether(_ sender: UIButton) {
//        let orderTogetherMarker = NMFMarker()
        let orderTogetherInfoWindow = NMFInfoWindow()
        let FoodDataSource = NMFInfoWindowDefaultTextSource.data()
        FoodDataSource.title = "KFC 시켜먹어요"
        orderTogetherInfoWindow.dataSource = FoodDataSource
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(CLLocation(latitude: currentCameraPosition.lat,
                                                   longitude: currentCameraPosition.lng),
                                        preferredLocale: locale) { placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last
            else { return }
            
            let ppangAddress = address.description.components(separatedBy: ", ").map{String($0)}
            self.showPopUp(message: ppangAddress[1], location: CLLocationCoordinate2D(latitude: self.currentCameraPosition.lat, longitude: self.currentCameraPosition.lng))
//            self.showPopUp(message: ppangAddress[1], leftActionTitle: "취소", rightActionTitle: "확인", rightActionCompletion:  { [self] in
//                modelValue.createdTime = Timestamp(date: Date())
//                modelValue.show = true
//                modelValue.uid = FirebaseAuth.Auth.auth().currentUser!.uid
//                modelValue.location = GeoPoint(latitude: self.currentCameraPosition.lat,
//                                                    longitude: self.currentCameraPosition.lng)
//                modelValue.category = cateory
//                let dbcollection = Firestore.firestore().collection("place")
//                _ = try? dbcollection.addDocument(from: modelValue)
//            })
        }
//        var ref: DocumentReference? = nil
//        do {
//            ref = Firestore.firestore().collection("place").document()
//            guard let ref = ref else {
//                print("Reference is not exist.")
//                return
//            }
//            ref.setData(tmp.dictionary) { err in
//                if let err = err {
//                    print("Firestore>> Error adding document: \(err)")
//                    return
//                }
//                print("Firestore>> Document added!!!!!\(ref.documentID)")
//            }
//        }
//        dbcollection.addDocument(data: tmp.asDictionary) { error in
//            if let error = error {
//                print("debug: \(error.localizedDescription)")
//                return
//            }
//        }
        //        guard let dictionary = tmp.asDictionary else {
        //            print("decode error")
        //            return
        //        }
        //        dbCollection.addDocument(data: ["createdTime":"123123", "ho1":"ha2"])
    }
//    func uploadPost(caption: String, ownerName: String, ownerUid: String) {
//        let data = ["caption": caption,
//                    "ownerName": ownerName,
//                    "ownerUid": ownerUid
//        ]
//
//        Firestore.firestore().collection("post").addDocument(data: data) { error in
//            if let error = error {
//                print("DEBUG: \(error.localizedDescription)")
//                return
//            }
//        }
//    }
}

//    func initMapDB() {
//        DispatchQueue.global(qos: .default).async {
//            // 백그라운드 스레드
//            var markers = [NMFMarker]()
//            for index in 1...1000 {
//                let marker = NMFMarker(position: NMGLatLng(lat: Double.random(in: 37.4...37.9),
//                                                           lng: Double.random(in: 126.8...127.1))
//                )
//                marker.captionText = String(index)
//                markers.append(marker)
//            }
//
//            DispatchQueue.main.async { [weak self] in
//                // 메인 스레드
//                for marker in markers {
//                    marker.mapView = self?.naverMapView
//                }
//            }
//        }
//    }


// MARK: - Snapkit Preview

//struct MapViewControllerPreViews: PreviewProvider {
//    static var previews: some View {
//        MapViewController().toPreview()
//    }
//}
//import SwiftUI
//
//#if DEBUG
//extension UIViewController {
//    private struct Preview: UIViewControllerRepresentable {
//        let viewController: UIViewController
//
//        func makeUIViewController(context: Context) -> UIViewController {
//            return viewController
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        }
//    }
//
//    func toPreview() -> some View {
//        Preview(viewController: self)
//    }
//}
//#endif
