import UIKit

class NavigationController: SendBirdNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setToolbarHidden(true, animated: false)
    }
    
}
