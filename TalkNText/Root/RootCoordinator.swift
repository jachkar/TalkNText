//
//  RootCoordinator.swift
//  TalkNText
//
//  Created by Julien Achkar on 11/11/20.
//

import Foundation
import UIKit

protocol RootCoordinatorDelegate: class {
    func rootCoordinatorDidFinish(rootCoordinator: RootCoordinator)
}

class RootCoordinator: Coordinator, VideoChatCoordinatorDelegate {
    
    weak var delegate: RootCoordinatorDelegate?
    
    let window: UIWindow?
    
    lazy var tabBarController: RootTabBarController = {
        return RootTabBarController()
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func startHome() {
        let homeCoordinator = HomeCoordinator(tabBarController: tabBarController)
        homeCoordinator.delegate = self
        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
    }
    
    func startVideoChat() {
        let videoChatCoordinator = VideoChatCoordinator(tabBarController: tabBarController)
        videoChatCoordinator.delegate = self
        addChildCoordinator(videoChatCoordinator)
        videoChatCoordinator.start()
    }
    
    func startAccount() {

    }
    
    func startSettings() {

    }
    
    override func start() {
        startHome()
        startVideoChat()
        startAccount()
        startSettings()
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
    
    override func finish() {
        
    }
}

extension RootCoordinator: HomeCoordinatorDelegate {
    
}

extension RootCoordinator: AuthenticationCoordinatorDelegate {
    func authenticationCoordinatorDidFinish(authenticationCoordinator: AuthenticationCoordinator) {
        removeChildCoordinator(authenticationCoordinator)
        startHome()
    }
}

//extension RootCoordinator: AccountCoordinatorDelegate {
//    func didLogout() {
//        removeAllChildCoordinators()
        
//        delegate?.rootCoordinatorDidFinish(rootCoordinator: self)
//    }
//}
