import UIKit

class CalculateTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    var vcInstance:ViewController?
    var inputPrice:Double = 1
    var isEditProcess = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let vc = vcInstance {
            return vc.currencyObjectArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "calculateTVC", for: indexPath) as! CalculateTableViewCell
        
        if let vc = self.vcInstance {
            if (vc.currencyObjectArray.count > indexPath.row) {
                
                var isMain = false
                if (vc.currencyObjectArray[indexPath.row].id == vc.mainCurrencyId) {
                    isMain = true
                }
                if (isMain) {
                    cell.mainBtn.layer.backgroundColor = UIColor.orange.cgColor
                    cell.mainBtn.addTargetClosure { (sender) in
                        
                    }
                } else {
                    cell.mainBtn.layer.backgroundColor = UIColor.gray.cgColor
                    cell.mainBtn.addTargetClosure { (sender) in
                        vc.mainCurrencyId = vc.currencyObjectArray[indexPath.row].id
                        UserDefaults.standard.set(vc.mainCurrencyId, forKey: "mainCurrencyId")
                        
                        if (!vc.enableCurrencyIdArray.contains(vc.currencyObjectArray[indexPath.row].id)) {
                            vc.enableCurrencyIdArray.append(vc.currencyObjectArray[indexPath.row].id)
                            UserDefaults.standard.set(vc.enableCurrencyIdArray, forKey: "enableCurrencyIdArray")
                            
                        }
                        
                        self.inputPrice = 1
                        var tempArray = [CurrencyObject]()
                        let firstIndex = vc.currencyObjectArray.firstIndex(where: { (curObj) -> Bool in
                            return curObj.id == vc.mainCurrencyId
                        })
                        if (firstIndex != nil) {
                            tempArray.append(vc.currencyObjectArray[firstIndex!])
                        }
                        
                        for i in 0..<vc.currencyObjectArray.count {
                            if (vc.currencyObjectArray[i].id != vc.mainCurrencyId && vc.enableCurrencyIdArray.contains(vc.currencyObjectArray[i].id)) {
                                tempArray.append(vc.currencyObjectArray[i])
                            }
                        }
                        for i in 0..<vc.currencyObjectArray.count {
                            if (!vc.enableCurrencyIdArray.contains(vc.currencyObjectArray[i].id)) {
                                tempArray.append(vc.currencyObjectArray[i])
                            }
                        }
                        vc.currencyObjectArray = tempArray
                        
                        
                        tableView.reloadData()
                        if let cell = self.cellForRow(at: IndexPath(row: 0, section: 0)) as? CalculateTableViewCell {
                            cell.priceInputTextField.becomeFirstResponder()
                        }
                        
                    }
                }
                var isEnable = false
                if (vc.enableCurrencyIdArray.contains(vc.currencyObjectArray[indexPath.row].id)) {
                    isEnable = true
                }
                if (isEnable) {
                    cell.enableBtn.layer.backgroundColor = UIColor.blue.cgColor
                    cell.enableBtn.addTargetClosure { (sender) in
                        if (vc.mainCurrencyId != vc.currencyObjectArray[indexPath.row].id) {
                            vc.enableCurrencyIdArray.removeAll(where: { (idName) -> Bool in
                                return idName == vc.currencyObjectArray[indexPath.row].id
                            })
                            UserDefaults.standard.set(vc.enableCurrencyIdArray, forKey: "enableCurrencyIdArray")
                            
                            var tempArray = [CurrencyObject]()
                            let firstIndex = vc.currencyObjectArray.firstIndex(where: { (curObj) -> Bool in
                                return curObj.id == vc.mainCurrencyId
                            })
                            if (firstIndex != nil) {
                                tempArray.append(vc.currencyObjectArray[firstIndex!])
                            }
                            
                            for i in 0..<vc.currencyObjectArray.count {
                                if (vc.currencyObjectArray[i].id != vc.mainCurrencyId && vc.enableCurrencyIdArray.contains(vc.currencyObjectArray[i].id)) {
                                    tempArray.append(vc.currencyObjectArray[i])
                                }
                            }
                            for i in 0..<vc.currencyObjectArray.count {
                                if (!vc.enableCurrencyIdArray.contains(vc.currencyObjectArray[i].id)) {
                                    tempArray.append(vc.currencyObjectArray[i])
                                }
                            }
                            vc.currencyObjectArray = tempArray
                            
                            tableView.reloadData()
                            if let cell = self.cellForRow(at: IndexPath(row: 0, section: 0)) as? CalculateTableViewCell {
                                cell.priceInputTextField.becomeFirstResponder()
                            }
                        }
                    }
                } else {
                    cell.enableBtn.layer.backgroundColor = UIColor.gray.cgColor
                    cell.enableBtn.addTargetClosure { (sender) in
                        if (!vc.enableCurrencyIdArray.contains(vc.currencyObjectArray[indexPath.row].id)) {
                            vc.enableCurrencyIdArray.append(vc.currencyObjectArray[indexPath.row].id)
                            UserDefaults.standard.set(vc.enableCurrencyIdArray, forKey: "enableCurrencyIdArray")
                            
                            var tempArray = [CurrencyObject]()
                            let firstIndex = vc.currencyObjectArray.firstIndex(where: { (curObj) -> Bool in
                                return curObj.id == vc.mainCurrencyId
                            })
                            if (firstIndex != nil) {
                                tempArray.append(vc.currencyObjectArray[firstIndex!])
                            }
                            
                            for i in 0..<vc.currencyObjectArray.count {
                                if (vc.currencyObjectArray[i].id != vc.mainCurrencyId && vc.enableCurrencyIdArray.contains(vc.currencyObjectArray[i].id)) {
                                    tempArray.append(vc.currencyObjectArray[i])
                                }
                            }
                            for i in 0..<vc.currencyObjectArray.count {
                                if (!vc.enableCurrencyIdArray.contains(vc.currencyObjectArray[i].id)) {
                                    tempArray.append(vc.currencyObjectArray[i])
                                }
                            }
                            vc.currencyObjectArray = tempArray
                            
                            tableView.reloadData()
                            if let cell = self.cellForRow(at: IndexPath(row: 0, section: 0)) as? CalculateTableViewCell {
                                cell.priceInputTextField.becomeFirstResponder()
                            }
                        }
                    }
                }
                if (isEnable) {
                    if (isMain) {
                        cell.priceInputView.isHidden = false
                        if (!isEditProcess) {
                            cell.priceInputTextField.text = "\(inputPrice)"
                        } else {
                            isEditProcess = false
                        }
                    } else {
                        cell.priceInputView.isHidden = true
                        cell.priceLabel.text = vc.currencyObjectArray[indexPath.row].currencySymbol + "  "
                        cell.priceLabel.tag = indexPath.row
                        getCurrencyValue(abbs: nil, fromCurrencyId: vc.mainCurrencyId, toCurrencyId: vc.currencyObjectArray[indexPath.row].id, callback: { (currencyPer) in
                            if (cell.priceLabel.tag == indexPath.row) {
                                if let per = currencyPer {
                                    let formatter = NumberFormatter()
                                    formatter.minimumIntegerDigits = 1
                                    formatter.maximumFractionDigits = 2
                                    if let valueString = formatter.string(from: NSNumber(value: self.inputPrice*per)) {
                                        cell.priceLabel.text = vc.currencyObjectArray[cell.priceLabel.tag].currencySymbol + " " + valueString
                                    }
                                }
                            }
                        })
                        
                    }
                } else {
                    cell.priceInputView.isHidden = true
                    cell.priceLabel.text = ""
                }
                
                cell.titleLabel.text = vc.currencyObjectArray[indexPath.row].id + "\n" + getCurrencyNameCn(abbs: nil, id: vc.currencyObjectArray[indexPath.row].id)
                
                cell.priceInputTextField.tag = indexPath.row
                cell.priceInputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        isEditProcess = true
        if (textField.text!.count > 0) {
            if let putDouble = Double(textField.text!) {
                inputPrice = putDouble
            } else {
                inputPrice = 1
            }
        } else {
            inputPrice = 1
        }
        self.reloadData()
        if let cell = self.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? CalculateTableViewCell {
            cell.priceInputTextField.becomeFirstResponder()
        }
        
    }
    
}
