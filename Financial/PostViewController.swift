import UIKit
import Photos
import CoreData

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cateArrowImage: UIImageView!
    @IBOutlet weak var cateView: UIView!
    @IBOutlet weak var cateLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var tagTitleLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    
    
    var spinner:SimpleSpinner?
    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var subTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagAddBtn: UIButton!
    @IBOutlet weak var postImageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postImageBtn: UIButton!
    
    @IBOutlet weak var sendIndicatorView: UIView!
    @IBOutlet weak var sendIndicator: UIActivityIndicatorView!
    
    var nextMenuId = 0
    let imagePicker = UIImagePickerController()
    var imageLink:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "发布文章"
        
        cateLabel.text = "文章类别："
        mainLabel.text = "主要标题："
        subLabel.text = "副要标题："
        urlLabel.text = "网址连结："
        tagTitleLabel.text = "附加标签："
        imageLabel.text = "上传图片："
        
        cateLabel.textColor = appSubColor
        mainLabel.textColor = appSubColor
        subLabel.textColor = appSubColor
        urlLabel.textColor = appSubColor
        tagTitleLabel.textColor = appSubColor
        imageLabel.textColor = appSubColor
        tagAddBtn.backgroundColor = appSubColor
        cateArrowImage.image = getDownArrow(abbs: nil, imageSize: 50.0, color: appSubColor)
        if let spVC = self.splitViewController as? SplitViewController {
            if let rootVC = spVC.rootVC {
                spinner = SimpleSpinner()
                spinner!.createSpinner(abbs: nil, insideOfView: self.cateView, titleArray: rootVC.rootTV.rootViewDataArray, textAlignment: NSTextAlignment.left, dropTextAlignment: UIControl.ContentHorizontalAlignment.left, callback: { (position) in
                    
                })
            }
        }
        mainTextField.text = ""
        subTextField.text = ""
        urlTextField.text = ""
        tagLabel.text = ""
        tagAddBtn.addTargetClosure { (sender) in
            
            let controller = UIAlertController(title: "标签", message: "标签之间请用 ',' 逗号隔开", preferredStyle: .alert)
            controller.addTextField { (textField) in
                textField.placeholder = "请输入 标签1,标签2,标签3 ..."
                if (self.tagLabel.text!.count > 0) {
                    textField.text = self.tagLabel.text
                } else {
                    textField.text = ""
                }
            }
            let okAction = UIAlertAction(title: "确定", style: .default) { (_) in
                self.tagLabel.text = controller.textFields?[0].text
            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            self.present(controller, animated: true, completion: nil)
            
        }
        postImageView.image = nil
        postImageIndicator.isHidden = true
        postImageIndicator.stopAnimating()
        postImageBtn.addTargetClosure { (sender) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        imagePicker.delegate = self
        
        
        var toolItems = [UIBarButtonItem]()
        toolItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
        let cancelBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 80, height: 80))
        cancelBtn.setTitle("取消", for: UIControl.State.normal)
        cancelBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        cancelBtn.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
        cancelBtn.addTargetClosure { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        toolItems.append(UIBarButtonItem(customView: cancelBtn))
        
        let sendBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 80 , height: 80))
        sendBtn.setTitle("发布", for: UIControl.State.normal)
        sendBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        sendBtn.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
        sendBtn.addTargetClosure { (sender) in
            self.sendBtnClick()
        }
        toolItems.append(UIBarButtonItem(customView: sendBtn))
        
        self.toolbarItems = toolItems
        
        sendIndicatorView.backgroundColor = appMaskColor
        sendIndicatorView.isHidden = true
        sendIndicator.stopAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let spVC = self.splitViewController as? SplitViewController {
            self.nextMenuId = 0
            for i in 0..<spVC.totalPageArray.count {
                if (spVC.totalPageArray[i].menuId > self.nextMenuId) {
                    self.nextMenuId = spVC.totalPageArray[i].menuId
                }
            }
            self.nextMenuId = self.nextMenuId + 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        requestPhotoAuth(abbs: nil)
        
    }
    
    func sendBtnClick() {
        if (self.imageLink.count > 0) {
            if (URL(string: self.imageLink) != nil) {
                if (self.urlTextField.text!.count > 0) {
                    if (URL(string: self.urlTextField.text!) != nil) {
                        if (self.spinner!.spinnerDefaultItemPosition >= 0) {
                            if (mainTextField.text!.count > 0) {
                                if (subTextField.text!.count > 0) {
                                    
                                    if let spVC = self.splitViewController as? SplitViewController {
                                        if let rootVC = spVC.rootVC {
                                            
                                            let newPageObj = NewPageObject()
                                            newPageObj.userNickname = getSendBirdUserInfo(abbs: nil).userNickname
                                            newPageObj.userEmail = getSendBirdUserInfo(abbs: nil).userEmail
                                            newPageObj.userImageUrl = getSendBirdUserInfo(abbs: nil).userImageUrl
                                            newPageObj.cateName = rootVC.rootTV.rootViewDataArray[self.spinner!.spinnerDefaultItemPosition]
                                            newPageObj.titleName = self.mainTextField.text!
                                            newPageObj.subTitleName = self.subTextField.text!
                                            newPageObj.imageUrl = self.imageLink
                                            let df = DateFormatter()
                                            df.dateFormat = "yyyy-MM-dd"
                                            df.string(from: Date())
                                            newPageObj.editTime = df.string(from: Date())
                                            newPageObj.menuId = self.nextMenuId
                                            newPageObj.pageUrl = self.urlTextField.text!
                                            let tagArray = self.tagLabel.text!.components(separatedBy: ",")
                                            newPageObj.tagName = tagArray
                                            sendNewPageTo(abbs: nil, sendBirdNewPageChannelUrl: appSendBirdNewPageChannelUrl, newPageObject: newPageObj) {
                                                
                                                spVC.resetData(abbs: nil) {
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.postImageIndicator.startAnimating()
            self.postImageIndicator.isHidden = false
            uploadImageGetLink(abbs: nil, image: pickedImage) { (imageLink) in
                self.postImageIndicator.isHidden = true
                self.postImageIndicator.stopAnimating()
                self.imageLink = imageLink
                if (self.imageLink.count > 0) {
                    self.postImageIndicator.startAnimating()
                    self.postImageIndicator.isHidden = false
                    downloadImage(abbs: nil, url: self.imageLink) { (image) in
                        self.postImageIndicator.isHidden = true
                        self.postImageIndicator.stopAnimating()
                        self.postImageViewHeight.constant = self.postImageView.frame.width * image!.size.height / image!.size.width
                        self.postImageView.image = image
                    }
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }

}
