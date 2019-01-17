protocol UserListWireFrameInterface: class {
    static func build() -> UserListViewController
    static func toChattingView(with user: User, from: UserListView)
}

final class UserListWireFrame: UserListWireFrameInterface {
    static func build() -> UserListViewController {
        let vc = UserListViewController()
        let presenter = UserListPresenter(view: vc)
        let interactor = UserListInteractor(presenter: presenter)

        vc.inject(presenter: presenter)
        presenter.inject(interactor: interactor)
        interactor.inject(dataManager: UserListDataManager(dataManagerOutput: interactor))

        return vc
    }

    static func toChattingView(with user: User, from: UserListView) {
        guard let vc = from as? UserListViewController else { assertionFailure(); return }
        let destination = ChattingWireFrame.build(user: user)
        vc.navigationController?.pushViewController(destination, animated: true)
    }
}
