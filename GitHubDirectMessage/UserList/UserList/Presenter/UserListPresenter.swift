import UIKit

protocol UserListPresenterInterface: class {
    var view: UserListView! { get }
    var interactor: UserListInteractorInput! { get }

    func viewDidLoad()
    func viewWillAppear()
    func pushToChattingView(with user: User)
}

protocol UserListInteractorOutput: class {
    func didFetch(users: [UserModel])
    func on(error: Error)
}

final class UserListPresenter: UserListPresenterInterface {
    weak var view: UserListView!
    var interactor: UserListInteractorInput!

    init(view: UserListView) {
        self.view = view
    }

    func inject(interactor: UserListInteractorInput) {
        self.interactor = interactor
    }

    func viewDidLoad() {
        view.tableView.register(UINib(nibName: view.cellIdentifier, bundle: nil), forCellReuseIdentifier: view.cellIdentifier)
        view.showLoading()
        interactor.fetchUsers()
    }

    func viewWillAppear() {
        if let indexPathForSelectedRow = view.tableView.indexPathForSelectedRow {
            view.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }

    func pushToChattingView(with user: User) {
        UserListWireFrame.toChattingView(with: user, from: view)
    }
}

extension UserListPresenter: UserListInteractorOutput {
    func didFetch(users: [UserModel]) {
        view.show(users: users)
        view.hideLoading()
    }

    func on(error: Error) {
        if let apiError = error as? APIError {
            view.showError(with: apiError.message)
        } else {
            view.showError(with: APIConst.defaultErrorMessage)
        }
    }
}
