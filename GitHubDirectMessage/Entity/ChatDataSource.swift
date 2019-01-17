import Foundation

struct ChatDataSource: Codable {
    let opponent: User
    let messages: [Message]
}
