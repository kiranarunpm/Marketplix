//
//  PostImageVC.swift
//  Marketplix
//
//  Created by Kiran on 07/01/2024.
//

import UIKit
import MBProgressHUD
import Alamofire
import BSImagePicker
import Photos
class PostImageVC: BaseVC {
    
    @IBOutlet weak var colView: UICollectionView!{
        didSet{
            self.colView.delegate = self
            self.colView.dataSource = self
            self.colView.register(UINib(nibName: GalleryPickerCell.identifire, bundle: nil), forCellWithReuseIdentifier: GalleryPickerCell.identifire)
            
            
        }
    }
    var SelectedAssets = [PHAsset]()
    var isOnEdit = false
    var editData : DataList?
    
    var postRealEstateArr  = [PostRealEstateModel]()
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageData.append(UIImage(named: "plus-icon")!)
        
        if isOnEdit{
            let image = editData?.classified_images ?? []
            for item in image {
                guard let convertUrl  = URL(string: item.image_url ?? "") else {return}
                DispatchQueue.global(qos: .background).async {
                    do
                    {
                        let data = try Data.init(contentsOf: convertUrl)
                        DispatchQueue.main.async {
                            let image: UIImage = UIImage(data: data) ?? UIImage()
                            self.imageData.append(image)
                            self.colView.reloadData()

                        }
                    }
                    catch {
                        // error
                    }
                }
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        colView.setCollectionViewLayout(layout, animated: true)
        colView.reloadData()
        
        
        
    }
    var imageData = [UIImage]()
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    @IBAction func postPropertyBtn(_ sender: Any) {
        if imageData.count >= 1{
            self.imageData.remove(at: 0)
        }
        upLoadProfilePhoto(images: self.imageData)
    }
    
    @IBAction func previewBtn(_ sender: Any) {
        let storyboard = DetailVC.instantiate(fromAppStoryboard: .Main)
        storyboard.postRealEstateArr = self.postRealEstateArr
        storyboard.imageData = imageData
        storyboard.isActivatePreview = true
        self.navigationController?.pushViewController(storyboard, animated: true)
        
    }
    
    func upLoadProfilePhoto(images :[UIImage]?){
        if images?.count ?? 0 <= 0{
            self.showToastLogIn(message: "Please choose image")
            return
        }
        
        let storyboard = PostAddSuccesssVC.instantiate(fromAppStoryboard: .Main)
        storyboard.postRealEstateArr = self.postRealEstateArr
        storyboard.imageData = imageData
        storyboard.isOnEdit = self.isOnEdit
        storyboard.editData = editData
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    func loadImagePicker(){
        let imagePicker = ImagePickerController()
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
            }
            self.convertAssetToImages()
            
        })
    }
    
    
    func convertAssetToImages() -> Void {
        
        if SelectedAssets.count != 0{
            
            for i in 0..<SelectedAssets.count{
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                
                var thumbnail = UIImage()
                
                option.isSynchronous = true
                
                manager.requestImage(for: SelectedAssets[i], targetSize: .zero, contentMode: .aspectFill, options: option, resultHandler: {(result,info) -> Void in
                    thumbnail = result!
                })
                
                let data = thumbnail.pngData()
                let newImage = UIImage(data: data!)
                self.imageData.append(newImage! as UIImage)
                self.colView.reloadData()
                self.colView.isHidden = false
                
            }
            
        }
        
    }
}
extension PostImageVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        self.SelectedAssets.removeAll()
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
                self.loadImagePicker()
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.colView.frame.width / 3
        return CGSize(width: width, height: width)
    }
    
    
}

extension PostImageVC: GalleryPickerDelegate
{
    func delete(row: Int) {
        self.imageData.remove(at: row)
        self.SelectedAssets.removeAll()
        self.colView.reloadData()
        if imageData.count <= 0{
            self.colView.isHidden = true
        }
    }
    
    
}
extension PostImageVC: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        self.imageData.append(image)
        
        let imageData = image.jpegData(compressionQuality: 0)
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
