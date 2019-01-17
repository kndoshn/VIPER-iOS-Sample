protocol UserHistoryListInteractorInput: class {
    var presenter: UserHistoryListInteractorOutput { get }
    var dataManager: UserHistoryListDataManagerInput! { get }
    func getStoredUsers()
}

protocol UserHistoryListDataManagerOutput: class {
    func onGetStored(users: [User])
}

final class UserHistoryListInteractor: UserHistoryListInteractorInput {
    let presenter: UserHistoryListInteractorOutput
    var dataManager: UserHistoryListDataManagerInput!

    init(presenter: UserHistoryListInteractorOutput) {
        self.presenter = presenter
    }

    func inject(dataManager: UserHistoryListDataManagerInput) {
        self.dataManager = dataManager
    }

    func getStoredUsers() {
        dataManager.getStoredUsers()
    }
}

extension UserHistoryListInteractor: UserHistoryListDataManagerOutput {
    func onGetStored(users: [User]) {
        presenter.didGetStored(users: convert(users: users))
    }

    func convert(users: [User]) -> [UserModel] {
        return users.map { UserModel($0) }
    }
}
