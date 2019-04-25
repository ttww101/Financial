
import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userImageSelectBtn: UIButton!
    @IBOutlet weak var userNicknameTitleLabel: UILabel!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var userNicknameBtn: UIButton!
    @IBOutlet weak var userNicknameTextField: UITextField!
    @IBOutlet weak var userEmailTitleLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userEmailBtn: UIButton!
    @IBOutlet weak var userEmailTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.width/2
        userImageView.clipsToBounds = true
        userImageIndicator.isHidden = true
        userImageIndicator.stopAnimating()
        userNicknameTitleLabel.textColor = appSubColor
        userNicknameLabel.text = ""
        userNicknameLabel.isHidden = false
        userNicknameTextField.text = ""
        userNicknameTextField.isHidden = true
        userNicknameBtn.setTitle("变更", for: UIControl.State.normal)
        userNicknameBtn.backgroundColor = appSubColor
        userNicknameBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        userNicknameBtn.addTargetClosure { (sender) in
            
        }
        userEmailTitleLabel.textColor = appSubColor
        userEmailLabel.text = ""
        userEmailLabel.isHidden = false
        userEmailTextField.text = ""
        userEmailTextField.isHidden = true
        userEmailBtn.setTitle("变更", for: UIControl.State.normal)
        userEmailBtn.backgroundColor = appSubColor
        userEmailBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        userEmailBtn.addTargetClosure { (sender) in
            
        }
    }

}
