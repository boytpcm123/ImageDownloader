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
    
    init(nameFile: String, numberOfContent: Int) {
        self._nameFile = nameFile
        let fileName = self._nameFile+".json"
        self._pathFile = Const.documentsUrl.appendingPathComponent(fileName).path
        self._numberOfContent = numberOfContent
    }
    
    
}
