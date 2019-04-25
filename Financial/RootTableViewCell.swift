import UIKit

class RootTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconImageWidth: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.image = nil
        nameLabel.text = nil
        iconImageWidth.constant = 0
        nameLabel.textColor = appMainColor
        
    }

}
