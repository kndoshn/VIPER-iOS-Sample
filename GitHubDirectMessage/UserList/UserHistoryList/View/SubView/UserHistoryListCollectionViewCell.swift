import UIKit

class UserHistoryListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private(set) var userImageView: UIImageView!
    @IBOutlet weak private(set) var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2

        nameLabel.text = "Tetstte"
    }
}
