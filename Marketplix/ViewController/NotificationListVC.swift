//
//  NotificationListVC.swift
//  Marketplix
//
//  Created by Kiran PM on 24/07/24.
//

import Foundation
import UIKit
import MBProgressHUD
class NotificationListVC: UIViewController {
    
    lazy var viewModel: ChatHistoryVM = {
        return ChatHistoryVM()
    }()
    var notifications = [Notifications]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: NotificationCell.identifire, bundle: nil), forCellReuseIdentifier: NotificationCell.identifire)

        initViewModel()

    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    // MARK: InitViewModel
    func initViewModel() {
    
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            let data = _self.viewModel.notificationsReponse?.notifications ?? []
            self?.notifications = data
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
        
        viewModel.failureClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                if let alertMessage = _self.viewModel.alertMessage {
                    print("alertMessage", alertMessage)
                    
                }
            }
        }
        
        viewModel.loadingStatus = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let isLoading = _self.viewModel.isLoading ?? false
                
                if isLoading {
                    MBProgressHUD.showAdded(to: _self.view, animated: true)
                    
                }else {
                    MBProgressHUD.hide(for: _self.view, animated: true)
                }
            }
        }

        
        viewModel.callNotification()

    }
    
}

extension NotificationListVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifire, for: indexPath) as! NotificationCell
        let index = notifications[indexPath.row]
        cell.titleLbl.text = index.title ?? ""
        cell.subTitleLbl.text = index.content ?? ""
        cell.selectionStyle = .none
        return cell
    }
    
    
}
 
