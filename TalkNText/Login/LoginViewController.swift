//
//  LoginViewController.swift
//  Zong
//
//  Created by Julien Achkar on 11/12/20.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: BaseViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        loginBtn.backgroundColor = Constants.Colors.LightGreenColor
        loginBtn.setTitle("Google Sign Up", for: .normal)
        loginBtn.setTitleColor(.black, for: .normal)
        loginBtn.titleLabel?.font = UIFont(name: Constants.Font.Bold, size: 17)
    }

    @IBAction func loginPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self

        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}

extension LoginViewController: GIDSignInDelegate { //, ChatDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      
      if let error = error {
        print(error.localizedDescription)
        return
      }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.viewModel.loggedIn()
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

}
