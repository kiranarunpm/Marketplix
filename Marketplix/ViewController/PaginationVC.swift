//
//  PaginationVC.swift
//  Marketplix
//
//  Created by Kiran P M on 10/08/23.
//

import UIKit
import MBProgressHUD

class PaginationVC: UITableViewController {
    var page: Int = 1
    var isLoading : Bool = false
    var showLoader : Bool = true
    
    var responseObject = [ExampleJson2KtSwift]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCall(page: String(page))
        tableView.register(UINib(nibName: "loaderCell", bundle: nil), forCellReuseIdentifier: "loaderCell")
        tableView.transform = CGAffineTransform (scaleX: -1,y: -1)
    }
    
    func getCall(page: String){
        if showLoader{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        self.isLoading = true
        let url = URL(string: "https://www.refugerestrooms.org/api/v1/restrooms/search?page=\(page)&per_page=15&offset=0&query=san%20francisco")!
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            
            guard let data = data else { return }
            do {
                if let responseObject = try? JSONDecoder().decode([ExampleJson2KtSwift].self, from: data){
                    self?.responseObject.append(contentsOf: responseObject)
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        if ((self?.showLoader) != nil){
                            MBProgressHUD.hide(for: (self?.view)!, animated: true)
                        }
                        self?.tableView.reloadData()
                        
                    }
                    
                }
            }
            
        }
        
        task.resume()
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading && showLoader == false {
            return 2
        }else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return responseObject.count
        }else{
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
            let index = responseObject[indexPath.row]
            cell.title_txt.text = index.name ?? ""
            cell.sub_txt.text = index.city ?? ""
            cell.contentView.transform = CGAffineTransform (scaleX: -1,y: -1)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "loaderCell", for: indexPath) as! loaderCell
            cell.loader = true
            return cell
        }
       
}
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.isLoading{
            return
        }
        let lastItem = self.responseObject.count - 1
        if indexPath.row == lastItem && isLoading == false{
            print("last row", indexPath)
            self.page = self.page + 1
            self.isLoading = true
            self.showLoader = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.getCall(page: String(self.page))
        }else{
            print("not a last row", indexPath)
        }
    }
    

    
}
