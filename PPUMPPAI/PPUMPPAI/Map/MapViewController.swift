//
//  MapViewController.swift
//  PPUMPPAI
//
//  Created by 마석우 on 2022/10/02.
//

import UIKit
import SnapKit
import NMapsMap
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
	//	lazy var mainVC = MainViewController()
	
	var naverMapView = NMFMapView()
	
	lazy var myLocation: UIButton = {
		let btn = UIButton()
		btn.setTitle("My Location", for: .normal)
		btn.backgroundColor = UIColor.red
		return btn
	}()
	
	lazy var orderTogether: UIButton = {
		let btn = UIButton()
		btn.setTitle("같이 먹어요 []", for: .normal)
		btn.backgroundColor = UIColor.blue
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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		layout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.locationManager.startUpdatingLocation()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.locationManager.stopUpdatingLocation()
	}
	
	func setup() {
		mapInit()
	}
	
	func layout() {
		naverMapView.addSubview(myLocation)
		myLocation.addTarget(self, action: #selector(didTappedCurrentLocation(_:)), for: .touchDown)
		myLocation.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide)
		}
		
		naverMapView.addSubview(orderTogether)
		orderTogether.addTarget(self, action: #selector(didTappedOrderTogether(_:)), for: .touchDown)
		orderTogether.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide)
			$0.right.equalTo(view.safeAreaLayoutGuide)
		}
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
	
	@objc
	private func didTappedCurrentLocation(_ sender: UIButton) {
		focusPurposeLocation(coordinate, 16.5)
	}
	
	@objc
	private func didTappedOrderTogether(_ sender: UIButton) {
		print("같이 먹어용 버튼 클릭됨")
	}
}
