//
//  ViewController.swift
//  TestSearchGif
//
//  Created by admin on 7/20/19.
//  Copyright © 2019 Alexey Sen. All rights reserved.
//

import UIKit
import FLAnimatedImage

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    
    
    struct BaseUrls {
        static let accessKey = "PBtMCauAksBzHMdKa5bhHaoogzxaLbnu"
        static let urlSearchPhotos = "https://api.giphy.com/v1/gifs/search?api_key=\(BaseUrls.accessKey)"

    }
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
    var results = [Gif]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.delegate = self
        collectionView.backgroundColor = .darkGray
        collectionView.register(GifCustomCell.self, forCellWithReuseIdentifier: cellId)
        
        
        searchBar.placeholder = "Search Photo"
        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("resultssss -> \(results.count)")
        if results.count != 0 {
            return results.count
        }
        return 0
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GifCustomCell
        
        let urlString = results[indexPath.row]
        let url = URL(string: urlString.images.original_still.url)!
        let imageData = try? Data(contentsOf: url)
        cell.gifImageView.image = UIImage(data: imageData!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getGifs(searchText: searchBar.text)
    }


}

extension ViewController {
    func getGifs(searchText: String? = nil) {
        guard let downloadURL = URL(string: BaseUrls.urlSearchPhotos + "&q=" + searchText! + "&limit=2147483647") else { return }
        let task = URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
            
            
            guard let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(GifFile.self, from: data)
            //print("Image DATA:\(String(describing: imageData.results.first?.urls.regular))")
            guard imageData.data.first?.images.original_still.url != nil else {
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Bad query", message: "No gif found for this request. Please enter a valid request.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            self.results = imageData.data
            
            for item in self.results {
                print("Item: \(item.images.original_still.url)")
            }
            /*
            guard let imagePhoto = URL(string: (imageData.data.first?.url)!) else { return }
            let task = URLSession.shared.dataTask(with: imagePhoto, completionHandler: { (data, response, error) in
                guard let data = data else {return}
                
                print("MY DATA: \(String(describing: data.count))")
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.searchBar.text = ""
                }
                
            })
            task.resume()
            */
        }
        task.resume()
    }
}


