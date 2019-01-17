import UIKit

final class MyMessageTableViewCell: UITableViewCell {
    @IBOutlet weak private(set) var messageLabel: UILabel!
    @IBOutlet weak private var bubbleImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        transform = CGAffineTransform.identity.rotated(by: .pi)

        bubbleImageView?.image = UIImage(named: "right_bubble")!.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 17, bottom: 21, right: 21))
    }
}
