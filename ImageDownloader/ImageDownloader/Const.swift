//
//  Const.swift
//  ImageDownloader
//
//  Created by ninjaKID on 2/27/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import Foundation

class Const {
    static let urlFileZip = "https://dl.dropboxusercontent.com/u/4529715/JSON%20files%20updated.zip";
    
    static let fileUrl = URL(string: urlFileZip)
    static let fileName = fileUrl?.lastPathComponent
    static let folderName = fileUrl?.deletingPathExtension().lastPathComponent;
    
    // create your document folder url
    static let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    static let pathZipFile = documentsUrl.appendingPathComponent(fileName!)
    static let pathFolderName = documentsUrl.appendingPathComponent(folderName!)
    
    // Define identifier
    static let notificationDownloadedZip = Notification.Name(rawValue: "NotificationDownloadedZip")
    
}
