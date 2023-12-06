//
//  BaseViewController.swift
//  BaseRxswift_MVVM
//
//  Created by Khanh Vu on 27/09/2023.
//
import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

struct KeyboardData {
    let isShow: Bool
    let duration: TimeInterval
    let height: CGFloat
}

class BaseViewController: UIViewController {
    
    lazy var keyboardTrigger = BehaviorRelay<KeyboardData>(value: KeyboardData(isShow: false, duration: 0, height: 0))
    lazy var safeInset = UIWindow.keyWindow?.safeAreaInsets
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = .backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("===> go to ", self.nibName  ?? " vaix of")

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    deinit {
        print("<=== dismiss ", self.nibName ?? "Vai o")

    }
    
   
    
    func addFirstResponsder(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func addGestureDismissKeyboard(view: UIView) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

//MARK: keyboard Notification
extension BaseViewController {
    func addKeyboardHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeKeyboardHandler() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func keyboardWillChangeFrame(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self]
            (keyboardFrame, duration) in
            guard let self = self else {
                return
            }
            let keyboardHeight = self.view.bounds.height - keyboardFrame.origin.y
            print(keyboardHeight)
            let isShow = keyboardFrame.height > 0 ? true : false
            self.keyboardTrigger.accept(KeyboardData(isShow: isShow, duration: duration, height: keyboardHeight))
        }
    }
    
    private func animateWithKeyboard(
        notification: NSNotification,
        animations: ((_ keyboardFrame: CGRect, _ duration: TimeInterval) -> Void)?
    ) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double
        
        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!
        
        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue, duration)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }
        // Start the animation
        animator.startAnimation()
    }
}

//MARK: Navigation
extension BaseViewController {
    func push(_ vc: UIViewController, animation: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animation)
    }
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    func setRoot(_ vc: UIViewController) {
        self.navigationController?.viewControllers  = [vc]
    }
}

