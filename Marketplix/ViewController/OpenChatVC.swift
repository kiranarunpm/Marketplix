//
//  OpenChatVC.swift
//  Marketplix
//
//  Created by Kiran PM on 05/07/23.
//

import UIKit

class OpenChatVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var placeHolder: MPUILabel!
    @IBOutlet weak var msgTxt: UITextView!
    @IBOutlet weak var titleTxt: MPUILabel!
    @IBOutlet weak var tableView: UITableView!
    var titleSting : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.msgTxt.delegate = self
        self.titleTxt.text = titleSting
        tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ChatBubbleLeft.identifire, bundle: nil), forCellReuseIdentifier:  ChatBubbleLeft.identifire)
        self.tableView.register(UINib(nibName: ChatBubbleRight.identifire, bundle: nil), forCellReuseIdentifier:  ChatBubbleRight.identifire)

        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeHolder.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if msgTxt.text.count <= 0{
            self.placeHolder.isHidden = false
        }
    }
}

extension OpenChatVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        if index == 1 || index == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatBubbleRight.identifire, for:indexPath) as! ChatBubbleRight
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatBubbleLeft.identifire, for:indexPath) as! ChatBubbleLeft
            cell.selectionStyle = .none
            return cell
        }

    }

}
