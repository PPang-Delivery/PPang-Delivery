//
//  MapViewController.swift
//  PPangDelivery
//
//  Created by 빵딜 on 2022/10/02.
//

import UIKit
import SnapKit
import NMapsMap
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewCameraDelegate {
    //	lazy var mainVC = MainViewController()
    
    var naverMapView = NMFMapView()
    
    var centerPin = NMFMarker()
    
    lazy var myLocationButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("My Location", for: .normal)
        btn.backgroundColor = UIColor.red
        return btn
    }()
    
    lazy var orderTogetherButton: UIButton = {
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
    var currentCameraPosition = NMGLatLng(lat: 37.488205, lng: 127.064789)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        markcenterPin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
    func markcenterPin() {
        centerPin.position = NMGLatLng(
            lat: coordinate.lat,
            lng: coordinate.lng
        )
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
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
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
    
    @objc
    private func didTappedCurrentLocation(_ sender: UIButton) {
        focusPurposeLocation(coordinate, 16.5)
    }
    
    @objc
    private func didTappedOrderTogether(_ sender: UIButton) {
        print("같이 먹어용 버튼 클릭됨")
        //        let orderTogeterMarker = NMFMarker()
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(CLLocation(latitude: currentCameraPosition.lat,
                                                   longitude: currentCameraPosition.lng),
                                        preferredLocale: locale) { placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last
            else { return }
            let ppangAddress = "\(address)".split(separator: ", ")
            print(address)
            self.showPopUp(message: String(ppangAddress[1]))
        }
    }
    //        orderTogeterMarker.iconTintColor = .red
    //        orderTogeterMarker.position = NMGLatLng(lat: currentCameraPosition.lat, lng: currentCameraPosition.lng)
    //        orderTogeterMarker.mapView = naverMapView
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




// MARK: - PPangTogetherPopup

class PopUpViewController: UIViewController {
    private var titleText: String?
    private var messageText: String?
    private var attributedMessageText: NSAttributedString?
    private var contentView: UIView?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        //        UIView.animate(withDuration: 0.3, delay: 10, options: [], animations: {
        //
        //                    view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        //                }, completion: nil)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 50.0
        view.alignment = .center
        
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 15.0
        view.distribution = .fillEqually
        
        return view
    }()
    
    private lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.text = titleText
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private lazy var messageLabel: UILabel? = {
        guard messageText != nil || attributedMessageText != nil else { return nil }
        
        let label = UILabel()
        label.text = messageText
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .gray
        label.numberOfLines = 0
        
        if let attributedMessageText = attributedMessageText {
            label.attributedText = attributedMessageText
        }
        
        return label
    }()
    
    convenience init(titleText: String? = nil,
                     messageText: String? = nil,
                     attributedMessageText: NSAttributedString? = nil) {
        self.init()
        
        self.titleText = titleText
        self.messageText = messageText
        self.attributedMessageText = attributedMessageText
        /// present 시 fullScreen (화면을 덮도록 설정) -> 설정 안하면 pageSheet 형태 (위가 좀 남아서 밑에 깔린 뷰가 보이는 형태)
        modalPresentationStyle = .overFullScreen
    }
    
    convenience init(contentView: UIView) {
        self.init()
        
        self.contentView = contentView
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addSubviews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    
    public func addActionToButton(title: String? = nil,
                                  titleColor: UIColor = .white,
                                  backgroundColor: UIColor = .blue,
                                  completion: (() -> Void)? = nil) {
        guard let title = title else { return }
        
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        
        // enable
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundImage(backgroundColor.image(), for: .normal)
        
        // disable
        button.setTitleColor(.gray, for: .disabled)
        button.setBackgroundImage(UIColor.gray.image(), for: .disabled)
        
        // layer
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        
        button.addAction(for: .touchUpInside) { _ in
            completion?()
        }
        
        buttonStackView.addArrangedSubview(button)
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(containerStackView)
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    private func addSubviews() {
        view.addSubview(containerStackView)
        
        if let contentView = contentView {
            containerStackView.addSubview(contentView)
        } else {
            if let titleLabel = titleLabel {
                containerStackView.addArrangedSubview(titleLabel)
            }
            
            if let messageLabel = messageLabel {
                containerStackView.addArrangedSubview(messageLabel)
            }
        }
        
        if let lastView = containerStackView.subviews.last {
            containerStackView.setCustomSpacing(24.0, after: lastView)
        }
        
        containerStackView.addArrangedSubview(buttonStackView)
    }
    
    private func makeConstraints() {
                containerView.translatesAutoresizingMaskIntoConstraints = false
                containerStackView.translatesAutoresizingMaskIntoConstraints = false
                buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
                NSLayoutConstraint.activate([
                    containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
                    containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
                    containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 32),
                    containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -32),
        
                    containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
                    containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
                    containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
                    containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
        
                    buttonStackView.heightAnchor.constraint(equalToConstant: 48),
                    buttonStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor)
                ])
    }
}

// MARK: - Extension
//import Contacts
//
//extension CLPlacemark {
//    var formattedAddress: String? {
//        guard let postalAddress = postalAddress else {
//            return nil
//        }
//        let formatter = CNPostalAddressFormatter()
//        return formatter.string(from: postalAddress)
//    }
//}

extension UIColor {
    /// Convert color to image
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIControl {
    public typealias UIControlTargetClosure = (UIControl) -> ()
    
    private class UIControlClosureWrapper: NSObject {
        let closure: UIControlTargetClosure
        init(_ closure: @escaping UIControlTargetClosure) {
            self.closure = closure
        }
    }
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIControlTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIControlClosureWrapper else { return nil }
            return closureWrapper.closure
            
        } set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIControlClosureWrapper(newValue),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    
    public func addAction(for event: UIControl.Event, closure: @escaping UIControlTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIControl.closureAction), for: event)
    }
    
}

extension UIViewController {
    func showPopUp(title: String = "빵해요",
                   message: String? = nil,
                   attributedMessage: NSAttributedString? = nil,
                   leftActionTitle: String? = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(titleText: title,
                                                      messageText: message,
                                                      attributedMessageText: attributedMessage)
        showPopUp(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }
    
    func showPopUp(contentView: UIView,
                   leftActionTitle: String? = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(contentView: contentView)
        
        showPopUp(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }
    
    private func showPopUp(popUpViewController: PopUpViewController,
                           leftActionTitle: String?,
                           rightActionTitle: String,
                           leftActionCompletion: (() -> Void)?,
                           rightActionCompletion: (() -> Void)?) {
        popUpViewController.addActionToButton(title: leftActionTitle,
                                              titleColor: .systemGray,
                                              backgroundColor: .secondarySystemBackground) {
            popUpViewController.dismiss(animated: false, completion: leftActionCompletion)
        }
        
        popUpViewController.addActionToButton(title: rightActionTitle,
                                              titleColor: .white,
                                              backgroundColor: .blue) {
            popUpViewController.dismiss(animated: false, completion: rightActionCompletion)
        }
        present(popUpViewController, animated: false, completion: nil)
    }
}

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
