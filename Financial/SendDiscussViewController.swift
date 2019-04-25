import UIKit

class SendDiscussViewController: KeyboardViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var sendDiscussView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarTitleLabel: UILabel!
    @IBOutlet weak var subjectTitleLabel: UILabel!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var subjectStrokeView: UIView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var contentStrokeView: UIView!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    var sendBirdDiscussChannelUrl:String = ""
    var accordingObject:DiscussAccordingObject = DiscussAccordingObject()
    var sendClickCallback:((_ discussObj: DiscussObject) -> Void)?
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
        
        subjectTextField.delegate = self
        contentTextField.delegate = self
        
        backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFill
        sendDiscussView.layer.cornerRadius = 5
        sendDiscussView.clipsToBounds = true
        subjectStrokeView.layer.cornerRadius = 3
        subjectStrokeView.clipsToBounds = true
        subjectTextField.layer.cornerRadius = 3
        subjectTextField.clipsToBounds = true
        contentStrokeView.layer.cornerRadius = 3
        contentStrokeView.clipsToBounds = true
        contentTextField.layer.cornerRadius = 3
        contentTextField.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.clipsToBounds = true
        sendBtn.layer.cornerRadius = 3
        sendBtn.clipsToBounds = true
        
        topBarView.backgroundColor = appMainColor
        topBarTitleLabel.textColor = appLightColor
        topBarTitleLabel.text = "评论"
        
        subjectStrokeView.backgroundColor = appMainColor
        subjectTitleLabel.textColor = appSubColor
        subjectTitleLabel.text = "主题"
        
        contentStrokeView.backgroundColor = appMainColor
        contentTitleLabel.textColor = appSubColor
        contentTitleLabel.text = "内容"
        
        cancelBtn.layer.backgroundColor = appMainColor.cgColor
        cancelBtn.setTitleColor(appLightColor, for: UIControl.State.normal)
        cancelBtn.setTitle("取消", for: UIControl.State.normal)
        sendBtn.layer.backgroundColor = appMainColor.cgColor
        sendBtn.setTitleColor(appLightColor, for: UIControl.State.normal)
        sendBtn.setTitle("发布", for: UIControl.State.normal)
        
        sendBtn.addTarget(self, action: #selector(sendBtnClick), for: UIControl.Event.touchUpInside)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: UIControl.Event.touchUpInside)
        
        
    }
    
    @objc func sendBtnClick() {
        if (self.subjectTextField.text!.count > 0) {
            if (self.contentTextField.text!.count > 0) {
                
                startIndicator(abbs: nil, currentVC: self) { (indicatorView) in
                    let discussObj = DiscussObject()
                    discussObj.discussId = Int(Date().timeIntervalSince1970)
                    discussObj.subject = self.subjectTextField.text!
                    discussObj.content = self.contentTextField.text!
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd"
                    df.string(from: Date())
                    discussObj.date = df.string(from: Date())
                    discussObj.according = self.accordingObject
                    
                    sendDiscussTo(abbs: nil, sendBirdDiscussChannelUrl: self.sendBirdDiscussChannelUrl, discussObject: discussObj, didSendCallback: {
                        
                        stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                            
                            if (self.sendClickCallback != nil) {
                                self.sendClickCallback!(discussObj)
                            }
                            
                        })
                        
                    })
                }
            }
        }
    }
    
    @objc func cancelBtnClick() {
        if (cancelClickCallback != nil) {
            cancelClickCallback!()
        }
    }
    
    func setParameter(abbs:String?, sendBirdDiscussChannelUrl: String, accordingObj:DiscussAccordingObject, didSendCallback: ((_ discussObj: DiscussObject) -> Void)?, cancelCallback: (() -> Void)?) {
        self.sendBirdDiscussChannelUrl = sendBirdDiscussChannelUrl
        self.accordingObject = accordingObj
        self.sendClickCallback = didSendCallback
        self.cancelClickCallback = cancelCallback
    }

}
