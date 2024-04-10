//
//  PostImageVC.swift
//  Marketplix
//
//  Created by Kiran on 07/01/2024.
//

import UIKit
import MBProgressHUD
import Alamofire
class PostImageVC: BaseVC {
    
    @IBOutlet weak var colView: UICollectionView!{
        didSet{
            self.colView.delegate = self
            self.colView.dataSource = self
            self.colView.register(UINib(nibName: GalleryPickerCell.identifire, bundle: nil), forCellWithReuseIdentifier: GalleryPickerCell.identifire)
            let width = 50
            let height = 50
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal //.horizontal
            layout.itemSize = CGSize(width: width, height: height)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.minimumLineSpacing = 20
            layout.minimumInteritemSpacing = 0
            colView.setCollectionViewLayout(layout, animated: true)
            colView.reloadData()
        }
    }
    var postRealEstateArr  = [PostRealEstateModel]()
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageData.append(UIImage(named: "plus-icon")!)
    }
    var imageData = [UIImage]()

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    @IBAction func postPropertyBtn(_ sender: Any) {
        self.imageData.remove(at: 0)
        upLoadProfilePhoto(images: self.imageData)
    }
    
    @IBAction func previewBtn(_ sender: Any) {
        let storyboard = DetailVC.instantiate(fromAppStoryboard: .Main)
        storyboard.postRealEstateArr = self.postRealEstateArr
        self.navigationController?.pushViewController(storyboard, animated: true)
        
    }
    
    func upLoadProfilePhoto(images :[UIImage]?){
        if var image = images{
            MBProgressHUD.showAdded(to: self.view, animated: true)
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
                    })
                    
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let JSON):
                            print(response.result)
                            let data = JSON as AnyObject
                            print("data : ", data)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let storyboard = HomeVC.instantiate(fromAppStoryboard: .Main)
                            self.navigationController?.pushViewController(storyboard, animated: true)
                        
                            
                            break
                        case .failure(let error):
                            print(error)
                            self.showToastLogIn(message: error.localizedDescription)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
    }
}
extension PostImageVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryPickerCell.identifire, for: indexPath) as!  GalleryPickerCell
        cell.delegate = self
        cell.imageVeiw.image = imageData[indexPath.row]
        cell.row = indexPath.row
        if indexPath.row == 0{
            cell.close_btn.isHidden = true
            cell.imageVeiw.contentMode = .scaleAspectFit
        }else{
            cell.close_btn.isHidden = false

            cell.imageVeiw.contentMode = .scaleAspectFill
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.imageData.count > 5{
            return

        }
        let alert = UIAlertController(title: "Select Media", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                self.imagePicker.cameraAsscessRequest()
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                self.imagePicker.photoGalleryAsscessRequest()
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension PostImageVC: GalleryPickerDelegate
{
    func delete(row: Int) {
        self.imageData.remove(at: row)
        self.colView.reloadData()
        if imageData.count <= 0{
            self.colView.isHidden = true
        }
    }
    
    
}
extension PostImageVC: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        self.imageData.append(image)
        
        let imageData = image.jpegData(compressionQuality: 0.10)
        if imageData != nil {
        }
        imagePicker.dismiss()
        self.colView.reloadData()
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}
