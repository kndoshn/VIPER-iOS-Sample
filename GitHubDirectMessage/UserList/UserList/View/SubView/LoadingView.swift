import UIKit

final class LoadingView: UIView {
    @IBOutlet weak private var indicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()

        let nib = UINib(nibName: "LoadingView", bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
    }

    func startLoading() {
        indicator.startAnimating()
    }

    func stopLoading() {
        indicator.stopAnimating()
    }
}
