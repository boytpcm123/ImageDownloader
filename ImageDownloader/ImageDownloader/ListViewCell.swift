//
//  ListViewCell.swift
//  ImageDownloader
//
//  Created by ninjaKID on 2/27/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import UIKit

/// The KVO context used for all `PhotoCollectionViewCell` instances.
private var photoCollectionViewCellObservationContext = 0

class ListViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageFile: UIImageView!
    @IBOutlet weak var statusFile: UILabel!
    
    fileprivate let fractionCompletedKeyPath = "photoImport.progress.fractionCompleted"
    
    fileprivate let imageKeyPath = "image"
    
    var photo: Photo? {
        willSet {
            if let formerPhoto = photo {
                formerPhoto.removeObserver(self, forKeyPath: fractionCompletedKeyPath, context: &photoCollectionViewCellObservationContext)
                formerPhoto.removeObserver(self, forKeyPath: imageKeyPath, context: &photoCollectionViewCellObservationContext)
            }
        }
        
        didSet {
            if let newPhoto = photo {
                newPhoto.addObserver(self, forKeyPath: fractionCompletedKeyPath, options: [], context: &photoCollectionViewCellObservationContext)
                newPhoto.addObserver(self, forKeyPath: imageKeyPath, options: [], context: &photoCollectionViewCellObservationContext)
            }
            
            updateImageView()
            updateProgressView()
        }
    }
    
    fileprivate func updateProgressView() {
        if let photoImport = photo?.photoImport {
            let fraction = Float(photoImport.progress.fractionCompleted)
            statusFile.text = String(format: "Downloading %.0f%%", fraction * 100)
            
            //statusFile.isHidden = false
        }
        else {
            //statusFile.isHidden = true
            statusFile.text = String("Downloaded")
        }
    }
    
    fileprivate func updateImageView() {
        UIView.transition(with: imageFile, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imageFile.image = self.photo?.image
        }, completion: nil)
    }
    
    // MARK: Key-Value Observing
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &photoCollectionViewCellObservationContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        OperationQueue.main.addOperation {
            if keyPath == self.fractionCompletedKeyPath {
                self.updateProgressView()
            }
            else if keyPath == self.imageKeyPath {
                self.updateImageView()
            }
        }
    }
    
    
}
