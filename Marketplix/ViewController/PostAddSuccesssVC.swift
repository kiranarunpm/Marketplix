//
//  PostAddSuccesssVC.swift
//  Marketplix
//
//  Created by Kiran on 05/05/2024.
//

import UIKit
import Alamofire
import CircleProgressBar
class PostAddSuccesssVC: BaseVC {
    var postRealEstateArr  = [PostRealEstateModel]()
    var imageData = [UIImage]()
    
    @IBOutlet weak var progress: CircleProgressBar!
    @IBOutlet weak var messageTxt: UILabel!
    @IBOutlet weak var thankyoLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backBtn.layer.cornerRadius = 32
        upLoadProfilePhoto(images: imageData)
        
    }
    
    @IBAction func backtoHomeBtn(_ sender: Any) {
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabVC") as? MainTabVC else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func upLoadProfilePhoto(images :[UIImage]?){
        
        
        if var image = images{
            var parameters = [String: String]()
            self.postRealEstateArr.forEach { item in
                item.results?.forEach({ content in
                    if content.key != ""{
                        parameters.updateValue(content.value ?? "", forKey: content.key ?? "")
                    }
                    if content.key == "category_id"{
                        parameters.updateValue(content.value ?? "", forKey: content.key ?? "")
                        
                    }
                    
                })
                
            }
            print("parameters", parameters)
            
            let token = "Bearer " + User.shared.token
            let headers = ["Content-Type": "application/x-www-form-urlencoded", "Accept":"application/json","Authorization":token]
            Alamofire.upload(multipartFormData: { multipartFormData in
                if image.count != 0{
                    for img in image {
                        if let imgData = img.jpeg(.lowest){
                            multipartFormData.append(imgData, withName: "images[]",fileName: "\(self.randomString(length: 10)).jpg", mimeType: "image/jpg")
                        }
                    }
                }
                
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                } //Optional for extra parameters
            },
                             to:"https://marketplix.com/api/post-ad",method: .post,headers: headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                        DispatchQueue.main.async {
                            self.progress.setProgress(progress.fractionCompleted, animated: true)
                        }
                        self.thankyoLbl.isHidden = true
                        self.messageTxt.text = "Please wail, Uploading you Ad. "
                        self.backBtn.isHidden = true
                    })
                    
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let JSON):
                            self.progress.isHidden = true
                            self.backBtn.isHidden = false
                            self.thankyoLbl.isHidden = false
                            self.messageTxt.text = "Your Ad Successfully Uploaded"
                            break
                        case .failure(let error):
                            print(error)
                            self.showToastLogIn(message: error.localizedDescription)
                            
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
    }
    
}
