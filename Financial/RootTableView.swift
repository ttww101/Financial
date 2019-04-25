import UIKit

class RootTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var rtInstance:RootViewController!
    var rootViewDataArray = [String]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootViewDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rootTVC", for: indexPath) as! RootTableViewCell
        
        cell.nameLabel.text = rootViewDataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let spVC = self.rtInstance.navigationController?.splitViewController as? SplitViewController {
            spVC.detailVC?.selectCateName = self.rootViewDataArray[indexPath.row]
            spVC.detailVC?.updateCateSelect(abbs: nil)
            if let detailNavi = spVC.detailNavi {
                spVC.showDetailViewController(detailNavi, sender: nil)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
