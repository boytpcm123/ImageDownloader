//
//  Downloader.swift
//  ImageDownloader
//
//  Created by ninjaKID on 2/27/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import Foundation

class Downloader
{
    static func downloadFileZip()
    {
       
        if let audioUrl = URL(string: Const.urlFileZip) {
            // create your document folder url
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // your destination file url
            let destination = documentsUrl.appendingPathComponent(audioUrl.lastPathComponent)
            print(destination)
            // check if it exists before downloading it
            if FileManager().fileExists(atPath: destination.path) {
                print("The file already exists at path")
            } else {
                //  if the file doesn't exist
                //  just download the data from your url
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) in
                    // after downloading your data you need to save it to your destination url
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("audio"),
                        let location = location, error == nil
                        else { return }
                    do {
                        try FileManager.default.moveItem(at: location, to: destination)
                        print("file saved")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }


        
    }
}
