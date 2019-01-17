import UIKit

final class UserContainerViewController: UIViewController {
    private let historyViewController: UserHistoryListViewController
    private let listViewController: UserListViewController

    init(listViewController: UserListViewController, historyViewController: UserHistoryListViewController) {
        self.listViewController = listViewController
        self.historyViewController = historyViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = ""
        view.backgroundColor = .white

        [historyViewController, listViewController].forEach {
            addChild($0)
            $0.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0.view)
            $0.didMove(toParent: self)
        }

        NSLayoutConstraint.activate([
            historyViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            historyViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyViewController.view.heightAnchor.constraint(equalToConstant: 140),

            listViewController.view.topAnchor.constraint(equalTo: historyViewController.view.safeAreaLayoutGuide.bottomAnchor),
            listViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
