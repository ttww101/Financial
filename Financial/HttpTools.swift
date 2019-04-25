import Foundation
import UIKit

func httpConnect(abbs:String?, url:String, type:String, headers:[String:String], uploadDic:[String:Any]?, callback: @escaping (_ resultStatus:Int, _ resultHeaders:[String:String], _ resutlData:Data, _ resultError:String) -> Void) {
    
    var request = URLRequest(url: URL(string: url)!)
    
    do {
        if type == "GET" {
            
        } else if type == "POST"{
            if (uploadDic != nil) {
                request.httpBody = try JSONSerialization.data(withJSONObject: uploadDic!, options: JSONSerialization.WritingOptions())
            }
        } else if type == "PUT"{
            if (uploadDic != nil) {
                request.httpBody = try JSONSerialization.data(withJSONObject: uploadDic!, options: JSONSerialization.WritingOptions())
            }
        } else if type == "DELETE"{
            if (uploadDic != nil) {
                request.httpBody = try JSONSerialization.data(withJSONObject: uploadDic!, options: JSONSerialization.WritingOptions())
            }
        }
    } catch let error{
        print("http type \(error)")
    }
    
    request.httpMethod = type
    
    for i in 0..<Array(headers.keys).count {
        request.setValue(Array(headers.values)[i], forHTTPHeaderField: Array(headers.keys)[i])
    }
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest){
        (data, response, error) -> Void in
        
        if error != nil {
            callback(999, [String:String](), Data(), error!.localizedDescription)
        } else {
            
            let httpResponse = response as! HTTPURLResponse
            let resultStatus = httpResponse.statusCode
            let responseHeaders = httpResponse.allHeaderFields
            var resultHeaders = [String:String]()
            for i in 0..<Array(responseHeaders.keys).count {
                if let headerKey = Array(responseHeaders.keys)[i] as? String {
                    if let headerValue = Array(responseHeaders.values)[i] as? String {
                        resultHeaders[headerKey] = headerValue
                    }
                }
            }
            var resultData:Data = Data()
            if (data != nil) {
                resultData = data!
            }
            
            callback(resultStatus, resultHeaders, resultData, "")
            
        }
    }
    
    task.resume()
}

func downloadJasonDataAsDictionary(abbs:String?, url:String, type:String, headers:[String:String], uploadDic:[String:Any]?, callback: @escaping (_ resutStatus:Int, _ resultHeaders:[String:String], _ resultDic:[String:Any], _ resultError:String) -> Void) {
    httpConnect(abbs: nil, url: url, type: type, headers: headers, uploadDic: uploadDic) { (resultStatus, resultHeaders, resultData, errorString) in
        DispatchQueue.main.async {
            do {
                if let resultDic = try JSONSerialization.jsonObject(with: resultData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                    DispatchQueue.main.async {
                        callback(resultStatus, resultHeaders, resultDic, errorString)
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(resultStatus, resultHeaders, [String:Any](), errorString)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    callback(resultStatus, resultHeaders, [String:Any](), errorString)
                }
            }
        }
    }
}

func downloadJasonDataAsArray(abbs:String?, url:String, type:String, headers:[String:String], uploadDic:[String:Any]?, callback: @escaping (_ resultStatus:Int, _ resultHeaders:[String:String], _ resultArray:[Any], _ resultError:String) -> Void) {
    httpConnect(abbs: nil, url: url, type: type, headers: headers, uploadDic: uploadDic) { (resultStatus, resultHeaders, resultData, errorString) in
        DispatchQueue.main.async {
            do {
                if let resultArray = try JSONSerialization.jsonObject(with: resultData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Any] {
                    DispatchQueue.main.async {
                        callback(resultStatus, resultHeaders, resultArray, errorString)
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(resultStatus, resultHeaders, [Any](), errorString)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    callback(resultStatus, resultHeaders, [Any](), errorString)
                }
            }
        }
    }
}

func downloadImage(abbs:String?, url: String, callback: @escaping (UIImage?) -> Void) {
    httpConnect(abbs: nil, url: url, type: "GET", headers: [String:String](), uploadDic: nil) { (resultStatus, resultHeaders, resultData, errorString) in
        DispatchQueue.main.async {
            if (resultStatus == 200) {
                callback(UIImage(data: resultData))
            } else {
                callback(nil)
            }
        }
    }
}
