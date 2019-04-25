import UIKit
import CoreData

class ViewController: UIViewController, UISearchResultsUpdating  {
    
    @IBOutlet weak var currencyMainView: UIView!
    @IBOutlet weak var currencyTitleLabel: UILabel!
    @IBOutlet weak var currencyFromView: UIView!
    @IBOutlet weak var currencyDescLabel1: UILabel!
    @IBOutlet weak var currencyToView: UIView!
    @IBOutlet weak var currencyDescLabel2: UILabel!
    @IBOutlet weak var currencyInputTextField: UITextField!
    @IBOutlet weak var currencyStartBtn: UIButton!
    @IBOutlet weak var currencyResultTitleView: UIView!
    @IBOutlet weak var currencyResultTitleLabel: UILabel!
    @IBOutlet weak var currencyResultLabelMain: UILabel!
    @IBOutlet weak var currencyResultLabelSub: UILabel!
    var currencyFromSpinner:SimpleSpinner?
    var currencyToSpinner:SimpleSpinner?
    var currencyObjectArray = [CurrencyObject]()
    var currencyNameArray = [String]()
    var currencyFromNameArray = [String]()
    var currencyToNameArray = [String]()
    
    @IBOutlet weak var sphereContentView: UIView!
    var sphereView:AASphereView?
    
    @IBOutlet weak var viewControllerTV: ViewControllerTableView!
    
    @IBOutlet weak var noneLabel: UILabel!
    
    var searchController:UISearchController!
    
    let homeName = "首页"
    let featuresName = "换汇计算机"
    let attentionName = "关注"
    let postName = "发文"
    let commentName = "评论"
    let userInfoName = "个人"
    let noneAttentionName = "您没关注任何文章"
    let searchPlaceholderName = "请输入关键字..."
    let searchBarBgColor:UIColor = UIColor.clear
    let searchBarTextColor:UIColor = UIColor.white
    let searchBarButtonColor:UIColor = UIColor.white
    
    var selectCateName = ""
    var toolbarSelectIndex = 3
    var userInfo = UserInfoObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyTitleLabel.textColor = appSubColor
        currencyDescLabel1.textColor = appSubColor
        currencyDescLabel2.textColor = appSubColor
        currencyStartBtn.layer.backgroundColor = appSubColor.cgColor
        currencyStartBtn.layer.cornerRadius = 22
        currencyStartBtn.clipsToBounds = true
        currencyResultTitleView.backgroundColor = appSubColor
        currencyResultLabelMain.textColor = appSubColor
        currencyInputTextField.text = ""
        currencyResultTitleLabel.text = "計算結果"
        currencyResultLabelMain.text = ""
        currencyResultLabelSub.text = ""
        
        self.title = featuresName
        
        viewControllerTV.contentInset = UIEdgeInsets(top: CGFloat(5), left: CGFloat(0), bottom: CGFloat(5), right: CGFloat(0))
        viewControllerTV.dataSource = viewControllerTV.self
        viewControllerTV.delegate = viewControllerTV.self
        viewControllerTV.vcInstance = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = searchBarButtonColor
        searchController.searchBar.backgroundColor = searchBarBgColor
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor : searchBarTextColor]
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchPlaceholderName
        searchController.searchBar.sizeToFit()
        navigationItem.searchController = searchController
        self.navigationController?.definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.toolbar.barTintColor = self.navigationController?.navigationBar.barTintColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let toolbarHeight = self.navigationController?.toolbar.frame.size.height {
            if let toobarWidth = self.navigationController?.toolbar.frame.size.width {
                var toolItems = [UIBarButtonItem]()
                
                toolItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
                
                let homeBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: (toobarWidth - 20) / 5, height: toolbarHeight))
                homeBtn.setTitle(homeName, for: UIControl.State.normal)
                homeBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                homeBtn.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
                homeBtn.addTargetClosure { (sender) in
                    self.showFeatures(abbs: nil)
                }
                toolItems.append(UIBarButtonItem(customView: homeBtn))
                
                let attentionBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: (toobarWidth - 20) / 5, height: toolbarHeight))
                attentionBtn.setTitle(attentionName, for: UIControl.State.normal)
                attentionBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                attentionBtn.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
                attentionBtn.addTargetClosure { (sender) in
                    self.showAttention(abbs: nil)
                }
                toolItems.append(UIBarButtonItem(customView: attentionBtn))
                
                let postBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: (toobarWidth - 20) / 5, height: toolbarHeight))
                postBtn.setTitle(postName, for: UIControl.State.normal)
                postBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                postBtn.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
                postBtn.addTargetClosure { (sender) in
                    self.showPost(abbs: nil)
                }
                toolItems.append(UIBarButtonItem(customView: postBtn))
                
                let commentBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: (toobarWidth - 20) / 5, height: toolbarHeight))
                commentBtn.setTitle(commentName, for: UIControl.State.normal)
                commentBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                commentBtn.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
                commentBtn.addTargetClosure { (sender) in
                    self.showComment(abbs: nil)
                }
                toolItems.append(UIBarButtonItem(customView: commentBtn))
                
                let userInfoBtn = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: (toobarWidth - 20) / 5, height: toolbarHeight))
                userInfoBtn.setTitle(userInfoName, for: UIControl.State.normal)
                userInfoBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                userInfoBtn.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
                userInfoBtn.addTargetClosure { (sender) in
                    self.showUserInfo(abbs: nil)
                }
                toolItems.append(UIBarButtonItem(customView: userInfoBtn))
                
                toolItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
                
                self.toolbarItems = toolItems
            }
        }
        
        if (self.toolbarSelectIndex == 0) {
            self.showSphere(abbs: nil)
        } else if (self.toolbarSelectIndex == 1) {
            self.showAttention(abbs: nil)
        } else if (self.toolbarSelectIndex == 2) {
            self.updateCateSelect(abbs: nil)
        } else if (self.toolbarSelectIndex == 3) {
            self.showFeatures(abbs: nil)
        }
        
    }
    
    func resetSphereView(abbs:String?) {
        
        if (sphereView != nil) {
            sphereView!.removeFromSuperview()
            sphereView = nil
        }
        sphereView = AASphereView.init(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        sphereContentView.addSubview(sphereView!)
        sphereView!.translatesAutoresizingMaskIntoConstraints = false
        sphereContentView.addConstraints([NSLayoutConstraint(item: sphereView!,
                                                             attribute: .trailing,
                                                             relatedBy: .equal,
                                                             toItem: sphereContentView,
                                                             attribute: .trailing,
                                                             multiplier: 1.0,
                                                             constant: -10.0),
                                          NSLayoutConstraint(item: sphereView!,
                                                             attribute: .leading,
                                                             relatedBy: .equal,
                                                             toItem: sphereContentView,
                                                             attribute: .leading,
                                                             multiplier: 1.0,
                                                             constant: 10.0),
                                          NSLayoutConstraint(item: sphereView!,
                                                             attribute: .centerY,
                                                             relatedBy: .equal,
                                                             toItem: sphereContentView,
                                                             attribute: .centerY,
                                                             multiplier: 1.0,
                                                             constant: 0.0),
                                          NSLayoutConstraint(item: sphereView!,
                                                             attribute: .height,
                                                             relatedBy: .equal,
                                                             toItem: sphereView,
                                                             attribute: .width,
                                                             multiplier: 1.0,
                                                             constant: 0.0)])
        
    }
    
    var isSpinnerInit = false
    func showFeatures(abbs:String?) {
        
        self.title = featuresName
        self.toolbarSelectIndex = 3
        self.viewControllerTV.isHidden = true
        self.noneLabel.isHidden = true
        self.sphereContentView.isHidden = true
        self.currencyMainView.isHidden = false
        if (currencyFromSpinner != nil) {
            currencyFromSpinner!.removeSpinner(abbs: nil)
        }
        if (currencyToSpinner != nil) {
            currencyToSpinner!.removeSpinner(abbs: nil)
        }
        currencyInputTextField.text = ""
        currencyResultTitleLabel.text = "計算結果"
        currencyResultLabelMain.text = ""
        currencyResultLabelSub.text = ""
        
        currencyObjectArray = [CurrencyObject]()
        currencyNameArray = [String]()
        currencyFromNameArray = [String]()
        currencyToNameArray = [String]()
        
        isSpinnerInit = true
        getCurrencyObjectArray(abbs: nil) { (currencyObjArray) in
            self.currencyObjectArray = currencyObjArray
            for i in 0..<self.currencyObjectArray.count {
                self.currencyNameArray.append(self.currencyObjectArray[i].id + " " + getCurrencyNameCn(abbs: nil, id: self.currencyObjectArray[i].id))
            }
            self.currencyFromNameArray = self.currencyNameArray
            self.currencyFromSpinner = SimpleSpinner()
            self.currencyFromSpinner!.createSpinner(abbs: nil, insideOfView: self.currencyFromView, titleArray: self.currencyFromNameArray, textAlignment: NSTextAlignment.center, dropTextAlignment: UIControl.ContentHorizontalAlignment.left, callback: { (position) in
                
                if (self.isSpinnerInit) {
                    self.isSpinnerInit = false
                    self.currencyFromSpinner!.setSelection(abbs: nil, position: 22, completion: {
                        
                    })
                } else {
                    self.currencyInputTextField.text = ""
                    self.currencyResultTitleLabel.text = "計算結果"
                    self.currencyResultLabelMain.text = ""
                    self.currencyResultLabelSub.text = ""
                    
                    if (self.currencyToSpinner != nil) {
                        self.currencyToSpinner!.removeSpinner(abbs: nil)
                    }
                    self.currencyToNameArray = [String]()
                    for i in 0..<self.currencyFromNameArray.count {
                        if (i != position) {
                            self.currencyToNameArray.append(self.currencyFromNameArray[i])
                        }
                    }
                    self.currencyToSpinner = SimpleSpinner()
                    self.currencyToSpinner?.createSpinner(abbs: nil, insideOfView: self.currencyToView, titleArray: self.currencyToNameArray, textAlignment: NSTextAlignment.center, dropTextAlignment: UIControl.ContentHorizontalAlignment.left, callback: { (toPosition) in
                        
                        self.currencyInputTextField.text = ""
                        self.currencyResultTitleLabel.text = "計算結果"
                        self.currencyResultLabelMain.text = ""
                        self.currencyResultLabelSub.text = ""
                        
                    })
                }
                
            })
        }
        
        currencyStartBtn.addTargetClosure { (sender) in
            if (self.currencyFromSpinner != nil) {
                if (self.currencyToSpinner != nil) {
                    if (self.currencyFromSpinner!.spinnerDefaultItemPosition >= 0) {
                        if (self.currencyToSpinner!.spinnerDefaultItemPosition >= 0) {
                            if let valueText = self.currencyInputTextField.text {
                                if let valueDouble = Double(valueText) {
                                    let fromObjIndex = self.currencyFromSpinner!.spinnerDefaultItemPosition
                                    var toObjIndex = self.currencyToSpinner!.spinnerDefaultItemPosition
                                    if (toObjIndex >= fromObjIndex) {
                                        toObjIndex = toObjIndex + 1
                                    }
                                    let fromConName = getCurrencyNameCn(abbs: nil, id: self.currencyObjectArray[fromObjIndex].id)
                                    let toConName = getCurrencyNameCn(abbs: nil, id: self.currencyObjectArray[toObjIndex].id)
                                    self.currencyResultTitleLabel.text = fromConName + " 兑换 " + toConName + " 計算結果"
                                    getCurrencyValue(abbs: nil, fromCurrencyId: self.currencyObjectArray[fromObjIndex].id, toCurrencyId: self.currencyObjectArray[toObjIndex].id, callback: { (currencyPer) in
                                        if let per = currencyPer {
                                            let formatter = NumberFormatter()
                                            formatter.maximumFractionDigits = 2
                                            if let valueString = formatter.string(from: NSNumber(value: valueDouble*per)) {
                                                self.currencyResultLabelMain.text = toConName + " : " + self.currencyObjectArray[toObjIndex].currencySymbol + " " + valueString
                                            }
                                            
                                            self.currencyResultLabelSub.text = "汇率 : \(per)"
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func showSphere(abbs:String?) {
        
        self.title = homeName
        self.toolbarSelectIndex = 0
        self.currencyMainView.isHidden = true
        self.viewControllerTV.isHidden = true
        self.noneLabel.isHidden = true
        self.sphereContentView.isHidden = false
        self.viewControllerTV.cateDataList = [NewPageObject]()
        for i in 0..<self.viewControllerTV.allDataList.count {
            self.viewControllerTV.cateDataList.append(self.viewControllerTV.allDataList[i])
        }
        
        self.searchController.isActive = false
        
        if (self.isFiltering()) {
            
            self.resetSphereView(abbs: nil)
            var tags = [UIView]()
            var displaySize = 60
            if (self.viewControllerTV.showDataList.count < 60) {
                displaySize = self.viewControllerTV.showDataList.count
            }
            for i in 0..<displaySize {
                let button = UIButton.init()
                button.backgroundColor = appSubTransColor
                button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
                button.setTitle(self.viewControllerTV.showDataList[i].titleName, for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.tag = i
                button.addTargetClosure(closure: { (sender) in
                    
                    let overWebVC = OverWebViewController()
                    UIApplication.shared.keyWindow?.rootViewController?.present(overWebVC, animated: true, completion: {
                        
                        let accObj = DiscussAccordingObject()
                        accObj.accordingTitle = self.viewControllerTV.showDataList[sender.tag].titleName
                        accObj.accordingSubTitle = self.viewControllerTV.showDataList[sender.tag].subTitleName
                        accObj.accordingImageUrl = self.viewControllerTV.showDataList[sender.tag].imageUrl
                        accObj.accordingUrl = self.viewControllerTV.showDataList[sender.tag].pageUrl
                        
                        overWebVC.loadTitleUrl(abbs: nil, accordingObj: accObj)
                        
                    })
                    
                })
                button.sizeToFit()
                tags.append(button)
                
            }
            self.sphereView!.setTagViews(abbs: nil, array: tags)
            
        } else {
            
            self.resetSphereView(abbs: nil)
            var tags = [UIView]()
            var displaySize = 60
            if (self.viewControllerTV.cateDataList.count < 60) {
                displaySize = self.viewControllerTV.cateDataList.count
            }
            for i in 0..<displaySize {
                let button = UIButton.init()
                button.backgroundColor = appSubTransColor
                button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
                button.setTitle(self.viewControllerTV.cateDataList[i].titleName, for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.tag = i
                button.addTargetClosure(closure: { (sender) in
                    
                    let overWebVC = OverWebViewController()
                    UIApplication.shared.keyWindow?.rootViewController?.present(overWebVC, animated: true, completion: {
                        
                        let accObj = DiscussAccordingObject()
                        accObj.accordingTitle = self.viewControllerTV.cateDataList[sender.tag].titleName
                        accObj.accordingSubTitle = self.viewControllerTV.cateDataList[sender.tag].subTitleName
                        accObj.accordingImageUrl = self.viewControllerTV.cateDataList[sender.tag].imageUrl
                        accObj.accordingUrl = self.viewControllerTV.cateDataList[sender.tag].pageUrl
                        
                        overWebVC.loadTitleUrl(abbs: nil, accordingObj: accObj)
                    })
                    
                })
                button.sizeToFit()
                tags.append(button)
                
            }
            self.sphereView!.setTagViews(abbs: nil, array: tags)
            
        }
        
        
    }
    
    func showAttention(abbs:String?) {
        self.title = attentionName
        self.toolbarSelectIndex = 1
        self.currencyMainView.isHidden = true
        self.sphereContentView.isHidden = true
        self.viewControllerTV.isHidden = false
        self.noneLabel.isHidden = true
        
        self.searchController.isActive = false
        
        self.viewControllerTV.cateDataList = [NewPageObject]()
        for i in 0..<self.viewControllerTV.allDataList.count {
            if (self.viewControllerTV.allDataList[i].isAttention) {
                self.viewControllerTV.cateDataList.append(self.viewControllerTV.allDataList[i])
            }
        }
        
        if (self.viewControllerTV.cateDataList.count > 0) {
            self.viewControllerTV.isHidden = false
            self.noneLabel.isHidden = true
        } else {
            self.noneLabel.text = noneAttentionName
            self.viewControllerTV.isHidden = true
            self.noneLabel.isHidden = false
        }
        
        self.viewControllerTV.reloadData()
    }
    
    func showPost(abbs:String?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "postVC") as! PostViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func showComment(abbs:String?) {
        
        let discussVC = UIStoryboard(name: "Tools", bundle: nil).instantiateViewController(withIdentifier: "queryDiscussVC") as! QueryDiscussViewController
        
        discussVC.setParameter(abbs: nil, sendBirdDiscussChannelUrl: appSendBirdDiscussChannelUrl, sendBirdRepostChannelUrl: appSendBirdRepostChannelUrl, sendBirdLikeChannelUrl: appSendBirdLikeChannelUrl, userInfo: getSendBirdUserInfo(abbs: nil), accordingCallback: { (discussObj) in
            // according
            let overWebVC = OverWebViewController()
            UIApplication.shared.keyWindow?.rootViewController?.present(overWebVC, animated: true, completion: {
                
                overWebVC.loadTitleUrl(abbs: nil, accordingObj: discussObj.according)
                
            })
            
        }) { (discussObj) in
            // repost
            let repostVC = UIStoryboard(name: "Tools", bundle: nil).instantiateViewController(withIdentifier: "repostDiscussVC") as! RepostDiscussViewController
            
            repostVC.setParameter(abbs: nil,sendBirdDiscussChannelUrl: appSendBirdDiscussChannelUrl, sendBirdRepostChannelUrl: appSendBirdRepostChannelUrl, discussId: discussObj.discussId, userInfo: getSendBirdUserInfo(abbs: nil))
            
            discussVC.navigationController?.pushViewController(repostVC, animated: true)
        }
        
        self.navigationController?.pushViewController(discussVC, animated: true)
        
    }
    
    func showUserInfo(abbs:String?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "userInfoVC") as! UserInfoViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func updateCateSelect(abbs:String?) {
        self.title = self.selectCateName
        self.toolbarSelectIndex = 2
        if let spVC = self.navigationController?.splitViewController as? SplitViewController {
            if let rootVC = spVC.rootVC {
                if (rootVC.rootTV.rootViewDataArray.count > 0) {
                    self.currencyMainView.isHidden = true
                    self.sphereContentView.isHidden = true
                    self.viewControllerTV.isHidden = false
                    self.viewControllerTV.cateDataList = [NewPageObject]()
                    for i in 0..<self.viewControllerTV.allDataList.count {
                        if (self.viewControllerTV.allDataList[i].cateName == self.selectCateName) {
                            self.viewControllerTV.cateDataList.append(self.viewControllerTV.allDataList[i])
                        }
                    }
                    self.viewControllerTV.reloadData()
                } else {
                    self.currencyMainView.isHidden = true
                    self.sphereContentView.isHidden = true
                    self.viewControllerTV.isHidden = false
                    self.viewControllerTV.cateDataList = [NewPageObject]()
                    for i in 0..<self.viewControllerTV.allDataList.count {
                        if (self.viewControllerTV.allDataList[i].cateName == self.selectCateName) {
                            self.viewControllerTV.cateDataList.append(self.viewControllerTV.allDataList[i])
                        }
                    }
                    self.viewControllerTV.reloadData()
                }
            } else {
                self.currencyMainView.isHidden = true
                self.sphereContentView.isHidden = true
                self.viewControllerTV.isHidden = false
                self.viewControllerTV.cateDataList = [NewPageObject]()
                for i in 0..<self.viewControllerTV.allDataList.count {
                    if (self.viewControllerTV.allDataList[i].cateName == self.selectCateName) {
                        self.viewControllerTV.cateDataList.append(self.viewControllerTV.allDataList[i])
                    }
                }
                self.viewControllerTV.reloadData()
            }
        } else {
            self.currencyMainView.isHidden = true
            self.sphereContentView.isHidden = true
            self.viewControllerTV.isHidden = false
            self.viewControllerTV.cateDataList = [NewPageObject]()
            for i in 0..<self.viewControllerTV.allDataList.count {
                if (self.viewControllerTV.allDataList[i].cateName == self.selectCateName) {
                    self.viewControllerTV.cateDataList.append(self.viewControllerTV.allDataList[i])
                }
            }
            self.viewControllerTV.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.viewControllerTV.showDataList = self.viewControllerTV.cateDataList.filter({( pageContentObj : NewPageObject) -> Bool in
            var isContains = false
            if (pageContentObj.cateName.lowercased().contains(searchController.searchBar.text!.lowercased())) {
                isContains = true
            }
            if (pageContentObj.titleName.lowercased().contains(searchController.searchBar.text!.lowercased())) {
                isContains = true
            }
            if (pageContentObj.subTitleName.lowercased().contains(searchController.searchBar.text!.lowercased())) {
                isContains = true
            }
            for i in 0..<pageContentObj.tagName.count {
                if (pageContentObj.tagName[i].lowercased().contains(searchController.searchBar.text!.lowercased())) {
                    isContains = true
                }
            }
            return isContains
        })
        
        if (self.isFiltering()) {
            
            self.resetSphereView(abbs: nil)
            var tags = [UIView]()
            var displaySize = 60
            if (self.viewControllerTV.showDataList.count < 60) {
                displaySize = self.viewControllerTV.showDataList.count
            }
            for i in 0..<displaySize {
                let button = UIButton.init()
                button.backgroundColor = appSubTransColor
                button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
                button.setTitle(self.viewControllerTV.showDataList[i].titleName, for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.tag = i
                button.addTargetClosure(closure: { (sender) in
                    
                    let overWebVC = OverWebViewController()
                    UIApplication.shared.keyWindow?.rootViewController?.present(overWebVC, animated: true, completion: {
                        
                        let accObj = DiscussAccordingObject()
                        accObj.accordingTitle = self.viewControllerTV.showDataList[sender.tag].titleName
                        accObj.accordingSubTitle = self.viewControllerTV.showDataList[sender.tag].subTitleName
                        accObj.accordingImageUrl = self.viewControllerTV.showDataList[sender.tag].imageUrl
                        accObj.accordingUrl = self.viewControllerTV.showDataList[sender.tag].pageUrl
                        
                        overWebVC.loadTitleUrl(abbs: nil, accordingObj: accObj)
                        
                    })
                    
                })
                button.sizeToFit()
                tags.append(button)
                
            }
            self.sphereView!.setTagViews(abbs: nil, array: tags)
            
        } else {
            
            self.resetSphereView(abbs: nil)
            var tags = [UIView]()
            var displaySize = 60
            if (self.viewControllerTV.cateDataList.count < 60) {
                displaySize = self.viewControllerTV.cateDataList.count
            }
            for i in 0..<displaySize {
                let button = UIButton.init()
                button.backgroundColor = appSubTransColor
                button.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
                button.setTitle(self.viewControllerTV.cateDataList[i].titleName, for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.tag = i
                button.addTargetClosure(closure: { (sender) in
                    
                    let overWebVC = OverWebViewController()
                    UIApplication.shared.keyWindow?.rootViewController?.present(overWebVC, animated: true, completion: {
                        
                        let accObj = DiscussAccordingObject()
                        accObj.accordingTitle = self.viewControllerTV.cateDataList[sender.tag].titleName
                        accObj.accordingSubTitle = self.viewControllerTV.cateDataList[sender.tag].subTitleName
                        accObj.accordingImageUrl = self.viewControllerTV.cateDataList[sender.tag].imageUrl
                        accObj.accordingUrl = self.viewControllerTV.cateDataList[sender.tag].pageUrl
                        
                        overWebVC.loadTitleUrl(abbs: nil, accordingObj: accObj)
                        
                    })
                    
                })
                button.sizeToFit()
                tags.append(button)
                
            }
            self.sphereView!.setTagViews(abbs: nil, array: tags)
            
        }
        
        self.viewControllerTV.reloadData()
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

