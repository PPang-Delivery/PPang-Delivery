//
//  PopUpViewController.swift
//  PPangDelivery
//
//  Created by 유정현 on 2022/10/21.
//

import UIKit
import Foundation
import CoreLocation

import NMapsMap
import SnapKit
import Then

// MARK: - PPangTogetherPopup

class PopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var messageText: String?
    private var attributedMessageText: NSAttributedString?
    private var contentView: UIView?
    private let members: [String] = ["2","3","4","5","6","7","8"]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return members.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return members[row]
    }
        
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
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15.0
        $0.alignment = .center
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.spacing = 15.0
        $0.distribution = .fillEqually
    }
    
    private lazy var foodStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 5.0
        $0.distribution = .fillProportionally
    }
    
    private lazy var v1FoodStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5.0
        $0.distribution = .fillProportionally
    }
    private lazy var v2FoodStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5.0
        $0.distribution = .fillEqually
    }
    
    private lazy var v3FoodStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5.0
        $0.distribution = .fillEqually
    }
    
    private lazy var v4FoodStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5.0
        $0.distribution = .fillEqually
    }
    
    private lazy var dueTime = UIStackView().then {
        $0.spacing = 5.0
        $0.distribution = .fill
    }
    
    lazy var numberOfMemberStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.distribution = .fill
    }
    
    private lazy var userInputText = UITextField().then {
        $0.font = .systemFont(ofSize: 10.0)
        $0.center = self.view.center
        $0.placeholder = "시키실 메뉴의 가게 이름과 추가로 요하는 정보를 기입해주세요"
        $0.borderStyle = UITextField.BorderStyle.line
        $0.textColor = UIColor.blue
    }
    
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
            button.imageView?.contentMode = .scaleAspectFit
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
            containerStackView.addArrangedSubview(foodStackView)
            containerStackView.addArrangedSubview(dueTime)
            containerStackView.addArrangedSubview(numberOfMemberStackView)
            containerStackView.addArrangedSubview(userInputText)
        }
        containerStackView.addArrangedSubview(buttonStackView)
    }
    
    private func makeConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view).offset(25)
            make.trailing.equalTo(view).inset(25)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(containerView).inset(24)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(containerStackView.snp.width)
        }
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
