import UIKit

@IBDesignable
final class ChattingInputView: UIView {
    @IBOutlet weak private(set) var textField: UITextField!
    @IBOutlet weak private(set) var sendButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        let nib = UINib(nibName: "ChattingInputView", bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)

        textField.layer.cornerRadius = textField.frame.height / 2
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(named: "gray08")?.cgColor

        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
}
