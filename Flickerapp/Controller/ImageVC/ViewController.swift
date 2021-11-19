//
//  ViewController.swift
//  Flickerapp
//
//  Created by Apple on 18/11/21.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate {
   
    @IBOutlet var headerView : UIView!
    @IBOutlet var bodyView : UIView!
    @IBOutlet var collctionview : UICollectionView!
    @IBOutlet weak var imageSeachBar: UISearchBar!
    var searchDone: Bool!
    var strsearch = String()
    
    var arrImageData = [ImageViewModle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchDone = true
        
        //self.collctionview.dataSource = self
        //self.collctionview.delegate = self
        
        let cellNib = UINib(nibName: "ImageCC", bundle: nil)
        self.collctionview.register(cellNib, forCellWithReuseIdentifier: "ImageCC")
        getImageData(strimageName: "kittens")
        
    }
    
    func getImageData(strimageName : String){
        
        addHUD()
        
        Service.shareIntance.getAllPhoto(withName: strimageName){(photos, error) in
            
            if(error == nil)
            {
                self.arrImageData = photos?.map({return ImageViewModle(Image: $0)}) ?? []
               // print(self.arrImageData)
                DispatchQueue.main.sync {
                    self.collctionview.reloadData()
                    self.CollectionFlowLayout()
                    self.removeHUD()
                }
            }
            else
            {
                self.removeHUD()
            }
        }
    }
    
    func CollectionFlowLayout ()
    {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize =  CGSize(width:(self.collctionview.frame.size.width - 7)/3 ,height: (self.collctionview.frame.size.width - 7)/3)
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 1.0
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        self.collctionview.collectionViewLayout = flowLayout
        self.collctionview.showsVerticalScrollIndicator = false
        
    }
    
    //MARK: - SearchBar Delegate Methods -
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            
            if searchDone {
                
                DispatchQueue.main.async {
                    
                    searchBar.showsCancelButton = false
                    searchBar.endEditing(true)
                    self.searchDone = false
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        if !(searchBar.text?.isEmpty)! {
            
            print(searchBar.text!)
            
            getImageData(strimageName: searchBar.text!)
            self.searchDone = true
            
            self.view.endEditing(true)
        } else {
            
            self.view.endEditing(true)
            searchDone = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        if searchDone {
            getImageData(strimageName: "kittens")
            self.searchDone = false
        }
    }
}
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCC", for: indexPath) as? ImageCC {
            
            let imgData = arrImageData[indexPath.row]
            let strServer = imgData.server ?? ""
            let strid = imgData.id ?? ""
            let strsecret = imgData.secret ?? ""
            
            let imgURL = String(format: "%@/%@/%@_%@.jpg", GlobalVar.IMAGEURL,strServer,strid,strsecret)
            
            //print(imgURL)
            
            cell.imgView?.downloadImageFrom(link: imgURL, contentMode: UIImageView.ContentMode.scaleAspectFill)
            
            return cell
        }
        return UICollectionViewCell()
    }
}
