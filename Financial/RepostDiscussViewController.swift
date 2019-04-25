import UIKit

class RepostDiscussViewController: KeyboardViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var repostTV: UITableView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var sendBirdDiscussChannelUrl:String = ""
    var sendBirdRepostChannelUrl:String = ""
    var discussId:Int = 0
    var userInfo:UserInfoObject = UserInfoObject()
    var discussObject:DiscussObject = DiscussObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendTextField.delegate = self
        
        repostTV.dataSource = self
        repostTV.delegate = self
        repostTV.contentInset = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)
        
        sendView.backgroundColor = appMainColor
        sendBtn.setTitleColor(appSubColor, for: UIControl.State.normal)
        sendBtn.addTarget(self, action: #selector(sendBtnClick), for: UIControl.Event.touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startIndicator(abbs: nil, currentVC: self) { (indicatorView) in
            self.resetData(abbs: nil, callback: {
                stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                    
                })
            })
        }
    }
    
    func resetData(abbs:String?, callback: @escaping () -> Void) {
        var discussObjectTemp = DiscussObject()
        getDiscussesFrom(abbs: nil, sendBirdDiscussChannelUrl: sendBirdDiscussChannelUrl) { (discussArray) in
            let indexTemp = discussArray.firstIndex(where: { (discussObj) -> Bool in
                return discussObj.discussId == self.discussId
            })
            if let index = indexTemp {
                discussObjectTemp = discussArray[index]
            }
            getRepostsFrom(abbs: nil, sendBirdRepostChannelUrl: self.sendBirdRepostChannelUrl, didGetCallback: { (repostArray) in
                for i in 0..<repostArray.count {
                    if (repostArray[i].discussId == discussObjectTemp.discussId) {
                        discussObjectTemp.repostArray.append(repostArray[i])
                    }
                }
                self.discussObject = discussObjectTemp
                self.repostTV.reloadData()
                callback()
            })
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussObject.repostArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repostDiscussTVCS", for: indexPath) as! RepostDiscussTableViewCellS
            
            cell.senderNicknameLabel.text = discussObject.repostArray[indexPath.row - 1].userNickname
            cell.tag = indexPath.row - 1
            if (discussObject.repostArray[indexPath.row - 1].userImageUrl.count > 0) {
                cell.senderImageView.isHidden = false
                downloadImage(abbs: nil, url: discussObject.repostArray[indexPath.row - 1].userImageUrl) { (image) in
                    if (cell.tag == (indexPath.row - 1)) {
                        cell.senderImageView.layer.cornerRadius = cell.senderImageView.frame.height / 2
                        cell.senderImageView.clipsToBounds = true
                        cell.senderImageView.image = image
                    }
                }
            } else {
                cell.senderImageView.isHidden = true
            }
            
            cell.contentLabel.text = discussObject.repostArray[indexPath.row - 1].content
            cell.dateLabel.text = discussObject.repostArray[indexPath.row - 1].date
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repostDiscussTVCM", for: indexPath) as! RepostDiscussTableViewCellM
            cell.senderNicknameLabel.text = discussObject.according.userNickname
            cell.tag = indexPath.row
            if (discussObject.according.userImageUrl.count > 0) {
                cell.senderImageView.isHidden = false
                downloadImage(abbs: nil, url: discussObject.according.userImageUrl) { (image) in
                    if (cell.tag == indexPath.row) {
                        cell.senderImageView.layer.cornerRadius = cell.senderImageView.frame.height / 2
                        cell.senderImageView.clipsToBounds = true
                        cell.senderImageView.image = image
                    }
                }
            } else {
                cell.senderImageView.isHidden = true
            }
            
            
            cell.subjectLabel.text = discussObject.subject
            
            cell.accordingTitleLabel.text = discussObject.according.accordingTitle
            cell.accordingSubTitleLabel.text = discussObject.according.accordingSubTitle
            if (discussObject.according.accordingImageUrl.count > 0) {
                cell.accordingImageView.isHidden = false
                downloadImage(abbs: nil, url: discussObject.according.accordingImageUrl) { (image) in
                    if (cell.tag == indexPath.row) {
                        cell.accordingImageView.layer.cornerRadius = cell.accordingImageView.frame.height / 2
                        cell.accordingImageView.clipsToBounds = true
                        cell.accordingImageView.image = image
                    }
                }
            } else {
                cell.accordingImageView.isHidden = true
            }
            
            cell.contentLabel.text = discussObject.content
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func sendBtnClick(sender:UIButton) {
        
        if (self.sendTextField.text!.count > 0) {
            
            startIndicator(abbs: nil, currentVC: self) { (indicatorView) in
                let repostObj = DiscussRepostObject()
                repostObj.discussId = self.discussId
                repostObj.userEmail = self.userInfo.userEmail
                repostObj.userNickname = self.userInfo.userNickname
                repostObj.userImageUrl = self.userInfo.userImageUrl
                repostObj.content = self.sendTextField.text!
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                repostObj.date = df.string(from: Date())
                
                sendRepostTo(abbs: nil, sendBirdRepostChannelUrl: self.sendBirdRepostChannelUrl, repostObject: repostObj, didSendCallback: {
                    
                    self.sendTextField.text = ""
                    
                    self.resetData(abbs: nil, callback: {
                        stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                            
                        })
                    })
                    
                })
            }
            
        }
        
    }
    
    func setParameter(abbs:String?, sendBirdDiscussChannelUrl: String, sendBirdRepostChannelUrl: String, discussId:Int, userInfo:UserInfoObject) {
        self.sendBirdDiscussChannelUrl = sendBirdDiscussChannelUrl
        self.sendBirdRepostChannelUrl = sendBirdRepostChannelUrl
        self.discussId = discussId
        self.userInfo = userInfo
    }
    
}
