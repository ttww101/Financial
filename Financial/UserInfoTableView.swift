
import UIKit

class UserInfoTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var vcInstance:UserInfoViewController?
    let imagePicker = UIImagePickerController()
    var userInfo = getSendBirdUserInfo(abbs: nil)
    var dataArray = [String]()
    
    override func awakeFromNib() {
        imagePicker.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoTVC", for: indexPath) as! UserInfoTableViewCell
            
            cell.userImageIndicator.isHidden = true
            cell.userImageIndicator.stopAnimating()
            
            cell.tag = indexPath.row
            if (userInfo.userImageUrl.count > 0) {
                cell.userImageIndicator.startAnimating()
                cell.userImageIndicator.isHidden = false
                downloadImage(abbs: nil, url: userInfo.userImageUrl) { (image) in
                    cell.userImageIndicator.isHidden = true
                    cell.userImageIndicator.stopAnimating()
                    if (cell.tag == indexPath.row) {
                        cell.userImageView.image = image
                    }
                }
            }
            
            cell.userNicknameLabel.text = userInfo.userNickname
            cell.userNicknameLabel.isHidden = false
            cell.userNicknameTextField.text = userInfo.userNickname
            cell.userNicknameTextField.isHidden = true
            cell.userEmailLabel.text = userInfo.userEmail
            cell.userEmailLabel.isHidden = false
            cell.userEmailTextField.text = userInfo.userEmail
            cell.userEmailTextField.isHidden = true
            
            cell.userNicknameBtn.setTitle("变更", for: UIControl.State.normal)
            cell.userNicknameBtn.addTargetClosure { (sender) in
                cell.userNicknameLabel.isHidden = true
                cell.userNicknameTextField.isHidden = false
                cell.userNicknameBtn.setTitle("储存", for: UIControl.State.normal)
                cell.userNicknameBtn.addTargetClosure { (sender) in
                    self.userInfo.userNickname = cell.userNicknameTextField.text!
                    sendAccountTo(abbs: nil, sendBirdAccountChannelUrl: appSendBirdAccountChannelUrl, userInfo: self.userInfo, didSendCallback: {
                        self.reloadData()
                    })
                }
            }
            
            cell.userEmailBtn.setTitle("变更", for: UIControl.State.normal)
            cell.userEmailBtn.addTargetClosure { (sender) in
                cell.userEmailLabel.isHidden = true
                cell.userEmailTextField.isHidden = false
                cell.userEmailBtn.setTitle("储存", for: UIControl.State.normal)
                cell.userEmailBtn.addTargetClosure { (sender) in
                    self.userInfo.userEmail = cell.userEmailTextField.text!
                    sendAccountTo(abbs: nil, sendBirdAccountChannelUrl: appSendBirdAccountChannelUrl, userInfo: self.userInfo, didSendCallback: {
                        self.reloadData()
                    })
                }
            }
            
            cell.userImageSelectBtn.addTargetClosure { (sender) in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.vcInstance!.present(self.imagePicker, animated: true, completion: {
                    cell.userImageIndicator.startAnimating()
                    cell.userImageIndicator.isHidden = false
                })
                self.vcInstance!.present(self.imagePicker, animated: true, completion: nil)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoTVC", for: indexPath) as! UserInfoTableViewCell
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            uploadImageGetLink(abbs: nil, image: pickedImage) { (imageLink) in
                self.userInfo.userImageUrl = imageLink
                sendAccountTo(abbs: nil, sendBirdAccountChannelUrl: appSendBirdAccountChannelUrl, userInfo: self.userInfo, didSendCallback: {
                    self.reloadData()
                })
            }
            
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.imagePicker.dismiss(animated: true, completion: nil)
        
    }

}
