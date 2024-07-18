//
//  ChatVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit
import MBProgressHUD
struct MessageModel {
    let name : String
    let message: String
}

class ChatVC: BaseVC {
    lazy var viewModel: ChatHistoryVM = {
        return ChatHistoryVM()
    }()
    @IBOutlet weak var nodataStack: UIStackView!
    @IBOutlet weak var tableView: UITableView!

    var chatsArr : [Chats] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ChatCell.identifre, bundle: nil), forCellReuseIdentifier: ChatCell.identifre)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViewModel()

    }
    
    // MARK: InitViewModel
    func initViewModel() {
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            let data = _self.viewModel.chatHistoryResponse?.chats ?? []
            _self.chatsArr = data
            if _self.chatsArr.count <= 0 {
                self?.tableView.isHidden = true
            }else{
                self?.tableView.isHidden = false

            }
            DispatchQueue.main.async {
                
                _self.tableView.reloadData()
                
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
        
        viewModel.callChatList()
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifre, for: indexPath) as! ChatCell
        let index = chatsArr[indexPath.row]
        cell.nameTxt.text = index.title
        cell.msgTxt.text = index.chats?.last?.message ?? ""
        cell.selectionStyle = .none
        cell.dateLbl.text = index.chats?.last?.created_at?.convertDateFormat(dateFormat: "dd MMM yyyy")
        let chatCount = index.chats_count ?? 0
        if chatCount > 0{
            cell.countlbl.text = chatCount.description
            cell.countBase.isHidden = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = chatsArr[indexPath.row]
        let vc = OpenChatVC.instantiate(fromAppStoryboard: .Main)
        vc.titleSting = index.title ?? ""
        vc.id = index.id?.description ?? ""

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
