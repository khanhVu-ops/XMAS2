//
//  BottomSheetViewControllers.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 15/10/2023.
//

import UIKit

class BottomSheetViewControllers: BaseViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var dimmedView: UIView!
    
    //MARK: - Property
    var animationInterval: TimeInterval = 0.3
    private var originCenter: CGPoint = .zero
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOriginPosition()
        addTapDimmedView()
        addPanGestureContentView()
        dimmedView.backgroundColor = .black.withAlphaComponent(0.5)
        view.backgroundColor = .clear
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSheet()
        

    }
    
    //MARK: - Private
    func setOriginPosition() {
        let originY = contentView.frame.origin.y
        print(contentView.frame.origin.y)
        let distance = view.bounds.height - originY
        
        
        contentView.transform = contentView.transform.concatenating(CGAffineTransform(translationX: 0, y: distance))
    }
    
    
    func addTapDimmedView() {
        let tapDismis = UITapGestureRecognizer(target: self, action: #selector(dimmedViewClick(_:)))
        dimmedView.addGestureRecognizer(tapDismis)
    }
    
    func addPanGestureContentView() {
        let panMove = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        contentView.addGestureRecognizer(panMove)
    }
    
    func showSheet() {
//        self.view.alpha = 1
//        self.contentView.alpha = 1
        
        UIView.animate(withDuration: animationInterval, delay: 0, options: [.curveEaseOut]) {
            self.contentView.transform = .identity
        }
    }
    
    func hideSheet(duration: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: animationInterval, delay: 0, options: [.curveEaseOut]) {
            //            self.view.alpha = 0
            self.setOriginPosition()
        } completion: { _ in
            self.dismiss(animated: false)
            completion?()
        }
    }
    
    func showKeyBoard(keyboardHeight: CGFloat, duration: TimeInterval) {
        let space = view.bounds.height - contentView.frame.maxY
        
        let move = keyboardHeight - space
        
        if move > 0 {
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut]) {
                self.contentView.transform = CGAffineTransform(translationX: 0, y: -move)
            }
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        let translate = gesture.translation(in: gestureView).y
        let velocity = gesture.velocity(in: gestureView).y
        let progress = translate / gestureView.bounds.height
        
        switch gesture.state {
        case .began:
            self.originCenter = gestureView.frame.origin
            print(gestureView.frame.origin.y)
        case .changed:
//            gestureView.c
                gestureView.transform = CGAffineTransform(translationX: 0, y: max(translate, 0))
            
//            print(progress)
        case .ended, .cancelled:
            if velocity > 300 {
                hideSheet()
            } else if progress > 0.5 {
                print(gestureView.frame.origin.y)
                hideSheet()
            } else {
                showSheet()
            }
            
        default:
            break
        }
    }
    
    @objc func dimmedViewClick(_ gesture: UITapGestureRecognizer) {
        
        hideSheet()
    }
}
