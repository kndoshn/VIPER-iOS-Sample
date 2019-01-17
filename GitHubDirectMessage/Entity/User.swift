struct User: Codable {
    let login: String?
    let avaterURL: String?

    private enum CodingKeys: String, CodingKey {
        case login
        case avaterURL = "avatar_url"
    }
}
