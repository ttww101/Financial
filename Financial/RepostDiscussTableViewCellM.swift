import UIKit

class RepostDiscussTableViewCellM: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var senderNicknameLabel: UILabel!
    @IBOutlet weak var accordingImageView: UIImageView!
    @IBOutlet weak var accordingTitleLabel: UILabel!
    @IBOutlet weak var accordingSubTitleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        senderNicknameLabel.text = ""
        subjectLabel.text = ""
        subjectLabel.textColor = appSubColor
        accordingTitleLabel.text = ""
        accordingSubTitleLabel.text = ""
        contentLabel.text = ""
        
    }

}
