//
//  SearchBar.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 19/10/2023.
//

import UIKit
import SnapKit

class SearchBar: UIView {
    private lazy var icSeachImage: UIImageView = {
        let imv = UIImageView()
//        imv.image = .ic_search_tf
        imv.contentMode = .scaleAspectFill
        return imv
    }()
    
    lazy var tfSearch: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        return tf
    }()
    
    private lazy var btnCancel: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.addTarget(self, action: #selector(btnCancelClick(_:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    private lazy var borderview: UIView = {
        let v = UIView()
        [icSeachImage, tfSearch].forEach { sub in
            v.addSubview(sub)
        }
        
        return v
    }()
    
    var clearButtonMode: UITextField.ViewMode = .never {
        didSet {
            tfSearch.clearButtonMode = clearButtonMode
        }
    }
    
    var isShowCancelWhileEditing = false
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpUI()
    }
    
    
    private func setUpUI() {
        [borderview, btnCancel].forEach { sub in
            addSubview(sub)
        }
        tfSearch.delegate = self
        
        borderview.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        icSeachImage.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        tfSearch.snp.makeConstraints { make in
            make.leading.equalTo(icSeachImage.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        btnCancel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(tfSearch.snp.trailing).offset(10)
        }
    }
    
    @objc private func btnCancelClick(_ sender: UIButton) {
        tfSearch.endEditing(true)
        hideCancelButton()
    }
    
    private func showCancelButton() {
        UIView.animate(withDuration: 0.2) {
            self.borderview.snp.updateConstraints({ make in
                make.trailing.equalToSuperview().offset(-70)
            })
            self.borderview.needsUpdateConstraints()
            self.btnCancel.isHidden = false
            self.layoutIfNeeded()
        }
    }
    
    private func hideCancelButton() {
        UIView.animate(withDuration: 0.2) {
            self.borderview.snp.updateConstraints({ make in
                make.trailing.equalToSuperview()
            })
            self.borderview.needsUpdateConstraints()
            self.btnCancel.isHidden = true
            self.layoutIfNeeded()
        }
    }
}

//MARK: - extension public
extension SearchBar {
    func configUI(iconSearch: UIImage?, placeHolder: String?, textFont: UIFont?,textColor: UIColor?, tintColor: UIColor?, btnColor: UIColor?, btnFont: UIFont?) {
        icSeachImage.image = iconSearch
        
        tfSearch.placeholder = placeHolder
        tfSearch.font = textFont
        tfSearch.textColor = textColor
        tfSearch.tintColor = tintColor

        btnCancel.setTitleColor(btnColor, for: .normal)
        btnCancel.titleLabel?.font = btnFont
    }
    
    func setLayoutSearchBar(radius: CGFloat, backgroundColor: UIColor?) {
        borderview.backgroundColor = backgroundColor
        borderview.setCornerRadius(radius)
    }
    
    func endEditSearchBar(_ force: Bool) {
        tfSearch.endEditing(force)
    }
}

// MARK: - extension UITextFieldDelegate
extension SearchBar: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if isShowCancelWhileEditing {
            showCancelButton()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isShowCancelWhileEditing {
            hideCancelButton()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}
