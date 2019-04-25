import UIKit
import Photos

class RegisterViewController: KeyboardViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarTitleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var nicknameTitleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var confirmTitleLabel: UILabel!
    @IBOutlet weak var nicknameStrokeView: UIView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailStrokeView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordStrokeView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmStrokeView: UIView!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    var submitClickCallback:((_ userInfo: UserInfoObject) -> Void)?
    var cancelClickCallback:(() -> Void)?
    
    let imagePicker = UIImagePickerController()
    var sendBirdLoginChannelUrl:String = ""
    var userImageUrl:String = ""
    
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
        
        imagePicker.delegate = self
        nicknameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
        backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFill
        registerView.layer.cornerRadius = 5
        registerView.clipsToBounds = true
        userImageView.contentMode = UIView.ContentMode.scaleAspectFill
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        userImageView.clipsToBounds = true
        nicknameStrokeView.layer.cornerRadius = 3
        nicknameStrokeView.clipsToBounds = true
        nicknameTextField.layer.cornerRadius = 3
        nicknameTextField.clipsToBounds = true
        emailStrokeView.layer.cornerRadius = 3
        emailStrokeView.clipsToBounds = true
        emailTextField.layer.cornerRadius = 3
        emailTextField.clipsToBounds = true
        passwordStrokeView.layer.cornerRadius = 3
        passwordStrokeView.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 3
        passwordTextField.clipsToBounds = true
        confirmStrokeView.layer.cornerRadius = 3
        confirmStrokeView.clipsToBounds = true
        confirmTextField.layer.cornerRadius = 3
        confirmTextField.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.clipsToBounds = true
        submitBtn.layer.cornerRadius = 3
        submitBtn.clipsToBounds = true
        
        topBarView.backgroundColor = appMainColor
        topBarTitleLabel.textColor = appLightColor
        topBarTitleLabel.text = "注册"
        
        nicknameStrokeView.backgroundColor = appMainColor
        nicknameTitleLabel.textColor = appSubColor
        nicknameTitleLabel.text = "昵称"
        nicknameTextField.placeholder = "请输入昵称..."
        
        emailStrokeView.backgroundColor = appMainColor
        emailTitleLabel.textColor = appSubColor
        emailTitleLabel.text = "信箱"
        emailTextField.placeholder = "请输入电子邮件信箱..."
        
        passwordStrokeView.backgroundColor = appMainColor
        passwordTitleLabel.textColor = appSubColor
        passwordTitleLabel.text = "密码"
        passwordTextField.placeholder = "請輸入密碼..."
        
        confirmStrokeView.backgroundColor = appMainColor
        confirmTitleLabel.textColor = appSubColor
        confirmTitleLabel.text = "确认"
        confirmTextField.placeholder = "请再输入一次密码..."
        
        cancelBtn.layer.backgroundColor = appMainColor.cgColor
        cancelBtn.setTitleColor(appLightColor, for: UIControl.State.normal)
        cancelBtn.setTitle("取消", for: UIControl.State.normal)
        submitBtn.layer.backgroundColor = appMainColor.cgColor
        submitBtn.setTitleColor(appLightColor, for: UIControl.State.normal)
        submitBtn.setTitle("注册", for: UIControl.State.normal)
        
        userImageBtn.addTarget(self, action: #selector(userImageBtnClick), for: UIControl.Event.touchUpInside)
        
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: UIControl.Event.touchUpInside)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestPhotoAuth(abbs: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            dismiss(animated: true) {
                
                startIndicator(abbs: nil, currentVC: self, callback: { (indicatorView01) in
                    uploadImageGetLink(abbs: nil, image: pickedImage) { (imageLink) in
                        self.userImageUrl = imageLink
                        stopIndicator(abbs: nil, indicatorView: indicatorView01, callback: {
                            if (self.userImageUrl.count > 0) {
                                startIndicator(abbs: nil, currentVC: self, callback: { (indicatorView02) in
                                    downloadImage(abbs: nil, url: self.userImageUrl) { (image) in
                                        stopIndicator(abbs: nil, indicatorView: indicatorView02, callback: {
                                            self.userImageView.image = image
                                        })
                                    }
                                })
                            }
                        })
                    }
                })
                
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func userImageBtnClick() {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @objc func submitBtnClick() {
        if (self.nicknameTextField.text!.count > 0) {
            if (self.emailTextField.text!.count > 0) {
                if (self.passwordTextField.text!.count > 0) {
                    if (self.passwordTextField.text! == self.confirmTextField.text!) {
                        if (self.userImageUrl.count > 0) {
                            startIndicator(abbs: nil, currentVC: self) { (indicatorView) in
                                let userInfoObj = UserInfoObject()
                                userInfoObj.userNickname = self.nicknameTextField.text!
                                userInfoObj.userEmail = self.emailTextField.text!
                                userInfoObj.userPassword = self.passwordTextField.text!
                                userInfoObj.userImageUrl = self.userImageUrl
                                
                                sendAccountTo(abbs: nil, sendBirdAccountChannelUrl: self.sendBirdLoginChannelUrl, userInfo: userInfoObj, didSendCallback: {
                                    
                                    stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                                        
                                        if (self.submitClickCallback != nil) {
                                            self.submitClickCallback!(userInfoObj)
                                        }
                                        
                                    })
                                    
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func cancelBtnClick() {
        if (cancelClickCallback != nil) {
            self.cancelClickCallback!()
        }
    }
    
    func setParameter(abbs:String?, sendBirdLoginChannelUrl: String, didRegistedCallback: ((_ userInfo: UserInfoObject) -> Void)?, cancelCallback: (() -> Void)?) {
        self.sendBirdLoginChannelUrl = sendBirdLoginChannelUrl
        self.submitClickCallback = didRegistedCallback
        self.cancelClickCallback = cancelCallback
    }
    
    func requestPhotoAuth(abbs:String?) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if (photoAuthorizationStatus == .notDetermined) {
            PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
                self.requestPhotoAuth(abbs: nil)
            }
        } else {
            if (photoAuthorizationStatus != .authorized) {
                
                let alertController = UIAlertController(title: "同意App使用相簿",
                                                        message: "您必须同意App存取相簿才能上传个人照片，照片将于您发布文章或留言时使用", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "关闭", style: .default, handler: {
                    action in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }

}
