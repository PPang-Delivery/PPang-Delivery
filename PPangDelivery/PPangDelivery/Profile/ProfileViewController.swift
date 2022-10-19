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
import GoogleSignIn

class ProfileViewController: UIViewController, UITabBarControllerDelegate, UITextFieldDelegate {
	
	var idTextField = UITextField()
	var passwordTextField = UITextField()
	var signInButton = UIButton()
	var signUpButton = UIButton()
	let orOauthLabel = UILabel()
	var refreshButton = UIButton()
	var googleLoginButton = GIDSignInButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
		layout()
		
	}
	
	func setup() {
		view.backgroundColor = .white
		
	}
	
	func layout() {
		let logOutBox = UIView()
		let vContent = UIView()
		
		if let _ = Auth.auth().currentUser {
			vContent.isHidden = true
			logOutBox.isHidden = false
		} else {
			logOutBox.isHidden = true
			vContent.isHidden = false
		}
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		logOutBox.addGestureRecognizer(tapGesture)
		
		view.addSubview(logOutBox)
		logOutBox.then {
//			$0.backgroundColor = view.backgroundColor
			$0.backgroundColor = .black
		}.snp.makeConstraints {
			$0.center.equalTo(view.safeAreaLayoutGuide)
			$0.width.equalTo(70)
			$0.height.equalTo(30)
		}
		
		let logOutLabel = UILabel().then {
			$0.text = "LogOut"
			$0.textColor = .red
			$0.sizeToFit()
		}
		
		logOutBox.addSubview(logOutLabel)
		
		view.addSubview(vContent)
		vContent.then {
			$0.backgroundColor = .appColor
		}.snp.makeConstraints {
			$0.top.bottom.equalTo(view.safeAreaLayoutGuide)
			$0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
			$0.right.equalTo(view.safeAreaLayoutGuide).inset(20)
		}
		
		let stvCell = UIStackView()
		vContent.addSubview(stvCell)
		stvCell.then {
			$0.axis = .vertical
			$0.distribution = .fill
			$0.alignment = .center
			$0.spacing = 10.0
		}.snp.makeConstraints {
			$0.left.right.centerY.equalToSuperview()
		}
		
		stvCell.addArrangedSubview(idTextField)
		idTextField.then {
			$0.textColor = .black
			$0.backgroundColor = .yellow
			$0.autocapitalizationType = .none
			$0.keyboardType = .emailAddress
			$0.textContentType = .emailAddress
			$0.placeholder = "ID"
		}.snp.makeConstraints {
			$0.top.equalTo(self.idTextField.snp.bottom).offset(10)
			$0.height.equalTo(40.0)
			$0.left.right.equalToSuperview()
		}
		
		stvCell.addArrangedSubview(passwordTextField)
		passwordTextField.then {
			$0.textColor = .black
			$0.backgroundColor = .yellow
			$0.autocapitalizationType = .none
			$0.textContentType = .password
			$0.isSecureTextEntry = true
			$0.keyboardType = .default
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
		refreshButton.addTarget(self, action: #selector(didTappedrefreshInButton(_:)), for: .touchUpInside)
		stvCell.addArrangedSubview(refreshButton)
		refreshButton.then {
			$0.setTitle("refresh", for: .normal)
		}.snp.makeConstraints {
			$0.top.equalTo(self.signUpButton.snp.bottom).offset(10)
			$0.height.equalTo(40.0)
			$0.left.right.equalToSuperview()
		}
		
//		stvCell.addArrangedSubview(orOauthLabel)
//		orOauthLabel.then {
//			$0.text = "or"
//			$0.textColor = .gray
//			$0.textAlignment = .center
//		}.snp.makeConstraints {
//			$0.top.equalTo(self.signUpButton.snp.bottom).offset(10)
//			$0.height.equalTo(40.0)
//			$0.left.right.equalToSuperview()
//		}
		
		GIDSignIn.sharedInstance()?.restorePreviousSignIn() // 자동로그인
		GIDSignIn.sharedInstance()?.presentingViewController = self
		stvCell.addArrangedSubview(googleLoginButton)
		googleLoginButton.then {
			$0.backgroundColor = .black
		}.snp.makeConstraints {
//			$0.top.equalTo(self.orOauthLabel.snp.bottom).offset(10)
			$0.top.equalTo(self.refreshButton.snp.bottom).offset(10)
			$0.height.equalTo(40.0)
			$0.left.right.equalToSuperview()
		}
		
//
//		var googleLoginBtn = GIDSignInButton().snp.makeConstraints{
//
//				$0.top.equalTo(self.label.snp.bottom).offset(10)
//				$0.height.equalTo(40.0)
//				$0.left.right.equalToSuperview()
//		}
//
//		stvCell.addArrangedSubview(googleLoginBtn)
//
//		GIDSignIn.sharedInstance()?.presentingViewController = self // 로그인화면 불러오기

	}
	
	@objc
	private func didTappedrefreshInButton(_ sender: UIButton) {
		print("refresh press")
		self.viewDidLoad()
	}
	@objc
	private func didTappedSignInButton(_ sender: UIButton) {
		print("signinbutton press")
		Auth.auth().signIn(withEmail: idTextField.text!, password: passwordTextField.text!) { (user, error) in
			if user != nil {
				print("login success")
				self.viewDidLoad()
			} else {
				print("login failed")
				self.signInButton.titleLabel?.textColor = .red
			}
		}
	}
	
	@objc func handleTap(sender: UITapGestureRecognizer) {
		print("logout press")
		let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
			self.navigationController?.popToRootViewController(animated: true)
			self.viewDidLoad()
		} catch let signOutError as NSError {
			print("ERROR: signout \(signOutError.localizedDescription)")
		}
	}
	
}
