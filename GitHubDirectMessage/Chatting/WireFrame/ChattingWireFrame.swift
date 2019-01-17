protocol ChattingWireFrameInterface: class {
    static func build(user: User) -> ChattingViewController
}

final class ChattingWireFrame: ChattingWireFrameInterface {
    static func build(user: User) -> ChattingViewController {
        let vc = ChattingViewController(user: user)
        let presenter = ChattingPresenter(view: vc)
        let interactor = ChattingInteractor(presenter: presenter)

        vc.inject(presenter: presenter)
        presenter.inject(interactor: interactor)
        interactor.inject(dataManager: ChattingDataManager(dataManagerOutput: interactor))

        return vc
    }
}
