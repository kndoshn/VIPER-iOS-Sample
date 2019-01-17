protocol UserHistoryListWireFrameInterface: class {
    static func build() -> UserHistoryListViewController
    static func toChattingView(with user: User, from: UserHistoryListView)
}

final class UserHistoryListWireFrame: UserHistoryListWireFrameInterface {
    static func build() -> UserHistoryListViewController {
        let vc = UserHistoryListViewController()
        let presenter = UserHistoryListPresenter(view: vc)
        let interactor = UserHistoryListInteractor(presenter: presenter)

        vc.inject(presenter: presenter)
        presenter.inject(interactor: interactor)
        interactor.inject(dataManager: UserHistoryListDataManager(dataManagerOutput: interactor))

        return vc
    }

    static func toChattingView(with user: User, from: UserHistoryListView) {
        guard let vc = from as? UserHistoryListViewController else { assertionFailure(); return }
        let destination = ChattingWireFrame.build(user: user)
        vc.navigationController?.pushViewController(destination, animated: true)
    }
}
