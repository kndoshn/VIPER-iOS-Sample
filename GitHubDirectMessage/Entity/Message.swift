import Foundation

struct Message: Codable {
    enum TalkSide: String, Codable {
        case mine
        case opponent
    }

    let date: Date
    let talkSide: TalkSide
    let text: String
}
