//
//  UIViewController.swift
//  PPangDelivery
//
//  Created by 유정현 on 2022/10/27.
//

import UIKit
import CoreLocation

// MARK: - Extension

extension PopUpViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if userInputText.text == textViewPlaceHolder {
            userInputText.text = nil
            userInputText.textColor = .black
        }
    }
    func PopUpViewController(_ textView: UITextView) {
        if userInputText.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            userInputText.text = textViewPlaceHolder
            userInputText.textColor = .lightGray
        }
    }
}

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
                   leftActionTitle: String? = "취소",
                   rightActionTitle: String = "확인",
                   location: CLLocationCoordinate2D) {
//                   leftActionCompletion: (() -> Void)? = nil,
//                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(messageText: message, location: location)
        showPopUp(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle
//                  leftActionCompletion: leftActionCompletion,
//                  rightActionCompletion: rightActionCompletion
        )
    }
    
    func showPopUp(contentView: UIView,
                   leftActionTitle: String? = "취소",
                   rightActionTitle: String = "확인")
//                   leftActionCompletion: (() -> Void)? = nil,
//                   rightActionCompletion: (() -> Void)? = nil)
    {
        let popUpViewController = PopUpViewController(contentView: contentView)
        
        showPopUp(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle
//                  leftActionCompletion: leftActionCompletion,
//                  rightActionCompletion: rightActionCompletion
        )
    }
     func showPopUp(popUpViewController: PopUpViewController,
                           leftActionTitle: String?,
                    rightActionTitle: String) {
//                           leftActionCompletion: (() -> Void)?,
//                           rightActionCompletion: (() -> Void)?) {
        popUpViewController.addLeftAction(title: leftActionTitle,
                                              titleColor: .systemGray,
                                              backgroundColor: .secondarySystemBackground)
//            popUpViewController.dismiss(animated: false, completion: leftActionCompletion)
        
        popUpViewController.addRightAction(title: rightActionTitle,
                                              titleColor: .white,
                                              backgroundColor: .blue)
//            popUpViewController.dismiss(animated: false, completion: rightActionCompletion)
        present(popUpViewController, animated: false, completion: nil)
    }
}
