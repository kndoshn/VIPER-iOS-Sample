import UIKit

extension UIImage {
    convenience init?(_ user: User) {
        guard let avaterURL = user.avaterURL else { return nil }
        guard let url = URL(string: avaterURL) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
}
