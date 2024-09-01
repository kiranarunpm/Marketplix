//
//  OpenChatVC.swift
//  Marketplix
//
//  Created by Kiran PM on 05/07/23.
//

import UIKit
import MBProgressHUD
class OpenChatVC: BaseVC,UITextViewDelegate {
    var isUserBlocked: String = "0"

    @IBOutlet weak var placeHolder: MPUILabel!
    @IBOutlet weak var msgTxt: UITextView!
    @IBOutlet weak var titleTxt: MPUILabel!
    @IBOutlet weak var tableView: UITableView!
    var titleSting : String = ""
    lazy var viewModel: ChatHistoryVM = {
        return ChatHistoryVM()
    }()
    
    var receiverName : String = ""
    
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    lazy var blockUserVM: ChatHistoryVM = {
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
            let senderCount = _self.viewModel.chatDetailsResponse?.chat_details?.chats?.filter({ item in
                return item.sender?.id?.description != User.shared.getSavedData(with: .id)
            })
            
            _self.receiverName = senderCount?.first?.sender?.first_name ?? ""

            if senderCount?.count ?? 0 <= 0 {
                self?.menuBtn.isHidden = true
            }else{
                self?.menuBtn.isHidden = false
            }
            _self.isUserBlocked = _self.viewModel.chatDetailsResponse?.chat_details?.blocked ?? ""
            
            if _self.isUserBlocked == "0"{
                self?.bottom.constant = 0
            }else{
                self?.bottom.constant = -90

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
        
        blockUserVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            _self.isUserBlocked = _self.blockUserVM.blockResponse?.chat?.blocked?.description ?? ""
            if _self.isUserBlocked == "0"{
                self?.bottom.constant = 0
            }else{
                self?.bottom.constant = -90

            }
            DispatchQueue.main.async {
                
            }
        }
        
        blockUserVM.loadingStatus = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let isLoading = _self.blockUserVM.isLoading ?? false
                
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
    
    
    @IBAction func menuBtn(_ sender: Any) {
        if self.isUserBlocked == "0"{
            let alert = UIAlertController(title: "Block \(receiverName)?", message: "Blocked user will no longer be able to send you messages.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Block", style: .destructive , handler:{ (UIAlertAction)in
                self.blockUserVM.callBlockOrUnblockUser(id: self.id)
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))

            
            //uncomment for iPad Support
            //alert.popoverPresentationController?.sourceView = self.view

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }else{
            let alert = UIAlertController(title: "UnBlock \"\(titleSting)\" ?", message: "Un-blocked user will able to send you messages.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Unblock", style: .default , handler:{ (UIAlertAction)in
                self.blockUserVM.callBlockOrUnblockUser(id: self.id)
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))

            
            //uncomment for iPad Support
            //alert.popoverPresentationController?.sourceView = self.view

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
    
    }
    
}

extension OpenChatVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.chatDetailsResponse?.chat_details?.chats?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = self.viewModel.chatDetailsResponse?.chat_details?.chats?.count ?? 0

        let index = self.viewModel.chatDetailsResponse?.chat_details?.chats?[(count - 1) - indexPath.row]
        if index?.sender?.id?.description == User.shared.getSavedData(with: .id){
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
