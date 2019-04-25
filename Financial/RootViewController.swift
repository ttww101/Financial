import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var rootTV: RootTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "换汇计算机"
        
        rootTV.dataSource = rootTV.self
        rootTV.delegate = rootTV.self
        rootTV.rtInstance = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.rootTV.reloadData()
        
    }

}
