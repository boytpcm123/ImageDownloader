//
//  Downloader.swift
//  ImageDownloader
//
//  Created by ninjaKID on 2/27/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import Foundation
import SSZipArchive

class Downloader
{
    static func downloadFileZip()
    {
   
        
        if let fileUrl = URL(string: Const.urlFileZip) {
            
            // check if it exists before downloading it
            if FileManager().fileExists(atPath: Const.pathZipFile.path) {
                print("The file already exists at path")
                
                readFile(atPath: Const.pathFolderName.path)
            } else {
                //  if the file doesn't exist
                //  just download the data from your url
                URLSession.shared.downloadTask(with: fileUrl, completionHandler: { (location, response, error) in
                    // after downloading your data you need to save it to your destination url
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let location = location, error == nil
                        else { return }
                    do {
                       
                        try FileManager.default.moveItem(at: location, to: Const.pathZipFile)
                        print("file saved")
                        
                        // Unzip
                        SSZipArchive.unzipFile(atPath: Const.pathZipFile.path, toDestination: Const.documentsUrl.path)
                        
                        readFile(atPath: Const.pathFolderName.path)
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
                
                
            }
            
            
            
           
        }

    }

    static func readFile(atPath: String) {
        var items: [String]
        do {
            items = try FileManager.default.contentsOfDirectory(atPath: atPath)
            
        } catch {
            return
        }
        
        
        
        for (_, item) in items.enumerated() {
            if item.hasSuffix("json") {
                if let name:String = (item.components(separatedBy: ".").first) {
                    print(name)
                    let fileDownload: FileDownload = FileDownload(nameFile: name, numberOfContent: 0)
                    Common.ListFileDownload.append(fileDownload)
                    
                }
               
            }
            
        }
        
        //Post a notification
        NotificationCenter.default.post(name: Const.notificationDownloadedZip, object: nil)
    }
    
}
