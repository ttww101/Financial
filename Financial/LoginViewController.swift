import UIKit

class LoginViewController: KeyboardViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarTitleLabel: UILabel!
    @IBOutlet weak var accountTitleLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var accountStrokeView: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordStrokeView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var sendBirdAccountChannelUrl:String = ""
    var confirmClickCallback:((_ userInfo: UserInfoObject) -> Void)?
    var cancelClickCallback:(() -> Void)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountTextField.delegate = self
        passwordTextField.delegate = self
        
        backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFill
        loginView.layer.cornerRadius = 5
        loginView.clipsToBounds = true
        accountStrokeView.layer.cornerRadius = 3
        accountStrokeView.clipsToBounds = true
        accountTextField.layer.cornerRadius = 3
        accountTextField.clipsToBounds = true
        passwordStrokeView.layer.cornerRadius = 3
        passwordStrokeView.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 3
        passwordTextField.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.clipsToBounds = true
        confirmBtn.layer.cornerRadius = 3
        confirmBtn.clipsToBounds = true
        
        topBarView.backgroundColor = appMainColor
        topBarTitleLabel.textColor = appLightColor
        topBarTitleLabel.text = "登入"
        accountStrokeView.backgroundColor = appMainColor
        accountTitleLabel.textColor = appSubColor
        accountTitleLabel.text = "信箱"
        accountTextField.placeholder = "请输入电子邮件信箱..."
        passwordStrokeView.backgroundColor = appMainColor
        passwordTitleLabel.textColor = appSubColor
        passwordTitleLabel.text = "密码"
        passwordTextField.placeholder = "请输入密码..."
        cancelBtn.layer.backgroundColor = appMainColor.cgColor
        cancelBtn.setTitleColor(appLightColor, for: UIControl.State.normal)
        cancelBtn.setTitle("注册", for: UIControl.State.normal)
        confirmBtn.layer.backgroundColor = appMainColor.cgColor
        confirmBtn.setTitleColor(appLightColor, for: UIControl.State.normal)
        confirmBtn.setTitle("登入", for: UIControl.State.normal)
        
        confirmBtn.addTarget(self, action: #selector(confirmBtnClick), for: UIControl.Event.touchUpInside)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func confirmBtnClick() {
        
        startIndicator(abbs: nil, currentVC: self, callback: { (indicatorView) in
            getAccountsFrom(abbs: nil, sendBirdAccountChannelUrl: self.sendBirdAccountChannelUrl) { (userInfoArray) in
                var index = -1
                for i in 0..<userInfoArray.count {
                    if (userInfoArray[i].userEmail == self.accountTextField.text!) {
                        if (userInfoArray[i].userPassword == self.passwordTextField.text!) {
                            index = i
                            break
                        }
                    }
                }
                stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                    
                    if (index >= 0) {
                        setSendBirdUserInfo(abbs: nil, userNickname: userInfoArray[index].userNickname, userEmail: userInfoArray[index].userEmail, userImageUrl: userInfoArray[index].userImageUrl, userPassword: userInfoArray[index].userPassword)
                        if (self.confirmClickCallback != nil) {
                            self.confirmClickCallback!(userInfoArray[index])
                        }
                    }
                    
                })
                
            }
        })
        
    }
    
    @objc func cancelBtnClick() {
        if (cancelClickCallback != nil) {
            self.cancelClickCallback!()
        }
    }
    
    func setParameter(abbs:String?, sendBirdAccountChannelUrl: String, didLoginCallback: ((_ userInfo:UserInfoObject) -> Void)?, cancelCallback: (() -> Void)?) {
        self.sendBirdAccountChannelUrl = sendBirdAccountChannelUrl
        self.confirmClickCallback = didLoginCallback
        self.cancelClickCallback = cancelCallback
    }

}
