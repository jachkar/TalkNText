//
//  LoginViewModel.swift
//  Zong
//
//  Created by Julien Achkar on 11/12/20.
//

import Foundation

protocol LoginViewModelCoordinatorDelegate: class {
    func loginViewModelDidFinish(viewModel: LoginViewModel)
    func didSelectSignUp()
}

class LoginViewModel {
    
    weak var coordinatorDelegate: LoginViewModelCoordinatorDelegate?
    
    func loggedIn() {
        coordinatorDelegate?.loginViewModelDidFinish(viewModel: self)
    }
}
