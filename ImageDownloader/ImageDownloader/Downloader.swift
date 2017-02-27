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
    static func data_request(urlRequest: NSURL)
    {
       
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: urlRequest as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {(data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if (statusCode == 200) {
                   print("Everyone is fine, file downloaded successfully.")
                } else  {
                    print("Failed")
                }
            }
            
        });
        
        task.resume()


        
    }
}
