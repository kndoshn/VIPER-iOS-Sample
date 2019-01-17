protocol UserListInteractorInput: class {
    var presenter: UserListInteractorOutput { get }
    var dataManager: UserListDataManagerInput! { get }
    func fetchUsers()
}

protocol UserListDataManagerOutput: class {
    func onFetched(users: [User])
    func on(error: Error)
}

final class UserListInteractor: UserListInteractorInput {
    let presenter: UserListInteractorOutput
    var dataManager: UserListDataManagerInput!

    init(presenter: UserListInteractorOutput) {
        self.presenter = presenter
    }

    func inject(dataManager: UserListDataManagerInput) {
        self.dataManager = dataManager
    }

    func fetchUsers() {
        dataManager.fetchUsers()
    }
}

extension UserListInteractor: UserListDataManagerOutput {
    func onFetched(users: [User]) {
        presenter.didFetch(users: convert(users: users))
    }

    func convert(users: [User]) -> [UserModel] {
        return users.map { UserModel($0) }
    }

    func on(error: Error) {
        presenter.on(error: error)
    }
}
