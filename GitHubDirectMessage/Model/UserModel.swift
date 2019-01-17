import UIKit

struct UserModel {
    let user: User
    let image: UIImage?

    init(_ user: User) {
        self.user = user
        self.image = UIImage(user)
    }
}
