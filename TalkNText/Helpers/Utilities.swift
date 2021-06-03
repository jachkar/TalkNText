//
//  Utilities.swift
//  TalkNText
//
//  Created by Julien Achkar on 20/04/2021.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth

class Utilities: NSObject {
    class func isStringNull (string : String) ->Bool {
        if  string != "" && string != "(null)" && string != "<null>" && string != "0"  && string != "  " {
            return false
        }
        return true
    }
    
    class func isStringNull(strings: [String]) -> Bool {
        for string in strings {
            if  string == "" || string == "(null)" || string == "<null>" || string == "0"  || string == "  " {
                return true
            }
        }
        return false
    }
    
    class func getAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        return appVersion ?? ""
    }
    
    class func openUrl(url : String) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(NSURL(string: url)! as URL, options: [:],
                                      completionHandler: {
                                        (success) in
                                        print("Open \(success)")
            })
        } else {
            let success = UIApplication.shared.openURL(NSURL(string: url)! as URL)
            print("Open \(success)")
        }
    }
    
    class func getDate(date : String) -> String {
        let value = (date as NSString).doubleValue
        let dateVar = Date(timeIntervalSince1970:value)

        let dateFormatter = DateFormatter()

        var language = ""

        if UserDefaults.standard.object(forKey: "AppLanguage") as? String != nil {
            language = UserDefaults.standard.object(forKey: "AppLanguage") as! String
            if language.hasPrefix("ar") {
                dateFormatter.locale = Locale(identifier: "ar_LB")
                dateFormatter.dateFormat = "d, MMMM, yyyy HH:mm a"
            } else if language.hasPrefix("en") {
                dateFormatter.dateFormat = "h:mm a MMMM dd, yyyy"
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
            }
        } else {
            dateFormatter.dateFormat = "h:mm a MMMM dd, yyyy"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
        }
        
        let resultDate = dateFormatter.string(from: dateVar)
        
        return resultDate
    }
    
    class func getCurrentDateInString() -> String {
        return String(Int64(Date().timeIntervalSince1970 * 1000))
    }
    
    class func dateFromSeconds(dateInMillis : String) -> String {
        var dateStr = ""
        let timeInterval = TimeInterval(((dateInMillis as NSString?)?.doubleValue)!)
        let dateVar = Date.init(timeIntervalSince1970: timeInterval/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy HH:mm"
        dateStr = dateFormatter.string(from: dateVar)
        return dateStr
    }
    
    typealias CompletionHandler = (_ text: String) -> Void
    class func showTextPopup(viewController: UIViewController, title: String, message: String, completionHandler :  @escaping CompletionHandler) {
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Room ID", message: "Enter Room ID", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Room ID"
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Enter", style: .default) { _ in

            // this code runs when the user hits the "save" button

            let inputName = alertController.textFields![0].text
            completionHandler(inputName ?? "")

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension UIStoryboard {
    func getViewController(identifier: ViewControllerIdentifier) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }
}

extension FTChatMessageUserModel {
    static func getCurrentUserModel() -> FTChatMessageUserModel? {
        if let appUser = GIDSignIn.sharedInstance().currentUser {
            let userID = Auth.auth().currentUser?.uid
            let firstName = appUser.profile.givenName ?? ""
            let lastName = appUser.profile.familyName ?? ""
            let userName = "\(firstName) \(lastName)"
            let userIconURL = appUser.profile.imageURL(withDimension: 80)?.absoluteString
            let senderModel = FTChatMessageUserModel(id: userID, name: userName, icon_url: userIconURL, extra_data: nil, isSelf: true)
            return senderModel
        }
        return nil
    }
}

extension UIView {
    func addShadow() {
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = Constants.Colors.ShaddowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    func addbackShadow() {
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = Constants.Colors.ShaddowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

extension Encodable {
    func asDictionary() -> [String: Any] {
        let data = try! JSONEncoder().encode(self)
        guard let dictionary = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            return [String: Any]()
        }
        return dictionary
    }
}
