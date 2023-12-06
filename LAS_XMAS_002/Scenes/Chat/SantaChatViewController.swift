//
//  VideoNoteViewController.swift
//  LAS_MOVIE_010
//
//  Created by Khanh Vu on 12/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class SantaChatViewController: BaseViewController {

    //MARK: - Outlet
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    // Input view
    @IBOutlet weak var bottomChatView: NSLayoutConstraint!
    @IBOutlet weak var heightInputView: NSLayoutConstraint!
    @IBOutlet weak var borderChatView: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    //MARK: - Property
    var viewModel: SantaChatViewModel
    let disposeBag = DisposeBag()
    let maxTextViewHeight = 120.0
    let minTextViewHeight = 40.0
    let currentChatViewHeight = BehaviorRelay<CGFloat>(value: 40)
    var scrollToBottomTrigger = PublishSubject<Void>()
    
    //MARK: - Life Cycle
    
    init(viewModel: SantaChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        bindEvent()
        bindViewModel()
        
    }
    
    deinit {
        removeKeyboardHandler()
    }

    //MARK: - Private
    private func setUpUI() {
        chatTableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        chatTableView.delegate = self
        chatTableView.register(MessageItemCell.nibClass, forCellReuseIdentifier: MessageItemCell.cellId)
        chatTableView.register(MessageSenderItemCell.nibClass, forCellReuseIdentifier: MessageSenderItemCell.cellId)
        chatTableView.estimatedRowHeight = 50.0
        placeHolderLabel.textColor = .blue.withAlphaComponent(0.37)
        borderChatView.backgroundColor = UIColor(hex: "#F5F5F5")
        chatView.backgroundColor = UIColor(hex: "#F5F5F5")
        placeHolderLabel.isHidden = true

        chatTextView.isEditable = true
        chatTextView.isSelectable = true
        let txtGesture = UITapGestureRecognizer(target: self, action: #selector(tapTxtTypeHere))
        chatTextView.addGestureRecognizer(txtGesture)
        
        addKeyboardHandler()
        addGestureDismissKeyboard(view: chatTableView)
        
    }
    
    private func bindViewModel() {
        let input = SantaChatViewModel.Input(loadTrigger: Driver.just(()),
                                             sendTrigger: sendButton.rx.impactTap.asDriver(),
                                             backTrigger: backButton.rx.impactTap.asDriver(),
                                             scrollToBottomTrigger: scrollToBottomTrigger.asDriverComplete())
        
        let output = viewModel.transform(input)
        
        output.error.asDriver()
            .drive(onNext: { error in
                if let appError = error as? AppError {
                    Toast.show(appError.message)
                } else {
                    Toast.show(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        output.loading.asObservable()
            .bind(to: ActivityIndicatorUtility().rx_progresshud_animating)
            .disposed(by: disposeBag)
        
        output.loadTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.backTrigger
            .drive()
            .disposed(by: disposeBag)
        
        output.sendTrigger
            .drive( onNext: { [weak self] in
//                self?.scrollToBottom()
            })
            .disposed(by: disposeBag)
        
        output.scrollToBottomTrigger
            .drive( onNext: { [weak self] in
                self?.scrollToBottom()
            })
            .disposed(by: disposeBag)
        
        viewModel.listMessages
            .bind(to: chatTableView.rx.items) { tableView, index, item in
                if item.isSender {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MessageSenderItemCell.cellId, for: IndexPath(row: index, section: 0)) as! MessageSenderItemCell
                    cell.configure(item: item)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: MessageItemCell.cellId, for: IndexPath(row: index, section: 0)) as! MessageItemCell
                    cell.configure(item: item)
                    return cell
                }
                    
            }
            .disposed(by: disposeBag)
        
        viewModel.listMessages
            .subscribe( onNext: { [weak self] _ in
                self?.scrollToBottomTrigger.onNext(())
            })
            .disposed(by: disposeBag)

    }
    
    private func bindEvent() {
        sendButton.rx.impactTap
            .asDriver()
            .drive( onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.chatTextView.text = nil
                self.currentChatViewHeight.accept(self.minTextViewHeight)
            })
            .disposed(by: disposeBag)
        
        keyboardTrigger.skip(1).asDriverComplete()
            .drive(onNext: { [weak self] keyboard in
                guard let self = self else { return }
                if keyboard.height > 0 {
                    
                    let distance =  keyboard.height - (safeInset?.bottom ?? 0.0)
                    UIView.animate(withDuration: keyboard.duration) {
                        self.bottomChatView.constant = distance
                        self.view.layoutIfNeeded()
                        self.scrollToBottomTrigger.onNext(())
                    } completion: { _ in
//                        self.scrollToBottomTrigger.onNext(())
                    }
                } else {
                    UIView.animate(withDuration: keyboard.duration) {
                        self.bottomChatView.constant = 0
                        self.view.layoutIfNeeded()
                    }
                }
                
            }).disposed(by: disposeBag)
        
        // bind textview
        chatTextView.rx
            .didChange
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                let newSize = self.chatTextView.getSize()
                if newSize.height < self.maxTextViewHeight && newSize.height > self.minTextViewHeight {
                    self.chatTextView.isScrollEnabled = false
                    self.currentChatViewHeight.accept(newSize.height)
                } else if newSize.height > self.maxTextViewHeight {
                    self.currentChatViewHeight.accept(self.maxTextViewHeight)
                    self.chatTextView.isScrollEnabled = true
                } else {
                    self.currentChatViewHeight.accept(self.minTextViewHeight)
                    self.chatTextView.isScrollEnabled = false
                }
            })
            .disposed(by: disposeBag)

        chatTextView.rx
            .didBeginEditing
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                let height = self.chatTextView.getSize().height
                self.currentChatViewHeight.accept(height > self.maxTextViewHeight ? self.maxTextViewHeight : height)
            })
            .disposed(by: disposeBag)

        chatTextView.rx
            .didEndEditing
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.currentChatViewHeight.accept(self.minTextViewHeight)
            })
            .disposed(by: disposeBag)

        chatTextView.rx.text.orEmpty
            .map({
                !$0.isEmpty
            })
            .bind(to: placeHolderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        chatTextView.rx.text.orEmpty
            .skip(1)
            .bind(to: viewModel.newMessage)
            .disposed(by: disposeBag)
        
        currentChatViewHeight.asDriver()
            .drive( onNext: { [weak self] value in
                self?.heightInputView.constant = value
            })
            .disposed(by: disposeBag)
        
    }
    
    private func scrollToBottom(isAnimate: Bool = false) {
        let lastIndex = viewModel.listMessages.value.count - 1
        if lastIndex >= 0 {
            chatTableView.scrollToRow(at: IndexPath(row: lastIndex, section: 0), at: .bottom, animated: isAnimate)

        }
    }
    
    @objc func tapTxtTypeHere() {
        chatTextView.becomeFirstResponder()
        
    }
}

extension SantaChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
