
import Foundation
import UIKit
import CoreData
import Alamofire
import SendBirdSDK

func sendBirdInit(abbs:String?, sendBirdAppId: String) {
    SBDMain.initWithApplicationId(sendBirdAppId)
}

func sendMessageTo(abbs:String?, sendBirdChannelUrl:String, userId:String, messageDic:[String:Any], didSendCallback: @escaping (_ status:Bool) -> Void) {
    
    SBDMain.connect(withUserId: userId) { (user, error) in
        guard error == nil else {
            didSendCallback(false)
            return
        }
        SBDOpenChannel.getWithUrl(sendBirdChannelUrl) { (channel, error) in
            guard error == nil else {
                didSendCallback(false)
                return
            }
            do {
                let uploadData = try JSONSerialization.data(withJSONObject: messageDic, options: JSONSerialization.WritingOptions())
                let uploadString = String(data: uploadData, encoding: String.Encoding.utf8)
                channel?.enter(completionHandler: { (error) in
                    guard error == nil else {
                        didSendCallback(false)
                        return
                    }
                    channel?.sendUserMessage(uploadString, completionHandler: { (message, error) in
                        guard error == nil else {
                            didSendCallback(false)
                            return
                        }
                        channel?.exitChannel(completionHandler: { (error) in
                            guard error == nil else {
                                didSendCallback(false)
                                return
                            }
                            SBDMain.disconnect(completionHandler: {
                                didSendCallback(true)
                            })
                        })
                        
                    })
                    
                })
                
            } catch {
                didSendCallback(false)
            }
        }
    }
}

func getMessagesFrom(abbs:String?, sendBirdChannelUrl:String, userId:String, numbersOfRange:UInt, didGetCallback:@escaping (_ messageArray:[Any]) -> Void) {
    
    SBDMain.connect(withUserId: userId) { (user, error) in
        guard error == nil else {
            didGetCallback([Any]())
            return
        }
        SBDOpenChannel.getWithUrl(sendBirdChannelUrl) { (channel, error) in
            guard error == nil else {
                didGetCallback([Any]())
                return
            }
            channel?.enter(completionHandler: { (error) in
                guard error == nil else {
                    didGetCallback([Any]())
                    return
                }
                
                let pageOfNumbers = UInt(100)
                let prevMessageListQuery = channel?.createPreviousMessageListQuery()
                prevMessageListQuery?.limit = pageOfNumbers
                prevMessageListQuery?.reverse = true
                
                if let listQuery = prevMessageListQuery {
                    getMessagesListQueryLoop(abbs: nil, counter: numbersOfRange, pageOfNumbers: pageOfNumbers, startArray: [Any](), listQuery: listQuery, callback: { (messageArray) in
                        
                        channel?.exitChannel(completionHandler: { (error) in
                            guard error == nil else {
                                didGetCallback(messageArray)
                                return
                            }
                            SBDMain.disconnect(completionHandler: {
                                didGetCallback(messageArray)
                            })
                        })
                        
                    })
                } else {
                    didGetCallback([Any]())
                }
            })
            
        }
        
    }
    
}

private func getMessagesListQueryLoop(abbs:String?, counter:UInt, pageOfNumbers:UInt, startArray:[Any], listQuery:SBDPreviousMessageListQuery, callback: @escaping ([Any]) -> Void) {
    
    var responseArray = [Any]()
    for i in 0..<startArray.count {
        responseArray.append(startArray[i])
    }
    listQuery.load(completionHandler: { (messages, error) in
        guard error == nil else {
            callback(responseArray)
            return
        }
        
        if (messages != nil) {
            for i in 0..<messages!.count {
                if let userMsg = messages![i] as? SBDUserMessage {
                    if let msg = userMsg.message {
                        if let msgData = msg.data(using: String.Encoding.utf8) {
                            
                            do {
                                if let msgDic = try JSONSerialization.jsonObject(with: msgData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                                    
                                    responseArray.append(msgDic)
                                    
                                }
                            } catch {}
                        }
                    }
                }
            }
        }
        
        if ((counter - pageOfNumbers) > 0) {
            getMessagesListQueryLoop(abbs: nil, counter: counter - pageOfNumbers, pageOfNumbers: pageOfNumbers, startArray: responseArray, listQuery: listQuery, callback: callback)
        } else {
            callback(responseArray)
        }
        
    })
}

func getSendBirdUserInfo(abbs:String?) -> UserInfoObject {
    
    let userInfo = UserInfoObject()
    if let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
        userInfo.userEmail = userEmail
    }
    if let userPassword = UserDefaults.standard.string(forKey: "userPassword") {
        userInfo.userPassword = userPassword
    }
    if let userNickname = UserDefaults.standard.string(forKey: "userNickname") {
        userInfo.userNickname = userNickname
    }
    if let userImageUrl = UserDefaults.standard.string(forKey: "userImageUrl") {
        userInfo.userImageUrl = userImageUrl
    }
    return userInfo
}

func setSendBirdUserInfo(abbs:String?, userNickname:String, userEmail:String, userImageUrl:String, userPassword:String) {
    UserDefaults.standard.set(userNickname, forKey: "userNickname")
    UserDefaults.standard.set(userEmail, forKey: "userEmail")
    UserDefaults.standard.set(userImageUrl, forKey: "userImageUrl")
    UserDefaults.standard.set(userPassword, forKey: "userPassword")
}

func sendAccountTo(abbs:String?, sendBirdAccountChannelUrl:String, userInfo: UserInfoObject, didSendCallback: @escaping () -> Void) {
    if (userInfo.userNickname.count > 0) {
        if (userInfo.userEmail.count > 0) {
            if (userInfo.userImageUrl.count > 0) {
                if (userInfo.userPassword.count > 0) {
                    var sendDic = [String:Any]()
                    sendDic["userNickname"] = userInfo.userNickname
                    sendDic["userEmail"] = userInfo.userEmail
                    sendDic["userPassword"] = userInfo.userPassword
                    sendDic["userImageUrl"] = userInfo.userImageUrl
                    sendMessageTo(abbs: nil, sendBirdChannelUrl: sendBirdAccountChannelUrl, userId: "Administrator", messageDic: sendDic) { (sendStatus) in
                        if (sendStatus) {
                            didSendCallback()
                        } else {
                            print("send account failure")
                        }
                    }
                }
            }
        }
    }
}

func getAccountsFrom(abbs:String?, sendBirdAccountChannelUrl:String, didGetCallback: @escaping (_ userInfoArray:[UserInfoObject]) -> Void) {
    
    getMessagesFrom(abbs: nil, sendBirdChannelUrl: sendBirdAccountChannelUrl, userId: "Administrator", numbersOfRange: 1000) { (accountArray) in
        
        var userInfoArray = [UserInfoObject]()
        for i in 0..<accountArray.count {
            if let accountDic = accountArray[i] as? [String:Any] {
                let userInfo = UserInfoObject()
                if let userEmail = accountDic["userEmail"] as? String {
                    userInfo.userEmail = userEmail
                }
                if let userNickname = accountDic["userNickname"] as? String {
                    userInfo.userNickname = userNickname
                }
                if let userImageUrl = accountDic["userImageUrl"] as? String {
                    userInfo.userImageUrl = userImageUrl
                }
                if let userPassword = accountDic["userPassword"] as? String {
                    userInfo.userPassword = userPassword
                }
                userInfoArray.append(userInfo)
            }
        }
        
        didGetCallback(userInfoArray)
        
    }
    
}

func sendDiscussTo(abbs:String?, sendBirdDiscussChannelUrl:String, discussObject:DiscussObject, didSendCallback: @escaping () -> Void) {
    
    var sendDic = [String:Any]()
    sendDic["discussId"] = discussObject.discussId
    sendDic["subject"] = discussObject.subject
    sendDic["content"] = discussObject.content
    sendDic["date"] = discussObject.date
    var accordingDic = [String:Any]()
    accordingDic["userEmail"] = discussObject.according.userEmail
    accordingDic["userNickname"] = discussObject.according.userNickname
    accordingDic["userImageUrl"] = discussObject.according.userImageUrl
    accordingDic["accordingUrl"] = discussObject.according.accordingUrl
    accordingDic["accordingImageUrl"] = discussObject.according.accordingImageUrl
    accordingDic["accordingTitle"] = discussObject.according.accordingTitle
    accordingDic["accordingSubTitle"] = discussObject.according.accordingSubTitle
    sendDic["according"] = accordingDic
    
    sendMessageTo(abbs: nil, sendBirdChannelUrl: sendBirdDiscussChannelUrl, userId: "Administrator", messageDic: sendDic) { (sendStatus) in
        if (sendStatus) {
            didSendCallback()
        } else {
            print("send discuss failure")
        }
    }
    
}

func getDiscussesFrom(abbs:String?, sendBirdDiscussChannelUrl:String, didGetCallback: @escaping (_ discussArray:[DiscussObject]) -> Void) {
    
    getMessagesFrom(abbs: nil, sendBirdChannelUrl: sendBirdDiscussChannelUrl, userId: "Administrator", numbersOfRange: 1000) { (resultArray) in
        
        var discussArray = [DiscussObject]()
        for i in 0..<resultArray.count {
            if let discussDic = resultArray[i] as? [String:Any] {
                let discussObj = DiscussObject()
                if let discussId = discussDic["discussId"] as? Int {
                    discussObj.discussId = discussId
                }
                if let subject = discussDic["subject"] as? String {
                    discussObj.subject = subject
                }
                if let content = discussDic["content"] as? String {
                    discussObj.content = content
                }
                if let date = discussDic["date"] as? String {
                    discussObj.date = date
                }
                if let accordingDic = discussDic["according"] as? [String:Any] {
                    if let userEmail = accordingDic["userEmail"] as? String {
                        discussObj.according.userEmail = userEmail
                    }
                    if let userNickname = accordingDic["userNickname"] as? String {
                        discussObj.according.userNickname = userNickname
                    }
                    if let userImageUrl = accordingDic["userImageUrl"] as? String {
                        discussObj.according.userImageUrl = userImageUrl
                    }
                    if let accordingUrl = accordingDic["accordingUrl"] as? String {
                        discussObj.according.accordingUrl = accordingUrl
                    }
                    if let accordingImageUrl = accordingDic["accordingImageUrl"] as? String {
                        discussObj.according.accordingImageUrl = accordingImageUrl
                    }
                    if let accordingTitle = accordingDic["accordingTitle"] as? String {
                        discussObj.according.accordingTitle = accordingTitle
                    }
                    if let accordingSubTitle = accordingDic["accordingSubTitle"] as? String {
                        discussObj.according.accordingSubTitle = accordingSubTitle
                    }
                }
                discussArray.append(discussObj)
            }
        }
        
        didGetCallback(discussArray)
        
    }
    
}

func sendNewPageTo(abbs:String?, sendBirdNewPageChannelUrl:String, newPageObject:NewPageObject, didSendCallback: @escaping () -> Void) {
    
    var sendDic = [String:Any]()
    sendDic["userEmail"] = newPageObject.userEmail
    sendDic["userNickname"] = newPageObject.userNickname
    sendDic["userImageUrl"] = newPageObject.userImageUrl
    sendDic["menuId"] = newPageObject.menuId
    sendDic["pageUrl"] = newPageObject.pageUrl
    sendDic["cateName"] = newPageObject.cateName
    sendDic["titleName"] = newPageObject.titleName
    sendDic["subTitleName"] = newPageObject.subTitleName
    sendDic["imageUrl"] = newPageObject.imageUrl
    sendDic["tagName"] = newPageObject.tagName
    sendDic["editTime"] = newPageObject.editTime

    sendMessageTo(abbs: nil, sendBirdChannelUrl: sendBirdNewPageChannelUrl, userId: "Administrator", messageDic: sendDic) { (sendStatus) in
        if (sendStatus) {
            didSendCallback()
        } else {
            print("send new page failure")
        }
    }
    
}

func getNewPagesFrom(abbs:String?, sendBirdNewPageChannelUrl:String, didGetCallback: @escaping (_ newPageArray:[NewPageObject]) -> Void) {
    
    getMessagesFrom(abbs: nil, sendBirdChannelUrl: sendBirdNewPageChannelUrl, userId: "Administrator", numbersOfRange: 1000) { (resultArray) in
        
        var newPageArray = [NewPageObject]()
        for i in 0..<resultArray.count {
            if let resultDic = resultArray[i] as? [String:Any] {
                let newPage = NewPageObject()
                if let userEmail = resultDic["userEmail"] as? String {
                    newPage.userEmail = userEmail
                }
                if let userNickname = resultDic["userNickname"] as? String {
                    newPage.userNickname = userNickname
                }
                if let userImageUrl = resultDic["userImageUrl"] as? String {
                    newPage.userImageUrl = userImageUrl
                }
                if let menuId = resultDic["menuId"] as? Int {
                    newPage.menuId = menuId
                }
                if let pageUrl = resultDic["pageUrl"] as? String {
                    newPage.pageUrl = pageUrl
                }
                if let cateName = resultDic["cateName"] as? String {
                    newPage.cateName = cateName
                }
                if let titleName = resultDic["titleName"] as? String {
                    newPage.titleName = titleName
                }
                if let subTitleName = resultDic["subTitleName"] as? String {
                    newPage.subTitleName = subTitleName
                }
                if let imageUrl = resultDic["imageUrl"] as? String {
                    newPage.imageUrl = imageUrl
                }
                if let tagName = resultDic["tagName"] as? [String] {
                    newPage.tagName = tagName
                }
                if let editTime = resultDic["editTime"] as? String {
                    newPage.editTime = editTime
                }
                
                newPageArray.append(newPage)
            }
        }
        
        didGetCallback(newPageArray)
        
    }
    
}

func sendUserAttentionTo(abbs:String?, sendBirdAttentionChannelUrl:String, attentionObject:AttentionObject, didSendCallback: @escaping () -> Void) {
    
    var sendDic = [String:Any]()
    sendDic["userEmail"] = attentionObject.userEmail
    sendDic["userNickname"] = attentionObject.userNickname
    sendDic["userImageUrl"] = attentionObject.userImageUrl
    sendDic["accordingUrlArray"] = attentionObject.accordingUrlArray
    
    sendMessageTo(abbs: nil, sendBirdChannelUrl: sendBirdAttentionChannelUrl, userId: "Administrator", messageDic: sendDic) { (sendStatus) in
        if (sendStatus) {
            didSendCallback()
        } else {
            print("send new page failure")
        }
    }
    
}

func getUserAttentionsFrom(abbs:String?, sendBirdAttentionChannelUrl:String, didGetCallback: @escaping (_ attentionArray:[AttentionObject]) -> Void) {
    
    getMessagesFrom(abbs: nil, sendBirdChannelUrl: sendBirdAttentionChannelUrl, userId: "Administrator", numbersOfRange: 1000) { (resultArray) in
        
        var attentionArray = [AttentionObject]()
        for i in 0..<resultArray.count {
            if let resultDic = resultArray[i] as? [String:Any] {
                let attention = AttentionObject()
                if let userEmail = resultDic["userEmail"] as? String {
                    attention.userEmail = userEmail
                }
                if let userNickname = resultDic["userNickname"] as? String {
                    attention.userNickname = userNickname
                }
                if let userImageUrl = resultDic["userImageUrl"] as? String {
                    attention.userImageUrl = userImageUrl
                }
                if let accordingUrlArray = resultDic["accordingUrlArray"] as? [String] {
                    attention.accordingUrlArray = accordingUrlArray
                }
                attentionArray.append(attention)
            }
        }
        
        didGetCallback(attentionArray)
        
    }
    
}

func sendRepostTo(abbs:String?, sendBirdRepostChannelUrl:String, repostObject:DiscussRepostObject, didSendCallback: @escaping () -> Void) {
    
    var sendDic = [String:Any]()
    sendDic["discussId"] = repostObject.discussId
    sendDic["userNickname"] = repostObject.userNickname
    sendDic["userEmail"] = repostObject.userEmail
    sendDic["userImageUrl"] = repostObject.userImageUrl
    sendDic["content"] = repostObject.content
    sendDic["date"] = repostObject.date
    
    sendMessageTo(abbs: nil, sendBirdChannelUrl: sendBirdRepostChannelUrl, userId: "Administrator", messageDic: sendDic) { (sendStatus) in
        if (sendStatus) {
            didSendCallback()
        } else {
            print("send discuss failure")
        }
    }
    
}

func getRepostsFrom(abbs:String?, sendBirdRepostChannelUrl:String, didGetCallback: @escaping (_ repostArray:[DiscussRepostObject]) -> Void) {
    
    getMessagesFrom(abbs: nil, sendBirdChannelUrl: sendBirdRepostChannelUrl, userId: "Administrator", numbersOfRange: 1000) { (resultArray) in
        
        var repostArray = [DiscussRepostObject]()
        for i in 0..<resultArray.count {
            if let resultDic = resultArray[i] as? [String:Any] {
                let repost = DiscussRepostObject()
                if let discussId = resultDic["discussId"] as? Int {
                    repost.discussId = discussId
                }
                if let userEmail = resultDic["userEmail"] as? String {
                    repost.userEmail = userEmail
                }
                if let userNickname = resultDic["userNickname"] as? String {
                    repost.userNickname = userNickname
                }
                if let userImageUrl = resultDic["userImageUrl"] as? String {
                    repost.userImageUrl = userImageUrl
                }
                if let content = resultDic["content"] as? String {
                    repost.content = content
                }
                if let date = resultDic["date"] as? String {
                    repost.date = date
                }
                
                repostArray.append(repost)
            }
        }
        
        didGetCallback(repostArray)
        
    }
    
}

func sendLikeTo(abbs:String?, sendBirdLikeChannelUrl:String, likeObject:DiscussLikeObject, didSendCallback: @escaping () -> Void) {
    
    var sendDic = [String:Any]()
    sendDic["discussId"] = likeObject.discussId
    var userInfoArray = [Any]()
    for i in 0..<likeObject.userInfoArray.count {
        var userInfo = [String:Any]()
        userInfo["userNickname"] = likeObject.userInfoArray[i].userNickname
        userInfo["userEmail"] = likeObject.userInfoArray[i].userEmail
        userInfo["userImageUrl"] = likeObject.userInfoArray[i].userImageUrl
        userInfo["userPassword"] = likeObject.userInfoArray[i].userPassword
        userInfoArray.append(userInfo)
    }
    sendDic["userInfoArray"] = userInfoArray
    sendMessageTo(abbs: nil, sendBirdChannelUrl: sendBirdLikeChannelUrl, userId: "Administrator", messageDic: sendDic) { (sendStatus) in
        if (sendStatus) {
            didSendCallback()
        } else {
            print("send discuss failure")
        }
    }
    
}

func getLikesFrom(abbs:String?, sendBirdLikeChannelUrl:String, didGetCallback: @escaping (_ likeArray:[DiscussLikeObject]) -> Void) {
    
    getMessagesFrom(abbs: nil, sendBirdChannelUrl: sendBirdLikeChannelUrl, userId: "Administrator", numbersOfRange: 1000) { (resultArray) in
        
        var likeArray = [DiscussLikeObject]()
        for i in 0..<resultArray.count {
            if let resultDic = resultArray[i] as? [String:Any] {
                
                if let discussId = resultDic["discussId"] as? Int {
                    let isContains = likeArray.contains(where: { (likeObj) -> Bool in
                        return likeObj.discussId == discussId
                    })
                    if (!isContains) {
                        
                        let like = DiscussLikeObject()
                        like.discussId = discussId
                        if let userInfoArray = resultDic["userInfoArray"] as? [Any] {
                            var userInfoObjArray = [UserInfoObject]()
                            for j in 0..<userInfoArray.count {
                                if let userInfoDic = userInfoArray[j] as? [String:Any] {
                                    let userInfoObj = UserInfoObject()
                                    if let userNickname = userInfoDic["userNickname"] as? String {
                                        userInfoObj.userNickname = userNickname
                                    }
                                    if let userNickname = userInfoDic["userNickname"] as? String {
                                        userInfoObj.userNickname = userNickname
                                    }
                                    if let userNickname = userInfoDic["userNickname"] as? String {
                                        userInfoObj.userNickname = userNickname
                                    }
                                    if let userNickname = userInfoDic["userNickname"] as? String {
                                        userInfoObj.userNickname = userNickname
                                    }
                                    userInfoObjArray.append(userInfoObj)
                                }
                            }
                            like.userInfoArray = userInfoObjArray
                        }
                        likeArray.append(like)
                        
                    }
                    
                }
                
            }
        }
        
        didGetCallback(likeArray)
        
    }
    
}

func getOutermostView(abbs:String?, sourceView:UIView) -> UIView {
    var superView:UIView? = sourceView
    while (superView!.superview != nil) {
        superView = superView!.superview
    }
    return superView!
}

func getViewOfAbsoluteFame(abbs:String?, sourceView:UIView) -> CGRect {
    
    var originX:CGFloat = 0
    var originY:CGFloat = 0
    originX = originX + sourceView.frame.origin.x
    originY = originY + sourceView.frame.origin.y
    var superView = sourceView.superview
    while (superView != nil) {
        if superView is UIScrollView {
            originY = originY - (superView as! UIScrollView).contentOffset.y
        }
        originX = originX + superView!.frame.origin.x
        originY = originY + superView!.frame.origin.y
        superView = superView!.superview
    }
    return CGRect(x: originX, y: originY, width: sourceView.frame.size.width, height: sourceView.frame.size.height)
    
}

func startIndicator(abbs:String?, currentVC:UIViewController, callback: @escaping (_ indicatorView:UIView?) -> Void) {
    
    if let onView = currentVC.view {
        DispatchQueue.main.async {
            
            let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            onView.addSubview(mainView)
            mainView.translatesAutoresizingMaskIntoConstraints = false
            mainView.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75)
            
            onView.addConstraints([NSLayoutConstraint(item: mainView,
                                                      attribute: .leading,
                                                      relatedBy: .equal,
                                                      toItem: onView,
                                                      attribute: .leading,
                                                      multiplier: 1.0,
                                                      constant: 0.0),
                                   NSLayoutConstraint(item: mainView,
                                                      attribute: .trailing,
                                                      relatedBy: .equal,
                                                      toItem: onView,
                                                      attribute: .trailing,
                                                      multiplier: 1.0,
                                                      constant: 0.0),
                                   NSLayoutConstraint(item: mainView,
                                                      attribute: .top,
                                                      relatedBy: .equal,
                                                      toItem: onView,
                                                      attribute: .top,
                                                      multiplier: 1.0,
                                                      constant: 0.0),
                                   NSLayoutConstraint(item: mainView,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: onView,
                                                      attribute: .bottom,
                                                      multiplier: 1.0,
                                                      constant: 0.0)])
            
            let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            mainView.addSubview(indicator)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.backgroundColor = UIColor.clear
            indicator.style = UIActivityIndicatorView.Style.whiteLarge
            
            mainView.addConstraints([NSLayoutConstraint(item: indicator,
                                                        attribute: .centerX,
                                                        relatedBy: .equal,
                                                        toItem: mainView,
                                                        attribute: .centerX,
                                                        multiplier: 1.0,
                                                        constant: 0.0),
                                     NSLayoutConstraint(item: indicator,
                                                        attribute: .centerY,
                                                        relatedBy: .equal,
                                                        toItem: mainView,
                                                        attribute: .centerY,
                                                        multiplier: 1.0,
                                                        constant: 0.0)])
            
            indicator.startAnimating()
            
            callback(mainView)
            
        }
    } else {
        DispatchQueue.main.async {
            callback(nil)
        }
    }
    
}

func stopIndicator(abbs:String?, indicatorView:UIView?, callback: @escaping () -> Void) {
    DispatchQueue.main.async {
        if (indicatorView != nil) {
            indicatorView?.removeFromSuperview()
        }
        callback()
    }
}

func matchPattern(abbs:String?, input: String, pattern:String) -> Bool {
    
    if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
        return regex.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)).count > 0
    } else {
        return false
    }
    
}

func resizeImageLimited(abbs:String?, image: UIImage, limitedSize: CGFloat) -> UIImage {
    
    let size = image.size
    if (size.width < limitedSize && size.height < limitedSize) {
        return image
    } else {
        var targetWidth:CGFloat = 0
        var targetHeight:CGFloat = 0
        if (size.width > size.height) {
            targetWidth = limitedSize
            targetHeight = limitedSize * size.height / size.width
        } else {
            targetHeight = limitedSize
            targetWidth = limitedSize * size.width / size.height
        }
        
        let newSize = CGSize(width: targetWidth, height: targetHeight)
        let rect = CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        var newImage = UIImage()
        if let newImageTemp = UIGraphicsGetImageFromCurrentImageContext() {
            newImage = newImageTemp
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

func backToViewController(abbs:String?, currentVC:UIViewController, backToVC:String) {
    var pvc:UIViewController = currentVC
    while (pvc.presentingViewController != nil) {
        pvc = pvc.presentingViewController!
        if (String(describing: pvc) == backToVC) {
            break
        }
    }
    pvc.dismiss(animated: false, completion: nil)
}

func getDeviceTokenFromUserDefaults(abbs:String?, callback: @escaping (_ deviceToken:String) -> Void) {
    if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
        DispatchQueue.main.async {
            callback(deviceToken)
        }
    } else {
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { timer in
            getDeviceTokenFromUserDefaults(abbs: nil, callback: callback)
        })
    }
}

func saveDeviceTokenToUserDefaults(abbs:String?, deviceToken:String, callback: @escaping (_ deviceToken:String) -> Void) {
    UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
    DispatchQueue.main.async {
        callback(deviceToken)
    }
}

func getCoreDataContext(abbs:String?, entityName:String, callback: @escaping (_ context:NSManagedObjectContext) -> Void) {
    
    let persistentContainer = NSPersistentContainer(name: entityName)
    persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        } else {
            callback(persistentContainer.viewContext)
        }
    })
    
}



func coreDataExample(abbs:String?) {
    
    let persistentContainer = NSPersistentContainer(name: "DataBaseName")
    persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        } else {
            let context = persistentContainer.viewContext
            
            // save data
            let entity = NSEntityDescription.entity(forEntityName: "FormName", in: context)
            let newData = NSManagedObject(entity: entity!, insertInto: context)
            newData.setValue("dataConten", forKey: "dataName")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            
            // get data
            let getRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FormName")
            //request.predicate = NSPredicate(format: "age = %@", "12")
            do {
                let result = try context.fetch(getRequest)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "dataName") as! String)
                }
            } catch {
                print("Failed")
            }
            
            // update data
            let updateRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "FormName")
            updateRequest.predicate = NSPredicate(format: "dataName = %@", "dataConten")
            do {
                let updateDatas = try context.fetch(updateRequest)
                if let data = updateDatas[0] as? NSManagedObject {
                    data.setValue("dataConten", forKey: "dataName")
                    data.setValue("dataConten", forKey: "dataName")
                    try context.save()
                }
            } catch {
                print("Failed")
            }
            
            // delete data
            let deleteRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "FormName")
            deleteRequest.predicate = NSPredicate(format: "dataName = %@", "dataConten")
            do {
                let deleteDatas = try context.fetch(deleteRequest)
                if let data = deleteDatas[0] as? NSManagedObject {
                    context.delete(data)
                    try context.save()
                }
            } catch {
                print("Failed")
            }
            
        }
    })
    
}

func uploadImageGetLink(abbs:String?, image: UIImage, callback: @escaping (_ imageLink:String) -> Void) {
    
    let urlString = "https://api.imgur.com/3/image"
    let authorization = "Client-ID dcf69b797f59023"
    let mashapeKey = "07e83c5b2e1d2127030c97206a629d969bc86bf4"
    
    let resizeImage = resizeImageLimited(abbs: nil, image: image, limitedSize: 1024)
    
    // 將圖片轉為 base64 字串
    let imageData = resizeImage.pngData()!
    let imageBase64 = imageData.base64EncodedString()
    
    let headers: HTTPHeaders = ["Authorization": authorization, "X-Mashape-Key": mashapeKey]
    let parameters: Parameters = ["image": imageBase64]
    Alamofire.request(urlString, method: .post, parameters: parameters, headers: headers).responseJSON { response in
        guard response.result.isSuccess else {
            let errorMessage = response.result.error?.localizedDescription
            print(errorMessage!)
            return
        }
        guard let JSON = response.result.value as? [String: Any] else {
            print("JSON formate error")
            return
        }
        guard let success = JSON["success"] as? Bool,
            let data = JSON["data"] as? [String: Any] else {
                print("JSON formate error")
                return
        }
        if !success {
            let message = data["error"] as? String ?? "error"
            print(message)
            return
        }
        if let link = data["link"] as? String,
            let _ = data["width"] as? Int,
            let _ = data["height"] as? Int {
            
            callback(link)
            
        }
    }
    
}

func getDownArrow(abbs:String?, imageSize:CGFloat, color:UIColor) -> UIImage {
    
    UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize, height: imageSize), false, 0)
    let ctx = UIGraphicsGetCurrentContext()!
    ctx.beginPath()
    ctx.move(to: CGPoint(x: 0.0, y: 0.0))
    ctx.addLine(to: CGPoint(x: imageSize, y: 0.0))
    ctx.addLine(to: CGPoint(x: imageSize / 2, y: imageSize))
    ctx.closePath()
    ctx.setFillColor(color.cgColor)
    ctx.fillPath()
    let img = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return img
    
}

func isSameUrl(abbs:String?, urlx:String, urly:String) -> Bool {
    
    var purex = ""
    var purey = ""
    
    if let lastChar = urlx.last {
        if (lastChar == "/") {
            purex = String(urlx.prefix(urlx.count - 1))
        } else {
            purex = urlx
        }
    }
    if let lastChar = urly.last {
        if (lastChar == "/") {
            purey = String(urly.prefix(urly.count - 1))
        } else {
            purey = urly
        }
    }
    if (String(urlx.prefix(4)).lowercased() == "http") {
        if let firstCharIndex = urlx.firstIndex(of: ":") {
            purex = String(purex.suffix(purex.count - firstCharIndex.encodedOffset - 3))
        }
    }
    if (String(urly.prefix(4)).lowercased() == "http") {
        if let firstCharIndex = urly.firstIndex(of: ":") {
            purey = String(purey.suffix(purey.count - firstCharIndex.encodedOffset - 3))
        }
    }
    if (purex == purey) {
        return true
    } else {
        return false
    }
    
}
