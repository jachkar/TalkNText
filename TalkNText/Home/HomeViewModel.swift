//
//  HomeViewModel.swift
//  TalkNText
//
//  Created by Julien Achkar on 17/11/2020.
//

import Foundation

protocol HomeViewModelCoordinatorDelegate: class {
    func didSelectRoom(index: Int)
    func createRoom(id: String)
}

class HomeViewModel {
    
    weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
    
    func processFetchedData() {
        guard let roomIds = UserDefaults.standard.object(forKey: "roomIds") as? [String] else {
            return
        }
        
        var roomTableViewCellViewModels = [RoomTableViewCellViewModel]()
        
        for id in roomIds {
            roomTableViewCellViewModels.append(createCellViewModel(id: id))
        }

        self.roomTableViewCellViewModels = roomTableViewCellViewModels
        
        var collectionViewItems: [CollectionViewTableViewCellViewModel] = []
        var roomCollectionViewCellViewModels = [RoomCollectionViewCellViewModel]()
        
        for id in roomIds {
            roomCollectionViewCellViewModels.append(createCellViewModel(id: id))
        }
        
        collectionViewItems.append(CollectionViewTableViewCellViewModel(roomItems: roomCollectionViewCellViewModels))
        self.collectionViewItems = collectionViewItems
        
        self.didFetchWithSuccess?()
    }
    
    func getViewModel(at indexPath: IndexPath) -> Any? {
        if indexPath.section == 0 {
            return collectionViewItems[0]
        } else if indexPath.section == 1 {
            return roomTableViewCellViewModels[indexPath.row]
        }
        return nil
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        if section == 0 {
            return !collectionViewItems.isEmpty ? 1 : 0
        } else if section == 1 {
            return roomTableViewCellViewModels.count
        }
        return 0
    }
    
    func getNumberOfSections() -> Int {
        return 2
    }
    
    func getHeightForRow(in section: Int) -> Int {
        if section == 0 {
            return 100
        } else if section == 1 {
            return 70
        }
         
        return 0
    }
    
    func createRoom(id: String) {
        var rooms = [String]()
        
        if let roomsIds = UserDefaults.standard.object(forKey: "roomIds") as? [String] {
            rooms = roomsIds
        }
        
        if !rooms.contains(id) {
            rooms.append(id)
        }
        
        UserDefaults.standard.setValue(rooms, forKey: "roomIds")
        UserDefaults.standard.synchronize()
        
        coordinatorDelegate?.createRoom(id: id)
    }
    
    func exitRoom(index: Int) {
        var rooms = [String]()
        
        guard let roomIds = UserDefaults.standard.object(forKey: "roomIds") as? [String] else {
            return
        }
        
        rooms = roomIds
        rooms.remove(at: index)
        UserDefaults.standard.setValue(rooms, forKey: "roomIds")
        UserDefaults.standard.synchronize()
        
        processFetchedData()
    }
    
    var roomTableViewCellViewModels: [RoomTableViewCellViewModel] = []
    var collectionViewItems: [CollectionViewTableViewCellViewModel] = []
    
    func createCellViewModel(id: String) -> RoomTableViewCellViewModel {
        return RoomTableViewCellViewModel(titleText: id, detailText: "Click to expand", imageUrl: "")
    }
    
    func createCellViewModel(id: String) -> RoomCollectionViewCellViewModel {
        return RoomCollectionViewCellViewModel(titleText: id, detailText: "Click to expand", imageUrl: "")
    }
    
    var isLoading: Bool = false {
        didSet { updateLoadingStatus?() }
    }
    
    var error: String? {
        didSet { showError?() }
    }
    
    var showError: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFetchWithSuccess: (() -> ())?
}

extension HomeViewModel: CollectionViewTableViewCellDelegate {
    func didSelectRoom(index: Int) {

        
        
//        coordinatorDelegate?.showAllCategories()
    }
}


