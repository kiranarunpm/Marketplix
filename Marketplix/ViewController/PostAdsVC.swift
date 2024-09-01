//
//  PostAdsVC.swift
//  Marketplix
//
//  Created by Kiran on 02/10/23.
//

import UIKit
import MBProgressHUD
import Alamofire
class PostAdsVC: BaseVC {
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    var postRealEstateArr  = [PostRealEstateModel]()
    var editData : DataList?

    var imageData = [UIImage]()
    
    var isOnEdit = false

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCell(ChooseTextCell.identifire)
            tableView.registerCell(TextCell.identifire)
            tableView.registerCell(RadioButtonCell.identifire)
            tableView.registerCell(DescriptionTextCell.identifire)

            tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            
        }
    }

    lazy var categoryVM: HomeVM = {
        return HomeVM()
    }()
    
    lazy var getPostValues: PostAdsVM = {
        return PostAdsVM()
    }()
    
    
    lazy var homeVM: HomeVM = {
        return HomeVM()
    }()
    
    lazy var specGroupVM: PostAdsVM = {
        return PostAdsVM()
    }()
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                tableViewHeight.constant = newsize.height
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageData.append(UIImage(named: "plus-icon")!)

        initViewModel()
    }
    // MARK: InitViewModel
    func initViewModel() {
        
      
        categoryVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let details = _self.categoryVM.categoryArr
                _self.tableView.reloadData()
                
            }
        }
        
        homeVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
            }
        }
        
        specGroupVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            var data = _self.specGroupVM.specModel?.spec_groups ?? []
            if _self.isOnEdit{
                data = _self.editData?.spec_groups ?? []
                
            }
            

            data.forEach { item in
                var result = [PostRealEstateModel]()
                
                item.spec_items?.forEach({ content in
                    result.append(PostRealEstateModel(key: "\("specitem")_\(content.id ?? 0)",name: content.name ?? "",value: content.value ?? "", type: "text",required: true, results: []))
                })
                _self.postRealEstateArr.append(PostRealEstateModel(key: "", name: item.name ?? "", results: result))

                
            }
            DispatchQueue.main.async {
                _self.tableView.reloadData()
            }
            
            
        }
        
        categoryVM.callMainCategory(mainCategory: "")
        
        var i = 0
        postRealEstateArr.first?.results?.forEach({ item in
            if item.name == "Category"{
                self.specGroupVM.callSpecGroup(item.value ?? "")
            }
            if isOnEdit{
                if item.name == "Title"{
                    let title = self.editData?.title ?? ""
                    self.postRealEstateArr[0].results?[i].value = title
                }
                if item.name == "Description" {
                    let description = self.editData?.description ?? ""
                    self.postRealEstateArr[0].results?[i].value = description
                }
                if item.name == "Price" {
                    let price = self.editData?.price ?? ""
                    self.postRealEstateArr[0].results?[i].value = price
                }
           
            }
            i += 1
        })
        

        

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    @IBAction func postBtn(_ sender: Any) {
        
        var validation : Bool = true
        
        postRealEstateArr.forEach { item in
            if item.name != "Location Details"{
                item.results?.forEach({ item in
                    if item.name == "Category" || item.name == "Type"{
                        
                    }else{
                        if item.name == "Title" || item.name == "Description" || item.name == "Price"{
                            if item.value == "" {
                                print("validation", "Please Enter \(item.name)")
                                self.showToastLogIn(message: "Please Enter \(item.name ?? "")")

                                validation = false
                                return
                            }
                        }
                        
//                        if item.value == "" {
//                            print("validation", "Please Enter \(item.name)")
//                            validation = false
//                            return
//                        }
                    }
                    
                })
            }
        }
//        upLoadProfilePhoto(images: imageData)
        if validation{
            let storyboard = PostProperty2VC.instantiate(fromAppStoryboard: .Main)
            storyboard.postRealEstateArr = self.postRealEstateArr
            storyboard.editData = self.editData
            storyboard.isOnEdit = self.isOnEdit
            self.navigationController?.pushViewController(storyboard, animated: true)
        }else{
//            self.showToastLogIn(message: "Please enter All the fields")
        }
        
       

    }
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    

    
}

extension PostAdsVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let filter = postRealEstateArr.filter { item in
            if item.name == "Location Details"{
                return false
            }else{
                return true
            }
        }
        return filter.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let filter = postRealEstateArr.filter { item in
            if item.name == "Location Details"{
                return false
            }else{
                return true
            }
        }
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
            let label = UILabel(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        label.font = UIFont.MPfont(.semibold, size: 17)
            label.text = filter[section].name ?? ""
        label.textAlignment = .center
            view.addSubview(label)

            return view
     }
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let filter = postRealEstateArr.filter { item in
            if item.name == "Location Details"{
                return false
            }else{
                return true
            }
           
        }
        let filter2 = filter[section].results?.filter({ item in
            if item.name == "Category" || item.name == "Type"{
                return false
            }else{
                return true
            }
        })
        return filter2?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = postRealEstateArr.filter { item in
            if item.name == "Location Details"{
                return false
            }else{
                return true
            }
           
        }
        let filter2 = filter[indexPath.section].results?.filter { item in
            if item.name == "Category" || item.name == "Type"{
                return false
            }else{
                return true
            }
        }
        let index = filter2?[indexPath.row]
        if index?.type == "text"{
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifire, for: indexPath) as! TextCell
            cell.nameTxt.text = index?.name
            cell.valueTxt.text = index?.value
            cell.valueTxt.placeholder = index?.name
            cell.delegate = self
            cell.valueTxt.keyboardType = index?.keyboard ?? "" == "number" ? .decimalPad : .default
            cell.index = indexPath
            return cell
        }
        
        else if index?.type == "textView"{
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTextCell.identifire, for: indexPath) as! DescriptionTextCell
            cell.nameTxt.text = index?.name
            cell.valueTxt.text = index?.value
//            cell.valueTxt.placeholder = index?.name
            cell.delegate = self
            cell.selectionStyle = .none
            cell.valueTxt.keyboardType = index?.type ?? "" == "textView" ? .default : .numberPad
            cell.index = indexPath
            return cell
        }
        else if index?.type == "select"{
            let cell = tableView.dequeueReusableCell(withIdentifier: ChooseTextCell.identifire, for: indexPath) as! ChooseTextCell
            cell.nameTxt.text = index?.name
            cell.valueTxt.text = index?.value
            cell.valueTxt.placeholder = index?.name
            return cell
        }
        
        else if index?.type == "radio"{
            return UITableViewCell()

            let cell = tableView.dequeueReusableCell(withIdentifier: RadioButtonCell.identifire, for: indexPath) as! RadioButtonCell
            if index?.value == "1"{
                cell.sellImg.image = UIImage(named: "radio-active")
                cell.rentImg.image = UIImage(named: "radio-inactive")

            }else{
                cell.sellImg.image = UIImage(named: "radio-inactive")
                cell.rentImg.image = UIImage(named: "radio-active")
            }
            cell.index = indexPath
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = postRealEstateArr.first?.results?.filter { item in
            if item.name == "Category" || item.name == "Type"{
                return false
            }else{
                return true
            }
        }
//        let index = filter?[indexPath.row]
//        if index?.type == "select"{
//            let vc = SelectVC.instantiate(fromAppStoryboard: .Main)
//            vc.modalPresentationStyle = .overCurrentContext
//            if index?.name == "Type"{
//                vc.categoryArr = categoryVM.categoryArr
//            }else{
//                vc.categoryArr = homeVM.categoryArr
//            }
//            vc.delegate = self
//            vc.index = indexPath
//            vc.nameString = index?.name ?? ""
//            self.navigationController?.present(vc, animated: true)
//        }
    }
    
    
}

extension PostAdsVC: TextCellDelegate, SelectVCDelegate, RadioButtonDelegate, DescriptionTextDelegate{
    func radioHandler(value: String, index: IndexPath) {
        print("value", value)
        var i = 0
    
        postRealEstateArr[index.section].results?.forEach { item in
            if i == index.row{
                postRealEstateArr[index.section].results?[i].value = value
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            i += 1
        }
    }
    
    func setvalue(value: String, index: IndexPath) {
        print("value", value)
        var section = 0
        if index.section == 0{
            section = 0
        }else{
            section = index.section + 1
        }
        var i = 0

        for _ in postRealEstateArr[section].results ?? []{
            if i == index.row{
                postRealEstateArr[section].results?[index.row].value = value
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
                break
            }
            i += 1
        }
    }
    
    

    
    func selectedIndex(category: Category, index: IndexPath, nameString: String) {
        print("value", category.name ?? "")
        
        postRealEstateArr[index.section].results?.forEach( { item in
                postRealEstateArr[index.section].results?[index.row].value = category.name ?? ""
            postRealEstateArr[index.section].results?[index.row].id = category.id?.description ?? ""


                
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        if nameString == "Category"{
            self.specGroupVM.callSpecGroup(category.id?.description ?? "")
        }else{
            self.homeVM.callCategory(category.id?.description ?? "")
        }

    }
                
  
    
}





import UIKit
import AVFoundation
import Photos

protocol ImagePickerDelegate: class {
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType)
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage)
    func cancelButtonDidClick(on imageView: ImagePicker)
}

class ImagePicker: NSObject {
    
    private weak var controller: UIImagePickerController?
    weak var delegate: ImagePickerDelegate? = nil
    
    func dismiss() { controller?.dismiss(animated: true, completion: nil) }
    func present(parent viewController: UIViewController, sourceType: UIImagePickerController.SourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        self.controller = controller
        DispatchQueue.main.async {
            viewController.present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: Get access to camera or photo library

extension ImagePicker {
    
    private func showAlert(targetName: String, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertVC = UIAlertController(title: "Access to the \(targetName)",
                                            message: "Please provide access to your \(targetName)",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                guard   let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                        UIApplication.shared.canOpenURL(settingsUrl) else { completion?(false); return }
                UIApplication.shared.open(settingsUrl, options: [:]) { [weak self] _ in
                    self?.showAlert(targetName: targetName, completion: completion)
                }
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in completion?(false) }))
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?
                .rootViewController?.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func cameraAsscessRequest() {
        if delegate == nil { return }
        let source = UIImagePickerController.SourceType.camera
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            delegate?.imagePicker(self, grantedAccess: true, to: source)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    self.delegate?.imagePicker(self, grantedAccess: granted, to: source)
                } else {
                    self.showAlert(targetName: "camera") { self.delegate?.imagePicker(self, grantedAccess: $0, to: source) }
                }
            }
        }
    }
    
    func photoGalleryAsscessRequest() {
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            let source = UIImagePickerController.SourceType.photoLibrary
            if result == .authorized {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.imagePicker(self, grantedAccess: result == .authorized, to: source)
                }
            } else {
                self.showAlert(targetName: "photo gallery") { self.delegate?.imagePicker(self, grantedAccess: $0, to: source) }
            }
        }
    }
}

// MARK: UINavigationControllerDelegate

extension ImagePicker: UINavigationControllerDelegate { }

// MARK: UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: image)
            return
        }
        
        if let image = info[.originalImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: image)
        } else {
            //            videoURL = info[UIImagePickerControllerMediaURL]as? NSURL
            //            print(videoURL!)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.cancelButtonDidClick(on: self)
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
