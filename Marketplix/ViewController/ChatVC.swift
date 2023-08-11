//
//  ChatVC.swift
//  Marketplix
//
//  Created by Kiran PM on 28/04/23.
//

import UIKit

struct MessageModel {
    let name : String
    let message: String
}

class ChatVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var messageArr = [MessageModel(name: "Alex", message: "Bike still there?"),
                      MessageModel(name: "Brolin", message: "How much for the car price?"),
                      MessageModel(name: "Joel", message: "I need to know your location") ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ChatCell.identifre, bundle: nil), forCellReuseIdentifier: ChatCell.identifre)
    }
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifre, for: indexPath) as! ChatCell
        let index = messageArr[indexPath.row]
        cell.nameTxt.text = index.name
        cell.msgTxt.text = index.message
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = messageArr[indexPath.row]
        let vc = OpenChatVC.instantiate(fromAppStoryboard: .Main)
        vc.titleSting = index.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
