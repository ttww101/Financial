import UIKit

class CalculateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var enableBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceInputView: UIView!
    @IBOutlet weak var priceInputTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = ""
        priceLabel.text = ""
        priceInputView.isHidden = true
        priceInputTextField.text = ""
        
    }

}
