//
//  RoomTableViewCell.swift
//  Zong
//
//  Created by Julien Achkar on 30/11/2020.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: class {
    func didSelectRoom(index: Int)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func customizeCell() {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.itemSize = CGSize(width: 100, height: 100)
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionFlowLayout.minimumInteritemSpacing = 5
        collectionFlowLayout.minimumLineSpacing = 0
        collectionFlowLayout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var collectionViewTableViewCellViewModel: CollectionViewTableViewCellViewModel? {
        didSet {
            collectionView.register(UINib(nibName: "RoomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RoomCollectionViewCellId")
            customizeCell()
        }
    }
}

struct CollectionViewTableViewCellViewModel {
    let roomItems: [RoomCollectionViewCellViewModel]?
    
    init(roomItems: [RoomCollectionViewCellViewModel]? = nil) {
        self.roomItems = roomItems
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let categories = collectionViewTableViewCellViewModel?.roomItems {
            return categories.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let roomItems = collectionViewTableViewCellViewModel?.roomItems {
            let cellRoom = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCollectionViewCellId", for: indexPath as IndexPath) as? RoomCollectionViewCell
            cellRoom!.roomCollectionViewCellViewModel = roomItems[indexPath.row]
            return cellRoom!
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionViewTableViewCellViewModel?.roomItems) != nil {
            delegate?.didSelectRoom(index: indexPath.row)
        }
    }
}
