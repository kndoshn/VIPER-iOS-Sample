import UIKit

protocol UserListView: class {
    var tableView: UITableView! { get }
    var cellIdentifier: String { get }
    var presenter: UserListPresenterInterface! { get }
    func show(users: [UserModel])
    func showError(with message: String)
    func showLoading()
    func hideLoading()
}

final class UserListViewController: UIViewController {
    @IBOutlet weak private(set) var tableView: UITableView!
    @IBOutlet weak private var loadingView: LoadingView!

    let cellIdentifier = "UserListTableViewCell"
    var presenter: UserListPresenterInterface!
    private var dataSource = [UserModel]()

    init() {
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func inject(presenter: UserListPresenterInterface) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

extension UserListViewController: UserListView {

    func show(users: [UserModel]) {
        self.dataSource = users
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func showError(with message: String) {
        presentErrorAlert(with: message)
    }

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.isHidden = true
            self.loadingView.isHidden = false
            self.loadingView.startLoading()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.isHidden = false
            self.loadingView.isHidden = true
            self.loadingView.stopLoading()
        }
    }
}

extension UserListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserListTableViewCell
        cell.nameLabel?.text = dataSource[indexPath.row].user.login
        cell.userImageView?.image = dataSource[indexPath.row].image
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.pushToChattingView(with: dataSource[indexPath.row].user)
    }
}
