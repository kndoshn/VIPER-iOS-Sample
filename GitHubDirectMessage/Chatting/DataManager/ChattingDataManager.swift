import Foundation

protocol ChattingDataManagerInput: class {
    var dataManagerOutput: ChattingListDataManagerOutput { get }
    func getStoredChatDataSource(user: User)
    func storeNew(dataSource: ChatDataSource)
    func fetchSampleReply(from user: User, text: String)
}

final class ChattingDataManager: ChattingDataManagerInput {
    let dataManagerOutput: ChattingListDataManagerOutput

    init(dataManagerOutput: ChattingListDataManagerOutput) {
        self.dataManagerOutput = dataManagerOutput
    }

    func getStoredChatDataSource(user: User) {
        guard let login = user.login else { return }
        guard let data = UserDefaults.standard.data(forKey: getUserDefaultsKey(login)) else { return }
        guard let dataSource = try? JSONDecoder().decode(ChatDataSource.self, from: data) else { return }
        dataManagerOutput.didGetStored(dataSource: dataSource)
    }

    func storeNew(dataSource: ChatDataSource) {
        guard let login = dataSource.opponent.login else { return }
        guard let data = try? JSONEncoder().encode(dataSource) else { return }
        UserDefaults.standard.set(data, forKey: getUserDefaultsKey(login))
    }

    func fetchSampleReply(from user: User, text: String) {
        #if DEBUG
        guard let login = user.login else { return }
        guard let data = UserDefaults.standard.data(forKey: getUserDefaultsKey(login)) else { return }
        guard let dataSource = try? JSONDecoder().decode(ChatDataSource.self, from: data) else { return }

        let new = Message(date: Date(), talkSide: .opponent, text: "\(text)\(text)")
        var messages = dataSource.messages
        messages.append(new)
        let latest = ChatDataSource(opponent: user, messages: messages)
        if let latestData = try? JSONEncoder().encode(latest) {
            UserDefaults.standard.set(latestData, forKey: getUserDefaultsKey(login))
            dataManagerOutput.onFetched(latest: latest)
        }
        #endif
    }

    func getUserDefaultsKey(_ login: String) -> String {
        return "ChatHistory.\(login)"
    }
}
