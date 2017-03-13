//
//  ListViewController.swift
//  ImageDownloader
//
//  Created by ninjaKID on 2/27/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class ListViewController: UICollectionViewController {

    var indexList:Int!
    
    
    
    @IBOutlet var collectionListImage: UICollectionView!
    
    
    var album: Album? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add right bar button
        let reloadButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ListViewController.OnMenuReloadClicked(_:)))
        self.navigationItem.rightBarButtonItem = reloadButton
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        collectionListImage.reloadData()

        // Do any additional setup after loading the view.
        
        print(album)
    }

    func OnMenuReloadClicked(_ sender: UIBarButtonItem)  {
        print("Reload button click")
    }
    
    


}

extension ListViewController {
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return album?.photos.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ListViewCell

        // Configure the cell

        cell.photo = album?.photos[indexPath.row]
       
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.collectionViewLayout.invalidateLayout()
        
        let cell = collectionView.cellForItem(at: indexPath) as! ListViewCell
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let imageDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        
        if let imageDetail:UIImage = cell.imageFile.image {
            imageDetailViewController.tempImage = imageDetail
        }
        imageDetailViewController.textStatus = String(indexPath.row + 1)+"/"+String(collectionView.numberOfItems(inSection: 0))
        
        present(imageDetailViewController, animated: true, completion: nil)
    }
    
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionViewLayout.invalidateLayout()
    }
    
    //Use for size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let sizeCell = self.view.frame.size.width/3.1
        return CGSize(width: sizeCell, height: sizeCell)
    }
    //Use for interspacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}

