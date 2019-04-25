
import UIKit
import Photos
import CoreData

class UserInfoViewController: UIViewController {

    @IBOutlet weak var userInfoTV: UserInfoTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人"
        
        userInfoTV.dataSource = userInfoTV.self
        userInfoTV.delegate = userInfoTV.self
        userInfoTV.vcInstance = self
        
        userInfoTV.userInfo = getSendBirdUserInfo(abbs: nil)
        
        self.userInfoTV.reloadData()
        
        var toolItems = [UIBarButtonItem]()
        toolItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
        let cancelBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 80, height: 80))
        cancelBtn.setTitle("关闭", for: UIControl.State.normal)
        cancelBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        cancelBtn.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
        cancelBtn.addTargetClosure { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        toolItems.append(UIBarButtonItem(customView: cancelBtn))
        
        self.toolbarItems = toolItems
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        requestPhotoAuth(abbs: nil)
    }

    func requestPhotoAuth(abbs:String?) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if (photoAuthorizationStatus == .notDetermined) {
            PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
                self.requestPhotoAuth(abbs: nil)
            }
        } else {
            if (photoAuthorizationStatus != .authorized) {
                
                let alertController = UIAlertController(title: "同意使用相簿",
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
