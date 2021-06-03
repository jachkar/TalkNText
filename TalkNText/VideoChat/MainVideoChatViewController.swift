//
//  MainVideoChatViewController.swift
//  TalkNText
//
//  Created by Julien Achkar on 21/04/2021.
//

import UIKit
import DropDown

class MainVideoChatViewController: UIViewController {

    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var joinBtn: UIButton!
    
    let dropDown = DropDown()

    var viewModel: MainVideoChatViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        configureDropDown()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func configureDropDown() {
        DropDown.appearance().setupCornerRadius(10)
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        
        dropDown.dataSource = viewModel?.dropDownTitles ?? []

        dropDown.anchorView = selectBtn
        dropDown.width = 200
        dropDown.dismissMode = .automatic
        
        
        dropDown.cellNib = UINib(nibName: "SelectIDDropDownViewCell", bundle: nil)
       
        dropDown.customCellConfiguration = {[weak self] (index: Index, item: String, cell: DropDownCell) -> Void in
           guard let cell = cell as? SelectIDDropDownViewCell else { return }
            cell.selectIDDropDownCellViewModel = self?.viewModel?.dropDownItems[index]
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.viewModel.join(id: item)
        }
    }
    
    func setupView() {
        selectBtn.titleLabel?.font = UIFont(name: Constants.Font.Bold, size: 17)
        createBtn.titleLabel?.font = UIFont(name: Constants.Font.Bold, size: 17)
        joinBtn.titleLabel?.font = UIFont(name: Constants.Font.Bold, size: 17)
    }
    
    @IBAction func joinPressed(_ sender: Any) {
        Utilities.showTextPopup(viewController: self, title: "", message: "") { (input) in
            self.viewModel.join(id: input)
        }
    }
    
    @IBAction func createPressed(_ sender: Any) {
        Utilities.showTextPopup(viewController: self, title: "", message: "") { (input) in
            self.viewModel.create(id: input)
        }
    }
    
    @IBAction func selectPressed(_ sender: Any) {
        dropDown.show()
    }
}
