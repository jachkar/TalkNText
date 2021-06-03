//
//  HomeViewController.swift
//  TalkNText
//
//  Created by Julien Achkar on 17/11/2020.
//

import UIKit

class HomeViewController: BaseViewController {
    
    var viewModel: HomeViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        handleCallbacks()
        
        viewModel.processFetchedData()
    }
    
    func setupView() {
        self.title = "Rooms"
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "create"), style: .plain, target: self, action: #selector(didPressCreate))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        setupTableView()
    }
    
    
    @objc func didPressCreate() {
        Utilities.showTextPopup(viewController: self, title: "", message: "") { (input) in
            self.viewModel.createRoom(id: input)
        }
    }
    
    func setupTableView() {
        tableView.backgroundColor = Constants.Colors.BackgroundColor
        tableView.showsVerticalScrollIndicator = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "RoomTableViewCell", bundle: nil), forCellReuseIdentifier: "RoomTableViewCellId")
        tableView.register(UINib(nibName: "CollectionViewTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionViewTableViewCellId")
    }
    
    func handleCallbacks() {
        weak var weakself = self
        
        viewModel.didFetchWithSuccess = {
            weakself?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel.processFetchedData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellViewModel = viewModel.getViewModel(at: indexPath) as? RoomTableViewCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTableViewCellId") as! RoomTableViewCell
            cell.roomTableViewCellViewModel = cellViewModel
            return cell
        } else if let cellViewModel = viewModel.getViewModel(at: indexPath) as? CollectionViewTableViewCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTableViewCellId") as! CollectionViewTableViewCell
            cell.delegate = self
            cell.collectionViewTableViewCellViewModel = cellViewModel
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.getViewModel(at: indexPath) is RoomTableViewCellViewModel {
            viewModel.coordinatorDelegate?.didSelectRoom(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.getHeightForRow(in: indexPath.section))
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Exit Room") { (action, indexPath) in
            let actionSheetController: UIAlertController = UIAlertController(title: "Exit Room", message: "Are you sure you want to exit this room?", preferredStyle: .actionSheet)
            
            let deleteActionButton = UIAlertAction(title: "Exit", style: .destructive)
                { _ in
                self.viewModel.exitRoom(index: indexPath.row)
            }
            actionSheetController.addAction(deleteActionButton)

            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
                { _ in
            }
            actionSheetController.addAction(cancelActionButton)
            
            self.present(actionSheetController, animated: true, completion: nil)
        }
        return [deleteAction]
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func didSelectRoom(index: Int) {
        guard let roomIds = UserDefaults.standard.object(forKey: "roomIds") as? [String] else {
            return
        }
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Select option", message: roomIds[index], preferredStyle: .actionSheet)

        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        actionSheetController.addAction(cancelActionButton)

        let joinActionButton = UIAlertAction(title: "Join", style: .default)
            { _ in
        }
        actionSheetController.addAction(joinActionButton)

        let createActionButton = UIAlertAction(title: "Create", style: .default)
            { _ in
        }
        actionSheetController.addAction(createActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
}
