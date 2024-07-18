//
//  ReportAdVC.swift
//  Marketplix
//
//  Created by Kiran on 02/06/2024.
//

import UIKit
import MBProgressHUD
protocol ReportAdDelegate{
    func showSuccessMessage()
}
class ReportAdVC: BaseVC {
    var delegte: ReportAdDelegate?
    lazy var viewModel: DetailVM = {
        return DetailVM()
    }()
    
    @IBOutlet weak var feedbackBtn: UITextView!
    var id : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            self?.dismiss(animated: true){
                self?.delegte?.showSuccessMessage()
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
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        guard let feedbak = self.feedbackBtn.text, feedbak != "" else {
            showToastLogIn(message: "Please enter your feedback")
            return
        }
        let request = ["classified_id": id, "feedback": feedbak]
        viewModel.callReportAds(request)
        
    }
    
    

}
