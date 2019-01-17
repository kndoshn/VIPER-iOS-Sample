import Foundation

protocol UserListDataManagerInput: class {
    var dataManagerOutput: UserListDataManagerOutput { get }
    func fetchUsers()
}

final class UserListDataManager: UserListDataManagerInput {
    let dataManagerOutput: UserListDataManagerOutput

    init(dataManagerOutput: UserListDataManagerOutput) {
        self.dataManagerOutput = dataManagerOutput
    }

    func fetchUsers() {
        URLSessionClient().get(URLRouter.users.url) { data, error in
            if let error = error {
                self.dataManagerOutput.on(error: error)
            }
            guard let data = data else {
                self.dataManagerOutput.on(error: NSError()); return
            }

            do {
                let users = try self.parse(data: data)
                self.dataManagerOutput.onFetched(users: users)
            } catch {
                self.dataManagerOutput.on(error: NSError()); return
            }
        }
    }

    func parse(data: Data) throws -> [User] {
        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            throw error
        }
    }
}
