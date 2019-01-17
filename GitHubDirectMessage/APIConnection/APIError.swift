enum APIError: Error {
    case rateLimitExceeded
    case other(statusCode: Int)

    init(statusCode: Int) {
        switch statusCode {
        case 403: self = .rateLimitExceeded
        default: self = .other(statusCode: statusCode)
        }
    }

    var message: String {
        switch self {
        case .rateLimitExceeded: return "しばらく時間が経ってから再度お試しください"
        case .other: return "お手数ですが運営までご連絡ください"
        }
    }
}
