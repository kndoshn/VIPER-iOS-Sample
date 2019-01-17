import Foundation

protocol UserHistoryListDataManagerInput: class {
    var dataManagerOutput: UserHistoryListDataManagerOutput { get }
    func getStoredUsers()
}

final class UserHistoryListDataManager: UserHistoryListDataManagerInput {
    let dataManagerOutput: UserHistoryListDataManagerOutput

    init(dataManagerOutput: UserHistoryListDataManagerOutput) {
        self.dataManagerOutput = dataManagerOutput
    }

    func getStoredUsers() {
        let users: [User] = UserDefaults.standard.dictionaryRepresentation().keys.compactMap { key in
            guard key.hasPrefix("ChatHistory.") else { return nil }
            guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
            guard let chatData = try? JSONDecoder().decode(ChatDataSource.self, from: data) else { return nil }
            return chatData.opponent
        }
        dataManagerOutput.onGetStored(users: users)
    }
}
