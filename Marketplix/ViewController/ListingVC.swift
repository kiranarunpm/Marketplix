//
//  ListingVC.swift
//  Marketplix
//
//  Created by Kiran PM on 13/06/23.
//

import UIKit

class ListingVC: UIViewController {

    static let identifire = "ItemViewTabCell"

    @IBOutlet weak var title_Txt: UILabel!
    @IBOutlet weak var colView: UICollectionView!
    var titleSting : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title_Txt.text = titleSting
        colView.register(UINib(nibName: ItemCell.identifire, bundle: nil), forCellWithReuseIdentifier: ItemCell.identifire)
        colView.dataSource = self
        colView.delegate = self
        let screen_width = ScreenSize.SCREEN_WIDTH

        var screenSize = CGSize(width: 0, height: 0)
        if screenSize.height >= 1024{
            screenSize =  CGSize(width: screen_width / 4 - 20, height: 250)
        }
        else{
            screenSize = CGSize(width: screen_width / 2 - 20, height: 250)
        }
        let layout1 = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.itemSize = screenSize
        layout1.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 15)
        
        layout1.minimumLineSpacing = 10
        layout1.minimumInteritemSpacing = 10
        colView.setCollectionViewLayout(layout1, animated: true)
        colView.reloadData()
    
    }
    @IBAction func back_btn(_ sender: Any) {
        self.navigationController?.goBack()
    }
    
    func getScreenSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return screenSize
    }
}
extension ListingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifire, for: indexPath) as! ItemCell
        return cell
    }

}
