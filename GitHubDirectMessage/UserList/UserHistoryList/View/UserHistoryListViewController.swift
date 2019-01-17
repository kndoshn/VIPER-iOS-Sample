import UIKit

protocol UserHistoryListView: class {
    var collectionView: UICollectionView! { get }
    var cellIdentifire: String { get }
    func show(users: [UserModel])
}

final class UserHistoryListViewController: UIViewController {
    @IBOutlet weak private(set) var collectionView: UICollectionView!

    let cellIdentifire = "UserHistoryListCollectionViewCell"
    var presenter: UserHistoryListPresenterInterface!
    private var dataSource = [UserModel]()

    init() {
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func inject(presenter: UserHistoryListPresenterInterface) {
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

extension UserHistoryListViewController: UserHistoryListView {
    func show(users: [UserModel]) {
        self.dataSource = users
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension UserHistoryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifire, for: indexPath) as! UserHistoryListCollectionViewCell
        cell.userImageView.image = dataSource[indexPath.row].image
        cell.nameLabel.text = dataSource[indexPath.row].user.login
        return cell
    }
}

extension UserHistoryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.pushToChattingView(with: dataSource[indexPath.row].user)
    }
}
