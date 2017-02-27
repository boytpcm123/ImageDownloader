//
//  ImageDetailViewViewController.swift
//  ImageDownloader
//
//  Created by ninjaKID on 2/27/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var tempImage: UIImage?
    var textStatus: String!
    
    @IBOutlet weak var imageDetail: UIImageView?
    
    @IBOutlet weak var statusCurrentImage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imageDetail?.image = tempImage
        statusCurrentImage.text = textStatus
    }

   

    @IBAction func btnActionDismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }


}
