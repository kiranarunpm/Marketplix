//
//  DetailVC.swift
//  Marketplix
//
//  Created by Kiran on 27/08/23.
//

import UIKit
import ReadMoreTextView
import MBProgressHUD
import ImageSlideshow
import MapKit
class DetailVC: BaseVC {
    @IBOutlet weak var descriptionTxt: ReadMoreTextView!
    
    @IBOutlet weak var priceTxt: MPUILabel!
    @IBOutlet weak var categoryTxt: MPUILabel!

    @IBOutlet weak var nameTxt: MPUILabel!
    @IBOutlet weak var createdOnTxt: MPUILabel!
    @IBOutlet weak var mileTxt: MPUILabel!
    var spec_groups : [Spec_groups] = [Spec_groups]()
    @IBOutlet weak var imageSideShow: ImageSlideshow!
    var isActivatePreview: Bool = false
    @IBOutlet weak var chatBtn: UIButton!
    var distance: String = ""
    @IBOutlet weak var adsIDLbl: MPUILabel!
    @IBOutlet weak var favImg: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCell(DetailSpecCell.identifire)
            tableView.separatorStyle = .none
            tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        }
    }

    var postRealEstateArr  = [PostRealEstateModel]()

    var id = ""
    lazy var viewModel: DetailVM = {
        return DetailVM()
    }()
    
    lazy var favVM: DetailVM = {
        return DetailVM()
    }()
    
    lazy var chatHistoryVM: ChatHistoryVM = {
        return ChatHistoryVM()
    }()
    @IBOutlet weak var chatView: R_UIView!
    @IBOutlet weak var chatViewBtn: UIButton!
    
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var mainScrolllView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    var imageData = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatView.layer.cornerRadius = 20
        descriptionTxt.shouldTrim = true
        descriptionTxt.maximumNumberOfLines = 4
        descriptionTxt.tintColor = UIColor.primaryColor
        let font = UIFont.systemFont(ofSize: 14)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.red,
        ]
        
        descriptionTxt.attributedReadMoreText = NSAttributedString(string: " Read more",attributes: attributes)
        descriptionTxt.attributedReadLessText = NSAttributedString(string: " Read less", attributes: attributes)
        initViewModel()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imageSideShow.addGestureRecognizer(gestureRecognizer)
        imageSideShow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customBottom(padding: 30))
        

    }
    @objc func didTap() {
        imageSideShow.presentFullScreenController(from: self)
    }
    func showPreview(){
        self.adsIDLbl.isHidden = true
        self.reportBtn.isHidden = true
        
        var lat = ""
        var lng = ""
        var sector = ""
        postRealEstateArr.forEach { item in
            
            item.results?.forEach({ content in
                if content.name == "Title"{
                    self.nameTxt.text = content.value
                }
                
                if content.name == "Price"{
                    self.priceTxt.text = "\(Constants.currencySymbol) \(content.value ?? "")"
                }
                
                if content.name == "Description"{
                    self.descriptionTxt.text = content.value
                }
                if content.name == "Sector"{
                    sector = content.value ?? ""
                }
                if content.name == "Lat"{
                    lat = content.value ?? ""
                }
                if content.name == "Long"{
                    lng = content.value ?? ""
                }
                
                
            })
        }
        
        let center = CLLocationCoordinate2D(latitude: Double(lat) ?? 0, longitude: Double(lng) ?? 0)
             let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
        let london = MKPointAnnotation()
        london.title = sector
        london.coordinate = CLLocationCoordinate2D(latitude: Double(lat) ?? 0, longitude: Double(lng) ?? 0)
        self.mapView.delegate = self
        self.mapView.addAnnotation(london)
        
        var imaged = [ImageSource]()
        imageData.removeFirst()
        imageData.forEach({ item in
                imaged.append(ImageSource(image: item))
            }
        )
        
        self.imageSideShow.circular = true
        self.imageSideShow.slideshowInterval = 8
        self.imageSideShow.contentScaleMode = .scaleAspectFill
        self.imageSideShow.setImageInputs(imaged)
        self.imageSideShow.pageIndicatorPosition = PageIndicatorPosition(vertical: .customBottom(padding: 30))
        self.mainScrolllView.alpha = 1

   
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                tableHeight.constant = newsize.height
            }
        }
    }
    
    // MARK: InitViewModel
    func initViewModel() {
        self.mainScrolllView.alpha = 0
        self.spec_groups.removeAll()
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                let data = _self.viewModel.detailResponsel?.classifield
                _self.nameTxt.text = data?.title ?? ""
                _self.descriptionTxt.text = data?.description ?? ""
                _self.priceTxt.text = "\(Constants.currencySymbol) \(data?.price ?? "")"
                let dateFormat = "".dateFormat(data?.created_at ?? "")
                _self.createdOnTxt.text = "Posted on: \(dateFormat)"
                _self.adsIDLbl.text = "AD ID  : \(data?.id ?? 0)"
                
                _self.categoryTxt.text = data?.category?.name ?? ""
                _self.mileTxt.text = self?.distance

                
                let is_fav = data?.is_fav ?? 0
                if is_fav == 1{
                    _self.favImg.setImage(UIImage(named: "favorite-filled"), for: .normal)
                }else{
                    _self.favImg.setImage(UIImage(named: "favorite"), for: .normal)
                }
                
                
                var imaged = [KingfisherSource]()
    
               
                
                data?.classified_images?.forEach({ item in
                    if let urlString = item.image_url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                        imaged.append(KingfisherSource(urlString: urlString ,options: [
                            .loadDiskFileSynchronously,
                            .cacheOriginalImage
                        ])!)

                    }
                })
           
                _self.imageSideShow.circular = true
                _self.imageSideShow.slideshowInterval = 8
                _self.imageSideShow.contentScaleMode = .scaleAspectFill
                _self.imageSideShow.setImageInputs(imaged)
                _self.imageSideShow.pageIndicatorPosition = PageIndicatorPosition(vertical: .customBottom(padding: 30))

                _self.spec_groups = _self.viewModel.detailResponsel?.classifield?.spec_groups ?? []
                let address = data?.addresses
                var add = ""
//                add = add + (address?.building_name ?? "")
//                add = add + "\n"
//                add += (address?.street_name ?? "")
//                add = add + "\n"
                add += (address?.sector ?? "")
//                add = add + "\n"
//                add += (address?.sub_sector ?? "")
//                add = add + "\n"
//                add += (address?.pincode ?? "")

                
                let specGroup = Spec_items(name: add, value: "")
                _self.spec_groups.append(Spec_groups(name: "Location", spec_items: [specGroup]))
                _self.tableView.reloadData()
                
                let center = CLLocationCoordinate2D(latitude: Double(address?.lat ?? "") ?? 0, longitude: Double(address?.lng ?? "") ?? 0)
                     let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                     self?.mapView.setRegion(region, animated: true)
                
                let london = MKPointAnnotation()
                london.title = address?.sector ?? ""
                london.coordinate = CLLocationCoordinate2D(latitude: Double(address?.lat ?? "") ?? 0, longitude: Double(address?.lng ?? "") ?? 0)
                self?.mapView.delegate = self
                self?.mapView.addAnnotation(london)

                self?.mainScrolllView.alpha = 1
                self?.chatView.isHidden = false

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
        
        favVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                let data = _self.favVM.successResponse?.message ?? ""
                _self.viewModel.callDetail(_self.id)

                
                
            }
        }
        
        favVM.loadingStatus = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let isLoading = _self.favVM.isLoading ?? false
                
                if isLoading {
                    MBProgressHUD.showAdded(to: _self.view, animated: true)
                    
                }else {
                    MBProgressHUD.hide(for: _self.view, animated: true)
                }
            }
        }
        
        chatHistoryVM.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            let data = _self.chatHistoryVM.chatIniateResponse
            DispatchQueue.main.async {
                let storyboard = OpenChatVC.instantiate(fromAppStoryboard: .Main)
                storyboard.id = data?.chat_details?.id?.description ?? ""
                storyboard.titleSting = data?.chat_details?.title ?? ""
                _self.navigationController?.pushViewController(storyboard, animated: true)
                
                
            }
        }
        
        chatHistoryVM.failureClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                if let alertMessage = _self.chatHistoryVM.alertMessage {
                    print("alertMessage", alertMessage)
                   
                }
            }
        }
        
        chatHistoryVM.loadingStatus = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                
                let isLoading = _self.chatHistoryVM.isLoading ?? false
                
                if isLoading {
                    MBProgressHUD.showAdded(to: _self.view, animated: true)
                    
                }else {
                    MBProgressHUD.hide(for: _self.view, animated: true)
                }
            }
        }
        
        
        if isActivatePreview{
            self.showPreview()
        }else{
            viewModel.callDetail(self.id)
        }
    }
    
    @IBAction func favBtn(_ sender: Any) {
        favVM.callAddFav(self.id)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    @IBAction func chatViewBtn(_ sender: Any) {
        
        chatHistoryVM.callChatInitiate(["classified_id" : self.id])
    }
    
    
    @IBAction func reportBtn(_ sender: Any) {
        let vc = ReportAdVC.instantiate(fromAppStoryboard: .Main)
        vc.modalPresentationStyle = .overCurrentContext
        vc.id = self.viewModel.detailResponsel?.classifield?.id?.description ?? ""
        vc.delegte = self
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        // Setting description
        let firstActivityItem = self.viewModel.detailResponsel?.classifield?.description ?? ""

            // Setting url
             let data = self.viewModel.detailResponsel?.classifield

            let secondActivityItem : NSURL = NSURL(string: data?.share_url ?? "")!
            
            // If you want to use an image
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [secondActivityItem], applicationActivities: nil)
            
            // This lines is for the popover you need to show in iPad
            activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Pre-configuring activity items
            activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToFacebook
            ]
            
            activityViewController.isModalInPresentation = true
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return spec_groups.count 
    }

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        let label = UILabel(frame: CGRectMake(20, 0, tableView.frame.size.width, 18))
        label.font = UIFont.MPfont(.semibold, size: 17)
        label.backgroundColor = .clear
        let index = spec_groups[section]
        label.text = index.name ?? ""
        label.textAlignment = .left
        view.addSubview(label)
            return view
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spec_groups[section].spec_items?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailSpecCell.identifire, for: indexPath) as! DetailSpecCell
        let index =  spec_groups[indexPath.section].spec_items?[indexPath.row]
        let title = index?.name ?? ""
        let value = index?.value ?? ""

        cell.spec_txt?.text = "\(title) :"
        cell.valueTxt?.text = "\(value)"

        return cell
    }
    
    
}

extension DetailVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.detailResponsel?.classifield?.classified_images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifire, for: indexPath) as! ImageCell
        let index = viewModel.detailResponsel?.classifield?.classified_images?[indexPath.row]
        if let url = index?.image_url{
            if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                let url = URL(string: urlString)
                cell.img.kf.setImage(with: url, placeholder: UIImage(named: "no-image"))
                cell.img.contentMode = .scaleAspectFill
            }
        }
        return cell
    }
    
    
}
extension DetailVC: MKMapViewDelegate, ReportAdDelegate{
    func showSuccessMessage() {
        self.showToastLogIn(message: "Your feedback is sumbmited")
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
