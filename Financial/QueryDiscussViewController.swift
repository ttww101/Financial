import UIKit

class QueryDiscussViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var discussTV: UITableView!
    
    var sendBirdDiscussChannelUrl:String = ""
    var sendBirdRepostChannelUrl:String = ""
    var sendBirdLikeChannelUrl:String = ""
    var userInfo:UserInfoObject = UserInfoObject()
    var discussArray = [DiscussObject]()

    var accordingClickCallback:((_ discuss:DiscussObject) -> Void)?
    var repostClickCallback:((_ discuss:DiscussObject) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        discussTV.dataSource = self
        discussTV.delegate = self
        discussTV.contentInset = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)
        
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
        
        getDiscussesFrom(abbs: nil, sendBirdDiscussChannelUrl: self.sendBirdDiscussChannelUrl) { (discussArray) in
            
            getRepostsFrom(abbs: nil, sendBirdRepostChannelUrl: self.sendBirdRepostChannelUrl, didGetCallback: { (repostArray) in
                for i in 0..<repostArray.count {
                    let discussIndexTemp = discussArray.firstIndex(where: { (discussObj) -> Bool in
                        return discussObj.discussId == repostArray[i].discussId
                    })
                    if let discussIndex = discussIndexTemp {
                        discussArray[discussIndex].repostArray.append(repostArray[i])
                    }
                }
                
                getLikesFrom(abbs: nil, sendBirdLikeChannelUrl: self.sendBirdLikeChannelUrl, didGetCallback: { (likeArray) in
                    for j in 0..<likeArray.count {
                        let discussIndexTemp = discussArray.firstIndex(where: { (discussObj) -> Bool in
                            return discussObj.discussId == likeArray[j].discussId
                        })
                        if let discussIndex = discussIndexTemp {
                            discussArray[discussIndex].like = likeArray[j]
                        }
                    }
                    
                    self.discussArray = discussArray
                    self.discussTV.reloadData()
                    callback()
                    
                })
            })
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "queryDiscussTVC", for: indexPath) as! QueryDiscussTableViewCell
        
        cell.senderNicknameLabel.text = self.discussArray[indexPath.row].according.userNickname
        cell.tag = indexPath.row
        if (self.discussArray[indexPath.row].according.userImageUrl.count > 0) {
            cell.senderImageView.isHidden = false
            downloadImage(abbs: nil, url: self.discussArray[indexPath.row].according.userImageUrl) { (image) in
                if (cell.tag == indexPath.row) {
                    cell.senderImageView.layer.cornerRadius = cell.senderImageView.frame.height / 2
                    cell.senderImageView.clipsToBounds = true
                    cell.senderImageView.image = image
                }
            }
        } else {
            cell.senderImageView.isHidden = true
        }
        
        
        cell.subjectLabel.text = self.discussArray[indexPath.row].subject
        
        cell.accordingTitleLabel.text = self.discussArray[indexPath.row].according.accordingTitle
        cell.accordingSubTitleLabel.text = self.discussArray[indexPath.row].according.accordingSubTitle
        if (self.discussArray[indexPath.row].according.accordingImageUrl.count > 0) {
            cell.accordingImageView.isHidden = false
            downloadImage(abbs: nil, url: self.discussArray[indexPath.row].according.accordingImageUrl) { (image) in
                if (cell.tag == indexPath.row) {
                    cell.accordingImageView.layer.cornerRadius = cell.accordingImageView.frame.height / 2
                    cell.accordingImageView.clipsToBounds = true
                    cell.accordingImageView.image = image
                }
            }
        } else {
            cell.accordingImageView.isHidden = true
        }
        
        cell.contentLabel.text = self.discussArray[indexPath.row].content
        cell.dateLabel.text = self.discussArray[indexPath.row].date
        
        cell.repostBtn.setTitle("留言 \(self.discussArray[indexPath.row].repostArray.count)", for: UIControl.State.normal)
        cell.likeBtn.setTitle("赞 \(self.discussArray[indexPath.row].like.userInfoArray.count)", for: UIControl.State.normal)
        
        cell.accordingSelectBtn.tag = indexPath.row
        cell.accordingSelectBtn.addTarget(self, action: #selector(accordingBtnClick), for: UIControl.Event.touchUpInside)
        cell.repostBtn.tag = indexPath.row
        cell.repostBtn.addTarget(self, action: #selector(repostBtnClick), for: UIControl.Event.touchUpInside)
        cell.likeBtn.tag = indexPath.row
        cell.likeBtn.addTarget(self, action: #selector(likeBtnClick), for: UIControl.Event.touchUpInside)
        
        cell.layoutIfNeeded()
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func accordingBtnClick(sender:UIButton) {
        if (accordingClickCallback != nil) {
            accordingClickCallback!(self.discussArray[sender.tag])
        }
    }
    
    @objc func repostBtnClick(sender:UIButton) {
        if (repostClickCallback != nil) {
            repostClickCallback!(self.discussArray[sender.tag])
        }
    }
    
    @objc func likeBtnClick(sender:UIButton) {
        startIndicator(abbs: nil, currentVC: self) { (indicatorView) in
            let isContains = self.discussArray[sender.tag].like.userInfoArray.contains { (userInfo) -> Bool in
                return userInfo.userEmail == self.userInfo.userEmail
            }
            
            if (!isContains) {
                self.discussArray[sender.tag].like.userInfoArray.append(self.userInfo)
                sendLikeTo(abbs: nil, sendBirdLikeChannelUrl: self.sendBirdLikeChannelUrl, likeObject: self.discussArray[sender.tag].like) {
                    self.discussTV.reloadData()
                    stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                        
                    })
                }
            } else {
                stopIndicator(abbs: nil, indicatorView: indicatorView, callback: {
                    
                })
            }
        }
        
    }
    
    
    func setRepostCallback(abbs:String?, clickCallback: ((_ discuss:DiscussObject) -> Void)?) {
        self.repostClickCallback = clickCallback
    }
    
    func setParameter(abbs:String?, sendBirdDiscussChannelUrl: String, sendBirdRepostChannelUrl: String, sendBirdLikeChannelUrl: String, userInfo:UserInfoObject, accordingCallback: ((_ discuss:DiscussObject) -> Void)?, repostCallback: ((_ discuss:DiscussObject) -> Void)?) {
        self.sendBirdDiscussChannelUrl = sendBirdDiscussChannelUrl
        self.sendBirdRepostChannelUrl = sendBirdRepostChannelUrl
        self.sendBirdLikeChannelUrl = sendBirdLikeChannelUrl
        self.repostClickCallback = repostCallback
        self.accordingClickCallback = accordingCallback
    }

}
