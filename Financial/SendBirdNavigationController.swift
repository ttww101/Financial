import UIKit

class SendBirdNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = appMainColor
        self.navigationBar.tintColor = appLightColor
        
        var mTitleAttributes = [NSAttributedString.Key:Any]()
        mTitleAttributes[NSAttributedString.Key.font] = mTitleFont
        mTitleAttributes[NSAttributedString.Key.foregroundColor] = appLightColor
        self.navigationBar.titleTextAttributes = mTitleAttributes
        
    }
    

}
