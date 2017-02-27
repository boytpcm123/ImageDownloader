//
//  TableViewCell.swift
//  ImageDownloader
//
//  Created by ninjaKID on 2/27/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import UIKit

class FilesViewCell: UITableViewCell {

    @IBOutlet weak var titleFile: UILabel!
    @IBOutlet weak var statusFile: UILabel!
    @IBOutlet weak var progressFile: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
