//
//  BaseViewController.swift
//  TalkNText
//
//  Created by Julien Achkar on 20/04/2021.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.Colors.BackgroundColor
        
        let backButtonImage = UIImage(named: "back_black")
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        
        if #available(iOS 13.0, *) {
            UINavigationBar.appearance().backIndicatorImage = backButtonImage
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        } else {
            self.navigationController?.navigationBar.backIndicatorImage = backButtonImage
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        }
    }
}

