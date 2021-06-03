//
//  VideoChatCoordinator.swift
//  TalkNText
//
//  Created by Julien Achkar on 17/11/2020.
//

import Foundation
import UIKit
import WebRTC

protocol VideoChatCoordinatorDelegate: class {
    
}

class VideoChatCoordinator: Coordinator {
    
    weak var delegate: VideoChatCoordinatorDelegate?
    
    var tabBarController: UITabBarController?

    let rootViewController: UINavigationController = {
        return UINavigationController()
    }()
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    override func start() {
        let viewModel = MainVideoChatViewModel()
        viewModel.coordinatorDelegate = self
        let viewController = AppDelegate.storyBoard.getViewController(identifier: .mainVideo) as! MainVideoChatViewController
        viewController.viewModel = viewModel
        
        rootViewController.setViewControllers([viewController], animated: false)
        rootViewController.tabBarItem = UITabBarItem(title: "VideoChat", image: UIImage(named: "video"), selectedImage: UIImage(named: "video"))
        
        if tabBarController?.viewControllers == nil {
            tabBarController?.viewControllers = [rootViewController]
        } else {
            tabBarController?.viewControllers?.append(rootViewController)
        }
    }
    
    override func finish() {
        
    }
}

extension VideoChatCoordinator: VideoChatViewModelCoordinatorDelegate {
    func didFinish() {
        rootViewController.popViewController(animated: true)
    }
}

extension VideoChatCoordinator: MainVideoChatViewModelCoordinatorDelegate {    
    func didStartCall(webRTCClient: WebRTCClient) {
        DispatchQueue.main.async {
            let viewModel = VideoChatViewModel(webRTCClient: webRTCClient)
            viewModel.coordinatorDelegate = self
            let viewController = AppDelegate.storyBoard.getViewController(identifier: .videoChat) as! VideoChatViewController
            viewController.viewModel = viewModel
            self.rootViewController.pushViewController(viewController, animated: true)
        }
    }
}
