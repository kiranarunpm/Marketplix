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
class DetailVC: BaseVC {
    @IBOutlet weak var descriptionTxt: ReadMoreTextView!
    
    @IBOutlet weak var priceTxt: MPUILabel!
    @IBOutlet weak var nameTxt: MPUILabel!
    @IBOutlet weak var createdOnTxt: MPUILabel!
    @IBOutlet weak var mileTxt: MPUILabel!
    var spec_groups : [Spec_groups] = [Spec_groups]()
    @IBOutlet weak var imageSideShow: ImageSlideshow!
    var isActivatePreview: Bool = false
    @IBOutlet weak var chatBtn: UIButton!
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

    @IBOutlet weak var colView: UICollectionView!{
        didSet{
            colView.delegate = self
            colView.dataSource = self
            colView.register(UINib(nibName: ImageCell.identifire, bundle: nil), forCellWithReuseIdentifier: ImageCell.identifire)
            let screenSize = CGSize(width: 50, height: 50)
            let layout1 = UICollectionViewFlowLayout()
            layout1.scrollDirection = .vertical
            layout1.itemSize = screenSize
            layout1.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)
            layout1.minimumLineSpacing = 10
            layout1.minimumInteritemSpacing = 10
            colView.setCollectionViewLayout(layout1, animated: true)
            colView.reloadData()
        }
    }
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

    }
    
    func showPreview(){
        postRealEstateArr.forEach { item in
            
            item.results?.forEach({ content in
                if content.name == "Title"{
                    self.nameTxt.text = content.value
                }
                
                if content.name == "Price"{
                    self.nameTxt.text = "\(Constants.currencySymbol) \(content.value ?? "")"

                }
                
                if content.name == "Description"{
                    self.nameTxt.text = content.value

                }
                
                if content.name == "Description"{
                    self.nameTxt.text = content.value

                }
            })
        }
        
        var imaged = [ImageSource]()
        
        imageData.forEach({ item in
                imaged.append(ImageSource(image: item))
            }
        )
        
        self.imageSideShow.circular = true
        self.imageSideShow.slideshowInterval = 8
        self.imageSideShow.contentScaleMode = .scaleAspectFill
        self.imageSideShow.setImageInputs(imaged)
        self.imageSideShow.pageIndicatorPosition = PageIndicatorPosition(vertical: .customBottom(padding: 30))
   
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
        self.spec_groups.removeAll()
        viewModel.successClosure = { [weak self] () in
            
            guard let _self = self else { return }
            
            DispatchQueue.main.async {
                let data = _self.viewModel.detailResponsel?.classifield
                _self.nameTxt.text = data?.title ?? ""
                _self.descriptionTxt.text = data?.description ?? ""
                _self.priceTxt.text = "\(Constants.currencySymbol) \(data?.price ?? "")"
                _self.createdOnTxt.text = data?.created_at ?? ""
                
                let is_fav = data?.is_fav ?? 0
                if is_fav == 1{
                    _self.favImg.setImage(UIImage(named: "favorite-filled"), for: .normal)
                }else{
                    _self.favImg.setImage(UIImage(named: "favorite"), for: .normal)
                }
                
                
                var imaged = [KingfisherSource]()
    
               
                
                data?.classified_images?.forEach({ item in
                    if let urlString = item.image_url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                        imaged.append(KingfisherSource(urlString: urlString)!)

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
                add = add + (address?.building_name ?? "")
                add = add + "\n"
                add += (address?.street_name ?? "")
                add = add + "\n"
                add += (address?.sector ?? "")
                add = add + "\n"
                add += (address?.sub_sector ?? "")
                add = add + "\n"
                add += (address?.pincode ?? "")

                
                let specGroup = Spec_items(name: add, value: "")
                _self.spec_groups.append(Spec_groups(name: "Location", spec_items: [specGroup]))
                _self.colView.reloadData()
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
    
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return spec_groups.count 
    }

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        let label = UILabel(frame: CGRectMake(25, 0, tableView.frame.size.width, 18))
        label.font = UIFont.MPfont(.semibold, size: 17)
        label.backgroundColor = UIColor(named: "BackGroundColor")
        let index = spec_groups[section]
        label.text = index.name ?? ""
        label.textAlignment = .left
        view.addSubview(label)
        view.backgroundColor = UIColor(named: "BackGroundColor")
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

        cell.spec_txt?.text = "\(title) \n\(value)"
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
