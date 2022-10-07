//
//  Profile.swift
//  PPangDelivery
//
//  Created by 빵딜 on 2022/10/02.
//

import UIKit
import SnapKit
import Then
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController {
	
	let label = UILabel()
	
	var idTextField = UITextField()
	var passwordTextField = UITextField()
	var signInButton = UIButton()
	var signUpButton = UIButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
		layout()
	}
	
	func setup() {
		view.backgroundColor = .white
	}
	
	func layout() {
		let blackBox = UIView()
		let vContent = UIView()
		
		if let user = Auth.auth().currentUser {
			vContent.isHidden = true
			blackBox.isHidden = false
		} else {
			vContent.isHidden = false
			blackBox.isHidden = true
		}
		
		view.addSubview(blackBox)
		blackBox.then {
			$0.backgroundColor = .black
		}.snp.makeConstraints {
			$0.center.equalTo(view.safeAreaLayoutGuide)
			$0.width.height.equalTo(100)
		}
		
		view.addSubview(vContent)
		vContent.snp.makeConstraints {
			$0.center.equalTo(view.safeAreaLayoutGuide)
//				.offset(-100)
			$0.width.height.equalTo(200)
//			$0.left.equalTo(view.safeAreaLayoutGuide)
		}
		
		let stvCell = UIStackView()
		vContent.addSubview(stvCell)
		stvCell.then {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.axis = .vertical
			$0.distribution = .fill
			$0.alignment = .center
			$0.spacing = 10.0
		}.snp.makeConstraints {
			$0.left.right.centerY.equalToSuperview()
		}
		
		stvCell.addArrangedSubview(idTextField)
		idTextField.then {
			$0.placeholder = "ID"
		}.snp.makeConstraints {
			$0.top.equalTo(self.idTextField.snp.bottom).offset(10)
			$0.height.equalTo(40.0)
			$0.left.right.equalToSuperview()
		}
		
		stvCell.addArrangedSubview(passwordTextField)
		passwordTextField.then {
			$0.placeholder = "PASSWORD"
		}.snp.makeConstraints {
			$0.top.equalTo(self.idTextField.snp.bottom).offset(10)
			$0.height.equalTo(40.0)
			$0.left.right.equalToSuperview()
		}
		
		signInButton.addTarget(self, action: #selector(didTappedSignInButton(_:)), for: .touchUpInside)
		stvCell.addArrangedSubview(signInButton)
		signInButton.then {
			$0.setTitle("Sign In", for: .normal)
			$0.backgroundColor = UIColor.green
		}.snp.makeConstraints {
			$0.top.equalTo(self.passwordTextField.snp.bottom).offset(10)
			$0.height.equalTo(40.0)
			$0.left.right.equalToSuperview()
		}

		stvCell.addArrangedSubview(signUpButton)
		signUpButton.then {
			$0.setTitle("Sign Up", for: .normal)
			$0.backgroundColor = UIColor.blue
		}.snp.makeConstraints {
			$0.top.equalTo(self.signInButton.snp.bottom).offset(10)
			$0.height.equalTo(40.0)
			$0.left.right.equalToSuperview()
		}
		
		stvCell.addArrangedSubview(label)
		label.then {
			$0.text = "or"
			$0.textColor = .gray
			$0.textAlignment = .center
		}.snp.makeConstraints {
			$0.top.equalTo(self.signUpButton.snp.bottom).offset(10)
			$0.height.equalTo(40.0)
			$0.left.right.equalToSuperview()
		}
	}
	
	@objc
	private func didTappedSignInButton(_ sender: UIButton) {
		print("signinbutton press")
		Auth.auth().signIn(withEmail: idTextField.text!, password: passwordTextField.text!) { (user, error) in
			if user != nil {
				print("login success")
			} else {
				print("login failed")
			}
		}
	}
}

