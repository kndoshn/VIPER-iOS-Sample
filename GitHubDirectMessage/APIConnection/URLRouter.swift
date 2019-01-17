import Foundation

enum URLRouter {
    private static let urlBase = "https://api.github.com"
    
    case users
    
    private var path: String {
        switch self {
        case .users: return "/users"
        }
    }
    
    var url: URL {
        switch self {
        case .users: return URL(string: URLRouter.urlBase + path)!
        }
    }
}
