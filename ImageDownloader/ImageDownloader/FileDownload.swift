//
//  FileDownload.swift
//  ImageDownloader
//
//  Created by ninjaKID on 2/28/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import Foundation

class FileDownload {
    var _nameFile = ""
    var _pathFile = ""
    var _numberOfContent = 0
    var _dataOfContent = [String]()
    
    init(nameFile: String, pathFile: String, numberOfContent: Int, dataOfContent: [String]) {
        self._nameFile = nameFile
        self._pathFile = pathFile
        self._numberOfContent = numberOfContent
        self._dataOfContent = dataOfContent
    }
    
    
}
