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

    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var btnReset: UIBarButtonItem!
    @IBOutlet weak var btnPause: UIBarButtonItem!
    
    @IBOutlet weak var tableFile: UITableView!
    @IBOutlet weak var sliderDownload: UISlider!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnReset.isEnabled = false
        btnAdd.isEnabled = !btnReset.isEnabled
    }
    
    

    
    @IBAction func btnActionReset(_ sender: UIBarButtonItem) {
        print("Reset button click")
        btnReset.isEnabled = false
        btnAdd.isEnabled = !btnReset.isEnabled
        
        Common.ListFileDownload = [FileDownload]()
        reloadDataTableFile()
        
        deleteFile()
    }
   
    @IBAction func btnActionAdd(_ sender: UIBarButtonItem) {
        print("Add button click")
        btnReset.isEnabled = true
        btnAdd.isEnabled = !btnReset.isEnabled
        
        //Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataTableFile), name: Const.notificationDownloadedZip, object: nil)
        Downloader.downloadFileZip()
        
    }
    
    @IBAction func btnActionPause(_ sender: UIBarButtonItem) {
        print("Pause button click")
    }
    
    func deleteFile() {
       
        
        //Create a FileManager instance
        let fileManager = FileManager.default
        //Delete file
        do {
            try fileManager.removeItem(atPath: Const.pathFolderName.path)
            try fileManager.removeItem(atPath: Const.pathZipFile.path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func reloadDataTableFile()  {
        DispatchQueue.main.async(execute: {
            self.tableFile.reloadData()
        });
        
        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: Const.notificationDownloadedZip, object: nil);
    }
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        //Restrict slider to a fixed value
        let fixed = roundf(sender.value / 1.0) * 1.0;
        sender.setValue(fixed, animated: true)
        
        handleDownload()
    }
    
    func handleDownload()  {
        print("handle Download")
    }
   
    

}


extension FilesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Common.ListFileDownload.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let itemFile:FileDownload = Common.ListFileDownload[indexPath.row] as FileDownload
        
        let cell: FilesViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! FilesViewCell
        cell.titleFile.text = itemFile._nameFile
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
        listViewController.indexList = indexPath.row
        
        self.navigationController?.pushViewController(listViewController, animated: true)
        
    }
}
