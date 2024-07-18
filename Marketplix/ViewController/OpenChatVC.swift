//
//  OpenChatVC.swift
//  Marketplix
//
//  Created by Kiran PM on 05/07/23.
//

import UIKit
import MBProgressHUD
class OpenChatVC: BaseVC,UITextViewDelegate {

    @IBOutlet weak var placeHolder: MPUILabel!
    @IBOutlet weak var msgTxt: UITextView!
    @IBOutlet weak var titleTxt: MPUILabel!
    @IBOutlet weak var tableView: UITableView!
    var titleSting : String = ""
    lazy var viewModel: ChatHistoryVM = {
        return ChatHistoryVM()
    }()
    
    lazy var sendChat: ChatHistoryVM = {
        return ChatHistoryVM()
    }()
    var chatsArr : [Chats] = []
    var id : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.msgTxt.delegate = self
        self.titleTxt.text = titleSting
        tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ChatBubbleLeft.identifire, bundle: nil), forCellReuseIdentifier:  ChatBubbleLeft.identifire)
        self.tableView.register(UINib(nibName: ChatBubbleRight.identifire, bundle: nil), forCellReuseIdentifier:  ChatBubbleRight.identifire)
        self.tableView.transform = CGAffineTransform(rotationAngle: (-.pi))

        initViewModel()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeHolder.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if msgTxt.text.count <= 0{
            self.placeHolder.isHidden = false
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    
    // MARK: InitViewModel
    func initViewModel() {
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }

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
        
        sendChat.successClosure = { [weak self] () in
            
            guard let _self = self else { return }

            DispatchQueue.main.async {
                _self.viewModel.callChatDetails(_self.id)
                _self.msgTxt.text = ""
                
            }
        }
        
        sendChat.loadingStatus = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let isLoading = _self.sendChat.isLoading ?? false
                
                if isLoading {
                    MBProgressHUD.showAdded(to: _self.view, animated: true)
                    
                }else {
                    MBProgressHUD.hide(for: _self.view, animated: true)
                }
            }
        }
        
        viewModel.callChatDetails(self.id)
    }
    
    
    @IBAction func sendBtn(_ sender: Any) {
        
        let request = ["channel_id":self.id, "message": self.msgTxt.text ?? ""]
        sendChat.callSendBtn(request)
    }
    
}

extension OpenChatVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.chatDetailsResponse?.chat_details?.chats?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = self.viewModel.chatDetailsResponse?.chat_details?.chats?.count ?? 0

        let index = self.viewModel.chatDetailsResponse?.chat_details?.chats?[(count - 1) - indexPath.row]
        if index?.sender?.first_name == User.shared.getSavedData(with: .name){
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatBubbleLeft.identifire, for:indexPath) as! ChatBubbleLeft
            cell.selectionStyle = .none
            cell.txxt.text = index?.message ?? ""
            cell.dateTxt.text = index?.created_at?.convertDateFormat(dateFormat: "dd MMM YYYY")
            cell.transform = CGAffineTransform(rotationAngle: (-.pi))
            cell.nameTxt.text = index?.sender?.first_name?.capitalized ?? "Anonymous"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatBubbleRight.identifire, for:indexPath) as! ChatBubbleRight
            cell.selectionStyle = .none
            cell.txxt.text = index?.message ?? ""
            cell.transform = CGAffineTransform(rotationAngle: (-.pi))

            cell.dateTxt.text = index?.created_at?.convertDateFormat(dateFormat: "dd MMM YYYY")
            cell.nameTxt.text = index?.sender?.first_name?.capitalized ?? "Anonymous"
            return cell
            
          
        }


    }

}
