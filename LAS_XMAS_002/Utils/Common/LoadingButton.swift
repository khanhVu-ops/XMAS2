//
//  LoadingButton.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 16/10/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class LoadingButton: UIButton {
    var activityIndicator: UIActivityIndicatorView!
    private let stackView = UIStackView()
    private let label = UILabel()
    private var buttonTitle: String?
    var activityTitle: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

}

// MARK: - Setups
private extension LoadingButton {
    func setupUI() {
        buttonTitle = title(for: .normal)
        label.text = titleLabel?.text
        label.font = titleLabel?.font
        label.textColor = titleLabel?.textColor
        label.isUserInteractionEnabled = true
        titleLabel?.text = nil
        if #available(iOS 13.0, *) {
            self.activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            self.activityIndicator = UIActivityIndicatorView()
            self.activityIndicator?.style = .gray
        }
        self.activityIndicator.color = .gray
        self.activityIndicator.hidesWhenStopped = true
        
//        self.addSubview(self.activityIndicator)
                
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(label)
        
        stackView.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
            make.top.bottom.leading.trailing.equalToSuperview().inset(8)
        }
        stackView.isHidden = true
    }
}

// MARK: - Public
extension LoadingButton {
    func setLabelTitle(title: String, textColor: UIColor?, font: UIFont?) {
        label.text = title
        label.textColor = textColor
        label.font = font
    }
    
    func show() {
        DispatchQueue.main.async {
            self.stackView.isHidden = false
            self.setTitle(nil, for: .normal)
            self.label.text = self.activityTitle
//            UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
            self.activityIndicator.startAnimating()
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.stackView.isHidden = true
//            UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
            self.setTitle(self.buttonTitle, for: .normal)
        }
    }
    
    public var rx_progresshud_animating: AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()

            switch (event) {
            case .next(let value):
                if value {
                    self.show()
                } else {
                    self.hide()
                }
            case .error( _):
                self.hide()
            case .completed:
                self.hide()
            }
        }
    }
}
