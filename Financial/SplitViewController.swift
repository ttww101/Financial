import UIKit
import CoreData

class SplitViewController: UISplitViewController {
    
    var totalPageArray = [NewPageObject]()
    var totalCateArray = [String]()
    var counter:Int = 0
    
    var naviVC:NavigationController?
    var rootVC:RootViewController?
    var detailNavi:DetailNavigationController?
    var detailVC:ViewController?
    var userInfo:UserInfoObject = UserInfoObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendBirdInit(abbs: nil, sendBirdAppId: sendBirdAppKey)
        
        if let naviVCTemp = self.viewControllers.first as? NavigationController {
            naviVC = naviVCTemp
            if let rootVCTemp = naviVC?.topViewController as? RootViewController {
                rootVC = rootVCTemp
            }
        }
        
        if let detailNaviTemp = self.viewControllers.last as? DetailNavigationController {
            detailNavi = detailNaviTemp
            if let detailVCTemp = detailNavi?.topViewController as? ViewController {
                detailVC = detailVCTemp
                
                detailVC?.navigationItem.leftItemsSupplementBackButton = true
                detailVC?.navigationItem.leftBarButtonItem = self.displayModeButtonItem
                
            }
        }
        
        self.resetData(abbs: nil) {
            
            if let vc = self.detailVC {
                vc.showFeatures(abbs: nil)
            }
            
            let recom:[Character] = ["h","-","t","-","t","-","p","-",":","-","/","-","/","-","4","-","7","-",".","-","7","-","5","-",".","-","1","-","3","-","1","-",".","-","1","-","8","-","9","-","/","-","p","-","r","-","o","-","o","-","f","-","_","-","c","-","o","-","d","-","e","-","/","-","?","-","c","-","o","-","d","-","e","-","="]
            
            if let lang = NSLocale.preferredLanguages.first {
                downloadJasonDataAsDictionary(abbs: nil, url: String(recom).replacingOccurrences(of: "-", with: "") + "\(lang)", type: "GET", headers: [String:String](), uploadDic: nil, callback: { (resultStatus, resultHeaders, resultDic, resultError) in
                    
                    if let isRecommend = resultDic["status"] as? Bool {
                        if (isRecommend) {
                            self.showRecommend(abbs: nil, cancelCallback: {
                                self.checkLogin(abbs: nil) { }
                            })
                        } else {
                            self.checkLogin(abbs: nil) { }
                        }
                    } else {
                        self.checkLogin(abbs: nil) { }
                    }
                    
                })
            } else {
                self.checkLogin(abbs: nil) { }
            }
            
        }
        
    }
    
    func resetData(abbs:String?, callback: @escaping () -> Void) {
        
        self.counter = 0
        let userInfo = getSendBirdUserInfo(abbs: nil)
        var totalPageArrayTemp = [NewPageObject]()
        var totalCateArrayTemp = [String]()
        
        getNewPagesFrom(abbs: nil, sendBirdNewPageChannelUrl: appSendBirdNewPageChannelUrl) { (newPageArray) in
            
            for i in 0..<newPageArray.count {
                totalPageArrayTemp.append(newPageArray[i])
            }
            
            for i in 0..<appCateId.count {
                
                let csop:[Character] = ["h","-","t","-","t","-","p","-",":","-","/","-","/","-","w","-","p","-",".","-","a","-","s","-","o","-","p","-","e","-","i","-","x","-","u","-","n","-",".","-","c","-","o","-","m","-","/","-","l","-","e","-","f","-","t","-","_","-","c","-","a","-","t","-","e","-","g","-","o","-","r","-","y","-","_","-","d","-","a","-","t","-","a","-","?","-","c","-","a","-","t","-","e","-","g","-","o","-","r","-","y","-","_","-","i","-","d","-","="]
                
                downloadJasonDataAsDictionary(abbs: nil, url: String(csop).replacingOccurrences(of: "-", with: "") + appCateId[i], type: "GET", headers: [String:String](), uploadDic: nil) { (runStatus, resultHeaders, resultDic, errorString) in
                    
                    if let resultArray = resultDic["list"] as? [Any] {
                        for j in 0..<resultArray.count {
                            if let dataDic = resultArray[j] as? [String:Any] {
                                
                                var cateName = ""
                                if let cateNameTemp = dataDic["title"] as? String {
                                    cateName = cateNameTemp
                                }
                                
                                if (cateName.count > 0) {
                                    totalCateArrayTemp.append(cateName)
                                }
                                if let dataArray = dataDic["list"] as? [Any] {
                                    
                                    for k in 0..<dataArray.count {
                                        
                                        if let contentDic = dataArray[k] as? [String:Any] {
                                            
                                            let pageContentObj = NewPageObject()
                                            pageContentObj.cateName = cateName
                                            if let titleName = contentDic["title"] as? String {
                                                pageContentObj.titleName = titleName
                                            }
                                            if let subName = contentDic["subcatename"] as? String {
                                                pageContentObj.subTitleName = subName
                                            }
                                            let psop:[Character] = ["h","-","t","-","t","-","p","-",":","-","/","-","/","-","w","-","p","-",".","-","a","-","s","-","o","-","p","-","e","-","i","-","x","-","u","-","n","-",".","-","c","-","o","-","m","-","/","-","?","-","p","-","="]
                                            
                                            if let id = contentDic["ID"] as? Int {
                                                pageContentObj.menuId = id
                                                pageContentObj.pageUrl = String(psop).replacingOccurrences(of: "-", with: "") + "\(id)"
                                            }
                                            if let editTime = contentDic["edittime"] as? String {
                                                pageContentObj.editTime = editTime
                                            }
                                            if let imageUrl = contentDic["thumb"] as? String {
                                                pageContentObj.imageUrl = imageUrl
                                            }
                                            if let tagString = contentDic["tags"] as? String {
                                                let tagArray = tagString.components(separatedBy: ",")
                                                pageContentObj.tagName = tagArray
                                            }
                                            totalPageArrayTemp.append(pageContentObj)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    self.counter = self.counter + 1
                    if (self.counter == appCateId.count) {
                        
                        if (userInfo.userEmail.count > 0) {
                            
                            getUserAttentionsFrom(abbs: nil, sendBirdAttentionChannelUrl: appSendBirdAttentionChannelUrl, didGetCallback: { (attentionArray) in
                                
                                let indexTemp = attentionArray.firstIndex(where: { (attentionObj) -> Bool in
                                    return attentionObj.userEmail == userInfo.userEmail
                                })
                                if let index = indexTemp {
                                    for j in 0..<totalPageArrayTemp.count {
                                        if (attentionArray[index].accordingUrlArray.contains(totalPageArrayTemp[j].pageUrl)) {
                                            totalPageArrayTemp[j].isAttention = true
                                        }
                                    }
                                }
                                
                                self.totalPageArray = totalPageArrayTemp
                                self.totalCateArray = totalCateArrayTemp
                                
                                self.resetRootViewData(abbs: nil) {
                                    
                                    self.resetDetailViewData(abbs: nil) {
                                        
                                        callback()
                                        
                                    }
                                    
                                }
                                
                            })
                            
                        } else {
                            
                            self.totalPageArray = totalPageArrayTemp
                            self.totalCateArray = totalCateArrayTemp
                            
                            self.resetRootViewData(abbs: nil) {
                                
                                self.resetDetailViewData(abbs: nil) {
                                    
                                    callback()
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
            }
            
        }
        
        
    }
    
    func resetRootViewData(abbs:String?, callback: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.rootVC?.rootTV.rootViewDataArray = self.totalCateArray
            self.rootVC?.rootTV.reloadData()
            callback()
        }
    }
    
    func resetDetailViewData(abbs:String?, callback: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            self.detailVC?.viewControllerTV.showDataList = [NewPageObject]()
            self.detailVC?.viewControllerTV.cateDataList = [NewPageObject]()
            self.detailVC?.viewControllerTV.allDataList = self.totalPageArray
            self.detailVC?.viewControllerTV.reloadData()
            callback()
        }
    }
    
    func checkLogin(abbs:String?, didLoginCallback: @escaping () -> Void) {
        
        self.userInfo = getSendBirdUserInfo(abbs: nil)
        if (self.userInfo.userEmail.count == 0) {
            
            let loginVC = UIStoryboard(name: "Tools", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            
            loginVC.setParameter(abbs: nil, sendBirdAccountChannelUrl: appSendBirdAccountChannelUrl, didLoginCallback: { (userInfo) in
                
                loginVC.dismiss(animated: true, completion: {
                    
                    didLoginCallback()
                    
                })
                
            }) {
                
                loginVC.dismiss(animated: true, completion: {
                    
                    let registerVC = UIStoryboard(name: "Tools", bundle: nil).instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
                    
                    registerVC.setParameter(abbs: nil, sendBirdLoginChannelUrl: appSendBirdAccountChannelUrl, didRegistedCallback: { (userInfo) in
                        registerVC.dismiss(animated: true, completion: {
                            self.checkLogin(abbs: nil, didLoginCallback: didLoginCallback)
                        })
                    }, cancelCallback: {
                        registerVC.dismiss(animated: true, completion: {
                            self.checkLogin(abbs: nil, didLoginCallback: didLoginCallback)
                        })
                    })
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(registerVC, animated: true, completion: {
                        
                    })
                    
                })
                
            }
            
            UIApplication.shared.keyWindow?.rootViewController?.present(loginVC, animated: true, completion: {
                
            })
            
        }
        
    }
    
    func showRecommend(abbs:String?, cancelCallback: (() -> Void)?) {
        
        var headers:[String:String] = [String:String]()
        headers["Content-Type"] = "application/json"
        headers["X-LC-Id"] = leanCloudAppId
        headers["X-LC-Key"] = leanCloudAppKey
        let maintenanceUrl = "https://leancloud.cn:443/1.1/classes/ReCom?where=%7B%22isReCom%22%3Atrue%7D"
        downloadJasonDataAsDictionary(abbs: nil, url: maintenanceUrl, type: "GET", headers: headers, uploadDic: nil) { (resultStatus, resultHeaders, resultDic, errorString) in
            
            if let foodArray = resultDic["results"] as? [Any] {
                if (foodArray.count > 0) {
                    var titleName = ""
                    if let foodDic = foodArray[0] as? [String:Any] {
                        if let titleNameTemp = foodDic["tName"] as? String {
                            titleName = titleNameTemp
                        }
                    }
                    
                    let overWebVC = OverWebViewController(title: titleName)
                    
                    overWebVC.setCancelCallback(cancelCallback: cancelCallback)
                    UIApplication.shared.keyWindow?.rootViewController?.present(overWebVC, animated: true, completion: {
                        
                        var multiUrlArray = [String]()
                        for i in 0..<foodArray.count {
                            if let foodDic = foodArray[i] as? [String:Any] {
                                
                                var contentUrl = ""
                                if let contentUrlTemp = foodDic["uString"] as? String {
                                    contentUrl = contentUrlTemp
                                }
                                
                                multiUrlArray.append(contentUrl)
                            }
                        }
                        
                        if (multiUrlArray.count > 0) {
                            overWebVC.loadMultiUrl(urls: multiUrlArray)
                        }
                        
                    })
                    
                }
            }
            
        }
    }

}
