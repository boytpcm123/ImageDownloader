/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
                Photo represents an image that can be imported.
            
*/

import UIKit
import SSZipArchive

class Photo: NSObject {
    // MARK: Properties

    let imageURL: URL
    
    /// Marked "dynamic" so it is KVO observable.
    dynamic var image: UIImage?
    
    /// The photoImport is KVO observable for its progress.
    dynamic var photoImport: PhotoImport?
    
    // MARK: Initializers

    init(URL: Foundation.URL) {
        imageURL = (URL as NSURL).copy() as! Foundation.URL
        
        image = UIImage(named: "PhotoPlaceholder")
    }
    
    /// Kick off the import
    func startImport() -> Progress {
        let newImport = PhotoImport(URL: imageURL)

        newImport.completionHandler = { data, error in

            if let data = data {
                let fileType = self.imageURL.pathExtension
                
                print(fileType.uppercased())
                switch fileType.uppercased() {
                case FileType.PDF.rawValue:
                    self.image = self.converDataPdfToDataImage(data)
                case FileType.ZIP.rawValue:
                    self.image = self.converDataZipToDataImage(data)
                default:
                    if let image = UIImage(data: data) {
                        // The import is finished. Set our image to the result
                        self.image = image
                    }
                }
               // print(data)
                
               
            }
            else {
                self.reportError(error!)
                
            }

            self.photoImport = nil
        }
        
        newImport.start()
        
        photoImport = newImport
        
        return newImport.progress
    }
    
    func converDataPdfToDataImage(_ data: Data) -> UIImage? {
        let newData = data
        let pdfData = newData as CFData
        let provider:CGDataProvider = CGDataProvider(data: pdfData)!
        let pdfDoc:CGPDFDocument = CGPDFDocument(provider)!
        
        guard let page = pdfDoc.page(at: 1) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height);
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0);
            
            ctx.cgContext.drawPDFPage(page);
        }

        return img
    }
    
    func converDataZipToDataImage(_ data: Data) -> UIImage? {
        let newData = data
        var imageZip: UIImage? = nil
        
        print("Unzip file...")
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let saveFileLocation = UUID().uuidString
            let extractFileLocation = UUID().uuidString
            let fromPath = dir.appendingPathComponent(saveFileLocation)
            let toPath = dir.appendingPathComponent(extractFileLocation)
            var filename: String?
            //writing to directory
            do {
                try newData.write(to: fromPath)
                SSZipArchive.unzipFile(atPath: fromPath.path, toDestination: toPath.path, progressHandler: { (filepath, fileinfo, readByte, totalByte) in
                    if filename == nil {
                        filename = filepath
                    }
                }, completionHandler: { (filelocation, success, err) in
                    if (success) {
                        // Get image after extract
                        print("Get image after extract")
                        var relativepath = extractFileLocation
                        if let filename = filename {
                            relativepath = relativepath.appending("/\(filename)")
                        }
                        let imageUrl = dir.appendingPathComponent(relativepath)
                        do {
                            let imageData = try Data(contentsOf: imageUrl)
                            if let image = UIImage(data: imageData) {
                                imageZip =  image
                            }
                        } catch {
                            
                        }
                    } else {
                      
                    }
                })
                
            } catch (let err) {
                print("Error: \(err.localizedDescription)")
            }
        }
        
       
        
        return imageZip
    }
    
    fileprivate func reportError(_ error: NSError) {
        if error.domain != NSCocoaErrorDomain || error.code != NSUserCancelledError {
            print("Error importing photo: \(error.localizedDescription)")
        }
    }
    
    /// Go back to the initial state.
    func reset() {
        image = UIImage(named: "PhotoPlaceholder")
        photoImport = nil
    }
}
