import UIKit

final class OpponentMessageTableViewCell: UITableViewCell {
    @IBOutlet weak private(set) var userImageView: UIImageView!
    @IBOutlet weak private(set) var messageLabel: UILabel!
    @IBOutlet weak private var bubbleImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        transform = CGAffineTransform.identity.rotated(by: .pi)

        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        bubbleImageView?.image = UIImage(named: "left_bubble")!.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 21, right: 17)).withRenderingMode(.alwaysTemplate)
        bubbleImageView.tintColor = UIColor(named: "gray09")
    }
}
