/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
                Album has an array of Photos loaded from the application bundle
            
*/

import UIKit

class Album: NSObject {
    // MARK: Properties

    var photos: [Photo] = []
    

    // MARK: Initializers

//    override init () {
//        guard let imageURLs = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "Photos") else {
//            fatalError("Unable to load photos")
//        }
//        
// 
//        
//        photos = imageURLs.map { Photo(URL: $0) }
//        
//        if  Common.ListFileDownload.count > 0 {
//            let arraysImage = Common.ListFileDownload[0]._dataOfContent
//            photos = arraysImage.map { Photo(URL: URL(string:$0)!) }
//            print("thong")
//        }
        
        
//    }
    
    func importPhotos() -> Progress {
        
        if  Common.ListFileDownload.count > 0 {
            let arraysImage = Common.ListFileDownload[2]._dataOfContent
            photos = arraysImage.map { Photo(URL: URL(string:$0)!) }
            print("thong")
        }
        
        let progress = Progress()
        progress.totalUnitCount = Int64(photos.count)
        
        for photo in photos {
            let importProgress = photo.startImport()

            progress.addChild(importProgress, withPendingUnitCount: 1)
        }
        
        return progress
    }
    
    func resetPhotos() {
        for photo in photos {
            photo.reset()
        }
    }
}
