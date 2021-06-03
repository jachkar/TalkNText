//
//  SongDropDownViewCell.swift
//  Zong
//
//  Created by Tarek on 21/01/2021.
//

import UIKit
import DropDown

class SelectIDDropDownViewCell : DropDownCell {
    
    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var optionLbl: UILabel!
    @IBOutlet weak var optionIconImgView: UIImageView!
    @IBOutlet weak var arrowImgView: UIImageView!
    
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    //To fix a bad practice from DropDown configure cell implementation
    override weak var optionLabel: UILabel! {
        get {
            return optionLbl
        }
        set {
            optionLbl = newValue
        }
    }
    
    override func awakeFromNib() {
        customizeCell()
    }
    
    func customizeCell() {
        self.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9254901961, alpha: 1)
        
        optionLbl.font = UIFont(name: Constants.Font.Regular, size: 17)
       
        switchLabel.font = UIFont(name: Constants.Font.Regular, size: 15)
        
        arrowImgView.image = UIImage(named: "right_arrow")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        arrowImgView.tintColor = #colorLiteral(red: 0.4470588235, green: 0.4352941176, blue: 0.4352941176, alpha: 1)
     
        optionIconImgView.tintColor = #colorLiteral(red: 0.4470588235, green: 0.4352941176, blue: 0.4352941176, alpha: 1)
    }
    
    var selectIDDropDownCellViewModel: SelectIDDropDownCellViewModel? {
        didSet {
            optionLbl.text = selectIDDropDownCellViewModel?.titleText
        }
    }
}

struct SelectIDDropDownCellViewModel {
    let titleText: String
}
