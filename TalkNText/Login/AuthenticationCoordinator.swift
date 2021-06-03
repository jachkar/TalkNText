//
//  AuthenticationCoordinator.swift
//  Zong
//
//  Created by Julien Achkar on 11/11/20.
//

import Foundation
import UIKit

protocol AuthenticationCoordinatorDelegate: class {
    func authenticationCoordinatorDidFinish(authenticationCoordinator: AuthenticationCoordinator)
}

class AuthenticationCoordinator: Coordinator {
    
    weak var delegate: AuthenticationCoordinatorDelegate?
    
    let window: UIWindow?
    
    let rootViewController: UINavigationController = {
        return UINavigationController()
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        let viewModel = LoginViewModel()
        viewModel.coordinatorDelegate = self
        let viewController = AppDelegate.storyBoard.getViewController(identifier: .login) as! LoginViewController
        viewController.viewModel = viewModel
        
        rootViewController.setViewControllers([viewController], animated: false)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    override func finish() {
        delegate?.authenticationCoordinatorDidFinish(authenticationCoordinator: self)
    }
}

extension AuthenticationCoordinator: LoginViewModelCoordinatorDelegate {
    func didSelectSignUp() {
    }
    
    func loginViewModelDidFinish(viewModel: LoginViewModel) {
        finish()
    }
}
