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
import DLRadioButton

// MARK: - PPangTogetherPopup

class PopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var messageText: String?
    private var contentView: UIView?
    private let members: [String] = ["2","3","4","5","6","7","8"]
    let textViewPlaceHolder = "ex) 당당치킨 시켜먹어요"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        
        return view
    }()
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15.0
        $0.alignment = .fill
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
        $0.distribution = .fillEqually
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
    
    private lazy var numberOfMemberStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.distribution = .fill
        $0.snp.makeConstraints { make in
            make.height.equalTo(66)
        }
    }
        
    lazy var userInputText = UITextView().then {
        // text
        $0.text = textViewPlaceHolder
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 15.0)
        $0.textAlignment = NSTextAlignment.justified

        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        
        $0.returnKeyType = .done
        $0.isEditable = true
        
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        $0.contentInset = .zero
        $0.scrollIndicatorInsets = .zero

        $0.delegate = self
    }
    
    private lazy var messageLabel: UILabel? = {
        guard messageText != nil else {return nil}
        
        let label = UILabel()
        label.text = ("빵하실 위치 :  " + messageText!)
        label.font = .systemFont(ofSize: 10.0)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    convenience init(messageText: String? = nil) {
        self.init()
        
        self.messageText = messageText
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
//        let dateLabel = UILabel()
//        let dateFormatter = DateFormatter()
        let datePicker = UIDatePicker()
        
        label.text = "몇시까지 모집할까요?"
        
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minimumDate = NSDate() as Date
        
//        view.backgroundColor = .clear
//        view.addSubview(datePicker)
//        view.snp.makeConstraints { make in
//            make.right =
//        }
        
//        dateFormatter.dateFormat = "HH:mm"
//        dateLabel.backgroundColor = .red
//        dateLabel.text = dateFormatter.string(from: datePicker.date)

        
        dueTime.addArrangedSubview(label)
        dueTime.addArrangedSubview(datePicker)
    }
    
    public func getNumberOfMember() {
        let label = UILabel()
        let picker = UIPickerView()
        
        label.text = "몇명에서 빵하실건가요?"
        label.textColor = .black

        picker.delegate = self
        picker.dataSource = self
        
        numberOfMemberStackView.addArrangedSubview(label)
        numberOfMemberStackView.addArrangedSubview(picker)

    }
    public func makeFoodStack() {
        let stackFoodList = ["jokbo", "jjim", "sushi", "pizza", "chicken", "barbeque", "midnight", "western", "chinese", "asian", "korean", "lunchbox", "bunsik", "cafe", "fastfood", "vegetable"]
        let foodTitleLabel = UILabel()
        foodTitleLabel.text = "메뉴 종류를 선택 해 주세요"
        foodTitleLabel.textAlignment = .center
        foodTitleLabel.font = .systemFont(ofSize: 20.0)
        foodTitleLabel.textColor = .black
        foodTitleLabel.numberOfLines = 0
        foodTitleLabel.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        let RadioButtonGroup = DLRadioButton()
        RadioButtonGroup.layer.opacity = 0
        RadioButtonGroup.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        for (index, foodText) in stackFoodList.enumerated() {
            let foodButton = DLRadioButton()
            foodButton.icon = UIImage(named: foodText) ?? RadioButtonGroup.icon
//            foodButton.iconSelected = UIImage(named: "test") ?? RadioButtonGroup.iconSelected
//            button.setImage(UIImage(named: "chicken"), for: .normal)
//            button.imageView?.contentMode = .scaleAspectFit
            foodButton.snp.makeConstraints { make in
                make.height.width.equalTo(50)
            }
            RadioButtonGroup.otherButtons.append(foodButton)
            switch (index % 4) {
            case 0: v1FoodStackView.addArrangedSubview(foodButton)
            case 1: v2FoodStackView.addArrangedSubview(foodButton)
            case 2: v3FoodStackView.addArrangedSubview(foodButton)
            case 3: v4FoodStackView.addArrangedSubview(foodButton)
            default:
                break
            }
        }
        foodStackView.addArrangedSubview(foodTitleLabel)
        foodStackView.addArrangedSubview(RadioButtonGroup)
        foodStackView.addArrangedSubview(v1FoodStackView)
        foodStackView.addArrangedSubview(v2FoodStackView)
        foodStackView.addArrangedSubview(v3FoodStackView)
        foodStackView.addArrangedSubview(v4FoodStackView)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return members.count
    }
        
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        let pickerViewLabel = UILabel()
        pickerViewLabel.text = members[row]
        pickerViewLabel.textAlignment = .center
        
        return pickerViewLabel
    }

}
