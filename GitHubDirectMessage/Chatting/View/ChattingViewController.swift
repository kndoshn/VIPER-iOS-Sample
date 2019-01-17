import UIKit

protocol ChattingView: class {
    var tableView: UITableView! { get }
    var chattingInputView: ChattingInputView! { get }
    var bottomLayoutConstraint: NSLayoutConstraint! { get set }
    var backgroundView: UIView! { get }
    var navigationTitle: String? { get set }
    var user: User { get }
    var identifiers: [String] { get }
    var dataSource: ChatDataSource? { get }
    func showStored(dataSource: ChatDataSource)
    func showFetched(latest dataSource: ChatDataSource)
}

final class ChattingViewController: UIViewController {
    @IBOutlet weak private(set) var tableView: UITableView!
    @IBOutlet weak private(set) var chattingInputView: ChattingInputView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

    var backgroundView: UIView! { return view }
    var navigationTitle: String? {
        get { return title }
        set { title = newValue }
    }

    var presenter: ChattingPresenterInterface!
    let user: User
    let identifiers = ["MyMessageTableViewCell", "OpponentMessageTableViewCell"]
    private(set) var dataSource: ChatDataSource?
    private var image: UIImage?

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }

    func inject(presenter: ChattingPresenterInterface) {
        self.presenter = presenter
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        chattingInputView.sendButton.addTarget(nil, action: #selector(didTapSend), for: .touchUpInside)
        presenter.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }

    @objc func didTapSend() {
        presenter.didTapSend()
    }
}

extension ChattingViewController: ChattingView {
    func showStored(dataSource: ChatDataSource) {
        self.dataSource = dataSource
        self.image = UIImage(dataSource.opponent)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func showFetched(latest dataSource: ChatDataSource) {
        self.dataSource = dataSource
        self.image = UIImage(dataSource.opponent)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension ChattingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.messages.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = dataSource?.messages[indexPath.row] else { return UITableViewCell() }
        switch message.talkSide {
        case .mine:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifiers[0], for: indexPath) as! MyMessageTableViewCell
            cell.messageLabel.text = message.text
            return cell
        case .opponent:
            let cell = tableView.dequeueReusableCell(withIdentifier: identifiers[1], for: indexPath) as! OpponentMessageTableViewCell
            cell.userImageView.image = image
            cell.messageLabel.text = message.text
            return cell
        }

    }
}

extension ChattingViewController: UIGestureRecognizerDelegate {}
