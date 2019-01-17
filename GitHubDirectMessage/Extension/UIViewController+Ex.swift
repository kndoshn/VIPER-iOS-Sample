import UIKit

extension UIViewController {
    func presentErrorAlert(with message: String) {
        let alert = UIAlertController(title: APIConst.defaultErrorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: false)
    }
}
