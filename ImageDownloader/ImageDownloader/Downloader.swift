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
            // create your document folder url
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            
            
            // your destination file url
            let destination = documentsUrl.appendingPathComponent(fileUrl.lastPathComponent)
            
            let pathFileDocument = documentsUrl.appendingPathComponent(fileUrl.deletingPathExtension().lastPathComponent).path

            
            // check if it exists before downloading it
            if FileManager().fileExists(atPath: destination.path) {
                print("The file already exists at path")
                
                readFile(atPath: pathFileDocument)
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
                       
                        try FileManager.default.moveItem(at: location, to: destination)
                        print("file saved")
                        
                        // Unzip
                        SSZipArchive.unzipFile(atPath: destination.path, toDestination: documentsUrl.path)
                        
                        readFile(atPath: pathFileDocument)
                        
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
        
        for (index, item) in items.enumerated() {
            
            print(index)
            print(item)
            
        }
    }
    
}
