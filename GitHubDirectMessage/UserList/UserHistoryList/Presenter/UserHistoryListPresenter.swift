import UIKit

protocol UserHistoryListPresenterInterface: class {
    var view: UserHistoryListView! { get }
    var interactor: UserHistoryListInteractorInput! { get }

    func viewDidLoad()
    func viewWillAppear()
    func getAllStoredUsers()
    func pushToChattingView(with user: User)
}

protocol UserHistoryListInteractorOutput: class {
    func didGetStored(users: [UserModel])
}

final class UserHistoryListPresenter: UserHistoryListPresenterInterface {
    weak var view: UserHistoryListView!
    var interactor: UserHistoryListInteractorInput!

    init(view: UserHistoryListView) {
        self.view = view
    }

    func inject(interactor: UserHistoryListInteractorInput) {
        self.interactor = interactor
    }

    func viewDidLoad() {
        view.collectionView.register(UINib(nibName: view.cellIdentifire, bundle: nil), forCellWithReuseIdentifier: view.cellIdentifire)
        getAllStoredUsers()
    }

    func viewWillAppear() {
        getAllStoredUsers()
    }

    func getAllStoredUsers() {
        interactor.getStoredUsers()
    }

    func pushToChattingView(with user: User) {
        UserHistoryListWireFrame.toChattingView(with: user, from: view)
    }
}

extension UserHistoryListPresenter: UserHistoryListInteractorOutput {
    func didGetStored(users: [UserModel]) {
        view.show(users: users)
    }
}
