//
//  HomeCoordinator.swift
//  TalkNText
//
//  Created by Julien Achkar on 17/11/2020.
//

import Foundation
import UIKit

protocol HomeCoordinatorDelegate: class {
    
}

class HomeCoordinator: Coordinator {
    
    weak var delegate: HomeCoordinatorDelegate?
    
    var tabBarController: UITabBarController?
    
    let rootViewController: UINavigationController = {
        return UINavigationController()
    }()
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    override func start() {
        let viewModel = HomeViewModel()
        viewModel.coordinatorDelegate = self
        let viewController = AppDelegate.storyBoard.getViewController(identifier: .home) as! HomeViewController
        viewController.viewModel = viewModel
        
        rootViewController.setViewControllers([viewController], animated: false)
        rootViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "Home"), selectedImage: UIImage(named: "Home"))
        
        if tabBarController?.viewControllers == nil {
            tabBarController?.viewControllers = [rootViewController]
        } else {
            tabBarController?.viewControllers?.append(rootViewController)
        }
    }
    
    func startChat() {
        
    }
    
    override func finish() {
        
    }
}

extension HomeCoordinator: HomeViewModelCoordinatorDelegate {
    func didSelectRoom(index: Int) {
        guard let roomIds = UserDefaults.standard.object(forKey: "roomIds") as? [String] else {
            return
        }
        
        let chatVC = AppDelegate.storyBoard.getViewController(identifier: .chat) as! ChatViewController
        chatVC.roomID = roomIds[index]
        
        self.rootViewController.pushViewController(chatVC, animated: true)
    }
    
    func createRoom(id: String) {
        let chatVC = AppDelegate.storyBoard.getViewController(identifier: .chat) as! ChatViewController
        chatVC.roomID = id
        
        self.rootViewController.pushViewController(chatVC, animated: true)
    }
}

//extension HomeCoordinator: ChatCoordinatorDelegate {
//    func chatCoordinatorDidFinish(chatCoordinator: ChatCoordinator) {
//        removeChildCoordinator(chatCoordinator)
//    }
//}
