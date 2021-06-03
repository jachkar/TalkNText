//
//  AppDelegate.swift
//  TalkNText
//
//  Created by Julien Achkar on 20/04/2021.
//

import UIKit
import DropDown
import Firebase
import GoogleSignIn
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    class var sharedDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    class var storyBoard: UIStoryboard {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        setupGoogleSignIn()
        
        IQKeyboardManager.shared.enable = true

        customizeNavigation()
        DropDown.startListeningToKeyboard()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.frame = UIScreen.main.bounds
        
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        return true
    }
    
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func customizeNavigation() {
        let navigationBarAppearace = UINavigationBar.appearance()
        

//        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
//        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.tintColor = .black
        navigationBarAppearace.barTintColor = .white
//        navigationBarAppearace.isTranslucent = false
//        navigationBarAppearace.barStyle = .default
        navigationBarAppearace.prefersLargeTitles = true

        // Navigation title
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont(name: Constants.Font.Bold, size: 20) as Any]
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("User signed in")
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
    }
}

