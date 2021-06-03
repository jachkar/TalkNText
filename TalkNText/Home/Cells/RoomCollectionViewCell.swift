//
//  RoomCollectionViewCell.swift
//  TalkNText
//
//  Created by Julien Achkar on 20/04/2021.
//

import UIKit

class RoomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var roomTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }

    func customizeCell() {
        bgView.backgroundColor = .clear
        
        imgView.backgroundColor = Constants.Colors.LightGray
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 35
        imgView.contentMode = .scaleAspectFill
        
        roomTitleLbl.font = UIFont(name: Constants.Font.Regular, size: 15)
    }
    
    var roomCollectionViewCellViewModel: RoomCollectionViewCellViewModel? {
        didSet {
            roomTitleLbl.text = roomCollectionViewCellViewModel?.titleText
        }
    }
}

struct RoomCollectionViewCellViewModel {
    let titleText: String
    let detailText: String
    let imageUrl: String
}
