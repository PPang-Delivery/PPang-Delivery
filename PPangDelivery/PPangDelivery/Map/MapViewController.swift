//
//  MapViewController.swift
//  PPangDelivery
//
//  Created by 빵딜 on 2022/10/02.
//

import UIKit
import Foundation
import CoreLocation

import NMapsMap
import SnapKit
import Then

class MapViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewCameraDelegate {

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
            $0.height.equalTo(100)
            $0.center.equalTo(view.center)
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
        //        let orderTogeterMarker = NMFMarker()
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(CLLocation(latitude: currentCameraPosition.lat,
                                                   longitude: currentCameraPosition.lng),
                                        preferredLocale: locale) { placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last
            else { return }
            
            let ppangAddress = address.description.components(separatedBy: ", ").map{String($0)}
            self.showPopUp(message: ppangAddress[1])
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

class PopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return members.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return members[row]
    }
    
    private var messageText: String?
    private var attributedMessageText: NSAttributedString?
    private var contentView: UIView?
    private let members: [String] = ["2","3","4","5","6","7","8"]
    
    private lazy var containerView: UIView = {
        let view = UIView()
        // popup animation test
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
        view.spacing = 15.0
        view.alignment = .center
        
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 15.0
        view.distribution = .fillEqually
        
        return view
    }()
    
    private lazy var foodStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 5.0
        view.distribution = .fillProportionally
        
        return view
    }()
    private lazy var v1FoodStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5.0
        view.distribution = .fillProportionally
        
        return view
    }()
    private lazy var v2FoodStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5.0
        view.distribution = .fillProportionally
        
        return view
    }()
    private lazy var v3FoodStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5.0
        view.distribution = .fillProportionally
        
        return view
    }()
    private lazy var v4FoodStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5.0
        view.distribution = .fillProportionally
        
        return view
    }()
        
    private lazy var userInputText: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 10.0)
        textField.center = self.view.center
        textField.placeholder = "시키실 메뉴의 가게 이름과 추가로 요하는 정보를 기입해주세요"
        //        textField.text = "UITextField example"
        textField.borderStyle = UITextField.BorderStyle.line
        textField.textColor = UIColor.blue
        
        return textField
    }()
    
    private lazy var messageLabel: UILabel? = {
        guard messageText != nil || attributedMessageText != nil else { return nil }
        
        let label = UILabel()
        label.text = ("빵하실 위치 :  "+messageText!)
        label.font = .systemFont(ofSize: 10.0)
        label.textColor = .gray
        label.numberOfLines = 0
        
        if let attributedMessageText = attributedMessageText {
            label.attributedText = attributedMessageText
        }
        
        return label
    }()
    
    private lazy var dueTime: UIStackView = {
        let view = UIStackView()
        
        view.spacing = 5.0
        view.distribution = .fill
                
        return view
    }()
    
    lazy var numberOfMemberStackView: UIStackView = {
        let view = UIStackView()
        
        view.spacing = 5.0
        view.distribution = .fill
        
        return view
    }()
    
    convenience init(messageText: String? = nil,
                     attributedMessageText: NSAttributedString? = nil) {
        self.init()
        
        self.messageText = messageText
        self.attributedMessageText = attributedMessageText
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
        getNumberOfMember()
        getDueTime()
        makeFoodStack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundImage(backgroundColor.image(), for: .normal)
        
        button.setTitleColor(.gray, for: .disabled)
        button.setBackgroundImage(UIColor.gray.image(), for: .disabled)
        
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        
        button.addAction(for: .touchUpInside) { _ in
            completion?()
        }
        
        buttonStackView.addArrangedSubview(button)
    }
    
    public func getDueTime(){
        let label = UILabel()
        let datePicker = UIDatePicker()
        
        label.text = "몇시까지 모집할까요?"
        
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minimumDate = NSDate() as Date

        dueTime.addArrangedSubview(label)
        dueTime.addArrangedSubview(datePicker)
    }
    
    public func getNumberOfMember() {
        let label = UILabel()
        let picker = UIPickerView()
        
        label.text = "몇명에서 빵하실건가요?"
        label.textColor = .black

        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        
        numberOfMemberStackView.addArrangedSubview(label)
        numberOfMemberStackView.addArrangedSubview(picker)

    }
    public func makeFoodStack() {
        let stackFoodList = ["족발/보쌈", "찜/탕/찌개", "돈까스/회/일식", "피자", "치킨", "고기/구이", "야식", "양식", "중식", "아시안", "백반/죽/국수", "도시락", "분식", "카페/디저트", "패스트푸드", "채식"]
        let foodTitleLabel = UILabel()
        foodTitleLabel.text = "메뉴 종류를 선택 해 주세요"
        foodTitleLabel.textAlignment = .center
        foodTitleLabel.font = .systemFont(ofSize: 20.0)
        foodTitleLabel.textColor = .black
        foodTitleLabel.numberOfLines = 0
        foodTitleLabel.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        for (index, foodText) in stackFoodList.enumerated() {
            let button = UIButton()
            button.setImage(UIImage(named: "chicken"), for: .normal)
//            button.setImage(UIImage(named: foodText), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
//            button.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
            
            button.snp.makeConstraints { make in
                //                make.width.equalTo(containerView.snp.width).dividedBy(4)
                make.height.width.equalTo(66)
            }
            switch (index % 4) {
            case 0: v1FoodStackView.addArrangedSubview(button)
            case 1: v2FoodStackView.addArrangedSubview(button)
            case 2: v3FoodStackView.addArrangedSubview(button)
            case 3: v4FoodStackView.addArrangedSubview(button)
            default:
                break
            }
        }
        foodStackView.addArrangedSubview(foodTitleLabel)
        foodStackView.addArrangedSubview(v1FoodStackView)
        foodStackView.addArrangedSubview(v2FoodStackView)
        foodStackView.addArrangedSubview(v3FoodStackView)
        foodStackView.addArrangedSubview(v4FoodStackView)
        //button action code
        //view.itemButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
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
            if let messageLabel = messageLabel {
                containerStackView.addArrangedSubview(messageLabel)
                messageLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
            }
//            if let titleLabel = titleLabel {
//                containerStackView.addArrangedSubview(titleLabel)
//            }
            containerStackView.addArrangedSubview(foodStackView)
            containerStackView.addArrangedSubview(dueTime)
            containerStackView.addArrangedSubview(numberOfMemberStackView)
            containerStackView.addArrangedSubview(userInputText)
        }
        //        if let lastView = containerStackView.subviews.last {
        //            containerStackView.setCustomSpacing(24.0, after: lastView)
        //        }
        containerStackView.addArrangedSubview(buttonStackView)
    }
    
    private func makeConstraints() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).inset(25)
        }
        NSLayoutConstraint.activate([
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

extension UIColor {
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
    func showPopUp(message: String? = nil,
                   attributedMessage: NSAttributedString? = nil,
                   leftActionTitle: String? = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(messageText: message,
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
