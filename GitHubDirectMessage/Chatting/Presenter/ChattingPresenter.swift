import UIKit

protocol ChattingPresenterInterface: class {
    var view: ChattingView! { get }
    var interactor: ChattingInteractorInput! { get }

    func viewDidLoad()
    func viewWillDisappear()
    func didTapSend()
}

protocol ChattingInteractorOutput: class {
    func didGet(dataSource: ChatDataSource)
    func didFetched(latest dataSource: ChatDataSource)
}

final class ChattingPresenter: ChattingPresenterInterface {
    weak var view: ChattingView!
    var interactor: ChattingInteractorInput!

    init(view: ChattingView) {
        self.view = view
    }

    func inject(interactor: ChattingInteractorInput) {
        self.interactor = interactor
    }

    func viewDidLoad() {
        interactor.getStoredChatDataSource(user: view.user)

        view.navigationTitle = view.user.login
        view.tableView.transform = CGAffineTransform.identity.rotated(by: .pi)
        view.identifiers.forEach {
            view.tableView.register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)
        }

        startObserveKeyboardNotification()
        addTapGesture()
    }

    func viewWillDisappear() {
        view.chattingInputView.textField.resignFirstResponder()
        removeObserveKeyboardNotification()
    }

    func didTapSend() {
        guard let text = view.chattingInputView.textField.text else { return }
        guard !text.isEmpty else { return }

        let message = Message(date: Date(), talkSide: .mine, text: text)
        interactor.storeNew(message: message, to: view.dataSource, with: view.user)
        interactor.getStoredChatDataSource(user: view.user)

        view.chattingInputView.textField.text = ""

        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
            guard let self = self else { return }
            self.interactor.fetchSampleReply(from: self.view.user, text: text)
        }
        #endif
    }

    private func startObserveKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeObserveKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.delegate = view as? UIGestureRecognizerDelegate
        view.tableView.addGestureRecognizer(tapGesture)
    }

    @objc private func willShowKeyboard(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            view.backgroundView.layoutIfNeeded()
            view.bottomLayoutConstraint.constant = keyboardFrame.cgRectValue.height - view.backgroundView.safeAreaInsets.bottom
            view.backgroundView.layoutIfNeeded()
        }
    }

    @objc private func willHideKeyboard(notification: NSNotification) {
        view.backgroundView.layoutIfNeeded()
        view.bottomLayoutConstraint.constant = 0
        view.backgroundView.layoutIfNeeded()
    }

    @objc private func viewTapped() {
        view.chattingInputView.textField.resignFirstResponder()
    }
}

extension ChattingPresenter: ChattingInteractorOutput {
    func didGet(dataSource: ChatDataSource) {
        view.showStored(dataSource: dataSource)
    }

    func didFetched(latest dataSource: ChatDataSource) {
        view.showFetched(latest: dataSource)
    }
}
