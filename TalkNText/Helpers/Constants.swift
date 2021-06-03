//
//  Constants.swift
//  TalkNText
//
//  Created by Julien Achkar on 120/04/2021.
//

import Foundation
import UIKit

public typealias GenericClosure<T> = (_ value: T)->()

public enum ViewControllerIdentifier: String {
    case home               = "HomeViewController"
    case login              = "LoginViewController"
    case pincode            = "PinViewController"
    case chat               = "ChatViewController"
    case mainVideo          = "MainVideoChatViewController"
    case videoChat          = "VideoChatViewController"
}

public enum CollectionViewControllerType {
    case musicType
    case artist
    case bundle
}

struct Constants {

    struct Sizes {
        static let ScreenWidth = UIScreen.main.bounds.size.width
        static let ScreenHeight = UIScreen.main.bounds.size.height
    }

    struct Colors {
        static let MainColor = UIColor(red: 0.63, green: 0.11, blue: 0.13, alpha: 1.00)
        static let MainLightColor = UIColor(red: 0.82, green: 0.27, blue: 0.29, alpha: 1.00)
        static let BackgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        static let LightGreenColor = UIColor(red: 0.61, green: 0.80, blue: 0.22, alpha: 1.00)
        static let PinkColor = UIColor(red: 0.93, green: 0.04, blue: 0.51, alpha: 1.00)
        static let WhiteHUDColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.80)
        static let LightGray = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.00)
        static let ShaddowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.16)
    }

    struct Font {
        static let Regular: String = "Helvetica"
        static let Bold: String = "Helvetica-Bold"
        static let Light: String = "Helvetica-Light"
    }

    struct URL {
        static let AppServerAddress = ""
        static let TermsAndConditions = "http://www.google.com"
        static let PrivacyPolicy = "http://www.google.com"
    }

    struct Values {
        static let IMEI = UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "")

        static let GoogleServicesKey = ""

        static let ErrorText = "An error has occured please try again later..."
    }
}

