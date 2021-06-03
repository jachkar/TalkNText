//
//  RoomTableViewCell.swift
//  TalkNText
//
//  Created by Julien Achkar on 20/04/2021.
//

import UIKit
import DropDown

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var roomTitleLbl: UILabel!
    @IBOutlet weak var roomDetailLbl: UILabel!
    @IBOutlet weak var roomMoreInfoBtn: UIButton!
    let dropDown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
        configureDropDown()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func configureDropDown() {
        DropDown.appearance().setupCornerRadius(10)
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        
        dropDown.anchorView = roomMoreInfoBtn
        dropDown.width = 200
        dropDown.dismissMode = .automatic
        
        dropDown.topOffset = CGPoint(x: -dropDown.width!, y: 10)
        dropDown.bottomOffset = CGPoint(x: -dropDown.width!, y: 10)
        
        dropDown.cellNib = UINib(nibName: "RoomDropDownViewCell", bundle: nil)
       
        dropDown.customCellConfiguration = {[weak self] (index: Index, item: String, cell: DropDownCell) -> Void in
           guard let cell = cell as? RoomDropDownViewCell else { return }
            cell.roomDropDownCellViewModel = self?.roomTableViewCellViewModel?.dropDownItems[index]
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
        }
    }
    
    func customizeCell() {
        roomTitleLbl.font = UIFont(name: Constants.Font.Bold, size: 17)
        
        roomDetailLbl.font = UIFont(name: Constants.Font.Regular, size: 16)
        
        imgView.layer.cornerRadius = 24.5
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.backgroundColor = Constants.Colors.LightGray
        
        roomMoreInfoBtn.addTarget(self, action: #selector(controlWasPressed), for: .touchUpInside)
    }
    
    @objc func controlWasPressed() {
        dropDown.show()
    }
    
    var roomTableViewCellViewModel: RoomTableViewCellViewModel? {
        didSet {
            roomTitleLbl.text = roomTableViewCellViewModel?.titleText
            roomDetailLbl.text = roomTableViewCellViewModel?.detailText
            dropDown.dataSource = roomTableViewCellViewModel?.dropDownTitles ?? []
        }
    }
}

class RoomTableViewCellViewModel {
    let titleText: String!
    let detailText: String!
    let imageUrl: String!
    
    init(titleText: String, detailText: String, imageUrl: String) {
        self.titleText = titleText
        self.detailText = detailText
        self.imageUrl = imageUrl
        
        setupDropDownCellsVM()
    }
    
    func setupDropDownCellsVM() {
        dropDownItems.append(createDropDownViewModel(title: "Edit", icon:UIImage()))
        dropDownItems.append(createDropDownViewModel(title: "Delete", icon:UIImage()))
        dropDownItems.append(createDropDownViewModel(title: "Favorite", icon:UIImage()))
    }
    
    func createDropDownViewModel(title: String, icon: UIImage) -> RoomDropDownCellViewModel {
        return RoomDropDownCellViewModel(titleText: title, imageIcon: icon)
    }
    
    var dropDownItems: [RoomDropDownCellViewModel] = []

    var dropDownTitles: [String] {
        return dropDownItems.map {$0.titleText}
    }
}
