//
//  AppDelegate.swift
//  PPangDelivery
//
//  Created by 빵딜 on 2022/10/01.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import IQKeyboardManagerSwift

let appColor: UIColor = .appColor


@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
	
	public static var user: GIDGoogleUser!
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if let error = error {
			if(error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
				print("not signed in before or signed out")
			} else {
				print(error.localizedDescription)
			}
		}
		
		// singleton 객체 - user가 로그인을 하면, AppDelegate.user로 다른곳에서 사용 가능
		AppDelegate.user = user
		
		// 사용자 인증값 가져오기
		guard let authentication = user.authentication else { return }
		let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
		// Firebase Auth에 인증정보 등록하기
		Auth.auth().signIn(with: credential) { _, _ in
			print("auth Sign in")
			
		}
		
		return
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		return (GIDSignIn.sharedInstance()?.handle(url))!
	}
	
	var window: UIWindow?
	let mainVC = MainViewController()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.backgroundColor = .systemBackground
		
		//        mainVC.setStatusBar()
		window?.rootViewController = mainVC
		//        mainVC.selectedIndex = 1
		FirebaseApp.configure()
		
		GIDSignIn.sharedInstance()?.delegate = self
		GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
        
		return true
	}
}
