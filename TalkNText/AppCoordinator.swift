//
//  AppCoordinator.swift
//  TalkNText
//
//  Created by Julien Achkar on 20/04/2021.
//

import Foundation
import UIKit
import GoogleSignIn

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let window: UIWindow?

    // MARK: - Coordinator
    init(window: UIWindow?) {
        self.window = window
    }

    override func start() {
        guard window != nil else {
            return
        }

        if isLoggedIn() {
            startRoot()
        } else {
            startAuth()
        }
    }
    
    private func startRoot() {
        let rootCoordinator = RootCoordinator(window: window)
        rootCoordinator.delegate = self
        addChildCoordinator(rootCoordinator)
        rootCoordinator.start()
    }
    
    private func startAuth() {
        let authCoordinator = AuthenticationCoordinator(window: window)
        authCoordinator.delegate = self
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
    }
    
    private func isLoggedIn() -> Bool {
        if ((GIDSignIn.sharedInstance()?.hasPreviousSignIn())! && GIDSignIn.sharedInstance()?.currentUser != nil) {
            return true
        } else {
            return false
        }
        return false
    }

    override func finish() {

    }
}

extension AppCoordinator: AuthenticationCoordinatorDelegate {
    func authenticationCoordinatorDidFinish(authenticationCoordinator: AuthenticationCoordinator) {
        removeChildCoordinator(authenticationCoordinator)
        startRoot()
    }
}

extension AppCoordinator: RootCoordinatorDelegate {
    func rootCoordinatorDidFinish(rootCoordinator: RootCoordinator) {
        removeChildCoordinator(rootCoordinator)
        startAuth()
    }
}
