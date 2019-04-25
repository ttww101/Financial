import UIKit

class RepostDiscussTableViewCellS: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var senderNicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        senderNicknameLabel.text = ""
        contentLabel.text = ""
        dateLabel.text = ""
        
    }

}
