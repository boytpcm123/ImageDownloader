//
//  ViewController.swift
//  ImageDownloader
//
//  Created by ninjaKID on 2/27/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FilesViewController: UIViewController {

    
    @IBOutlet weak var sliderDownload: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func btnActionReset(_ sender: UIBarButtonItem) {
        print("Reset button click")
    }
   
    @IBAction func btnActionAdd(_ sender: UIBarButtonItem) {
        print("Add button click")
    }
    
    @IBAction func btnActionPause(_ sender: UIBarButtonItem) {
        print("Pause button click")
    }

}


extension FilesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: FilesViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! FilesViewCell
        cell.titleFile.text = "images"+String(indexPath.row)
        cell.statusFile.text = "Downloading..."
        cell.progressFile.progress = 0.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: FilesViewCell = tableView.cellForRow(at: indexPath) as! FilesViewCell
        
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let listViewController = storyBoard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        listViewController.title = cell.titleFile.text
        
        self.navigationController?.pushViewController(listViewController, animated: true)
        
    }
}
