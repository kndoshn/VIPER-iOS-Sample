protocol ChattingInteractorInput: class {
    var presenter: ChattingInteractorOutput { get }
    var dataManager: ChattingDataManagerInput! { get }
    func getStoredChatDataSource(user: User)
    func storeNew(message: Message, to dataSource: ChatDataSource?, with user: User)
    func fetchSampleReply(from user: User, text: String)
}

protocol ChattingListDataManagerOutput: class {
    func didGetStored(dataSource: ChatDataSource?)
    func onFetched(latest dataSource: ChatDataSource)
}

final class ChattingInteractor: ChattingInteractorInput {
    let presenter: ChattingInteractorOutput
    var dataManager: ChattingDataManagerInput!

    init(presenter: ChattingInteractorOutput) {
        self.presenter = presenter
    }

    func inject(dataManager: ChattingDataManagerInput) {
        self.dataManager = dataManager
    }

    func getStoredChatDataSource(user: User) {
        dataManager.getStoredChatDataSource(user: user)
    }

    func storeNew(message: Message, to dataSource: ChatDataSource?, with user: User) {
        if let dataSource = dataSource {
            var messages = dataSource.messages
            messages.append(message)
            dataManager.storeNew(dataSource: ChatDataSource(opponent: dataSource.opponent, messages: messages))
        } else {
            let new = ChatDataSource(opponent: user, messages: [message])
            dataManager.storeNew(dataSource: new)
        }
    }

    func fetchSampleReply(from user: User, text: String) {
        dataManager.fetchSampleReply(from: user, text: text)
    }
}

extension ChattingInteractor: ChattingListDataManagerOutput {
    func didGetStored(dataSource: ChatDataSource?) {
        guard let dataSource = dataSource else { return }
        presenter.didGet(dataSource: sort(dataSource: dataSource))
    }

    private func sort(dataSource: ChatDataSource) -> ChatDataSource {
        let sortedMessage = dataSource.messages.sorted(by: { $0.date > $1.date })
        return ChatDataSource(opponent: dataSource.opponent, messages: sortedMessage)
    }

    func onFetched(latest dataSource: ChatDataSource) {
        presenter.didFetched(latest: sort(dataSource: dataSource))
    }
}
