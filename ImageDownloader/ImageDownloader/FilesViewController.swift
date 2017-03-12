//
//  ViewController.swift
//  ImageDownloader
//
//  Created by ninjaKID on 2/27/17.
//  Copyright © 2017 ninjaKID. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

/**
 The KVO context used for all `PhotosViewController` instances. This provides a stable
 address to use as the context parameter for the KVO observation methods.
 */
private var photosViewControllerObservationContext = 0

class FilesViewController: UIViewController {
    
    /// The album that the app is importing
    fileprivate var album: Album?
    
    /// Keys that we observe on `overallProgress`.
    fileprivate let overalProgressObservedKeys = [
        "fractionCompleted",
        "completedUnitCount",
        "totalUnitCount",
        "cancelled",
        "paused"
    ]
    
    /// The overall progress for the import that is shown to the user
    fileprivate var overallProgress: Progress? {
        willSet {
            guard let formerProgress = overallProgress else { return }
            
            for overalProgressObservedKey in overalProgressObservedKeys {
                formerProgress.removeObserver(self, forKeyPath: overalProgressObservedKey, context: &photosViewControllerObservationContext)
            }
        }
        
        didSet {
            if let newProgress = overallProgress {
                for overalProgressObservedKey in overalProgressObservedKeys {
                    newProgress.addObserver(self, forKeyPath: overalProgressObservedKey, options: [], context: &photosViewControllerObservationContext)
                }
            }
            
            updateProgressView()
            updateToolbar()
        }
    }
    
    // MARK: Key-Value Observing
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &photosViewControllerObservationContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        OperationQueue.main.addOperation {
            self.updateProgressView()
            self.updateToolbar()
        }
    }
    
    // MARK: Update UI
    
    fileprivate func updateProgressView() {
        let shouldHide: Bool
        
        if let overallProgress = self.overallProgress {
            shouldHide = overallProgressIsFinished || overallProgress.isCancelled
            
            //progressView.progress = Float(overallProgress.fractionCompleted)
        }
        else {
            shouldHide = true
        }
        
        if progressViewIsHidden != shouldHide {
            UIView.animate(withDuration: 0.2, animations: {
                //self.progressContainerView.alpha = shouldHide ? 0.0 : 1.0
            })
            
            progressViewIsHidden = shouldHide
        }
    }
    
    fileprivate func updateToolbar() {
        let items = [UIBarButtonItem]()
        
        if let overallProgress = overallProgress {
            if overallProgressIsFinished || overallProgress.isCancelled {
                //items.append(resetToolbarItem)
            }
            else {
                // The import is running.
               // items.append(cancelToolbarItem)
                
                if overallProgress.isPaused {
                   //items.append(resumeToolbarItem)
                }
                else {
                   // items.append(pauseToolbarItem)
                }
            }
        }
        else {
           // items.append(startToolbarItem)
        }
        
        navigationController?.toolbar?.setItems(items, animated: true)
    }
    
    // MARK: Nib Loading
    
    override func awakeFromNib() {
        album = Album()
    }
    
    
    
    fileprivate var progressViewIsHidden = true
    
    fileprivate var overallProgressIsFinished: Bool {
        let completed = overallProgress!.completedUnitCount
        let total = overallProgress!.totalUnitCount
        
        // An NSProgress is finished if it's not indeterminate, and the completedUnitCount > totalUnitCount.
        return (completed >= total && total > 0 && completed > 0) || (completed > 0 && total == 0)
    }

    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var btnReset: UIBarButtonItem!
    @IBOutlet weak var btnPause: UIBarButtonItem!
    
    @IBOutlet weak var tableFile: UITableView!
    @IBOutlet weak var sliderDownload: UISlider!
    
    var queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnReset.isEnabled = false
        btnPause.isEnabled = btnReset.isEnabled
        btnAdd.isEnabled = !btnReset.isEnabled
    }
    
    

    
    @IBAction func btnActionReset(_ sender: UIBarButtonItem) {
        print("Reset button click")
        btnReset.isEnabled = false
        btnPause.isEnabled = btnReset.isEnabled
        btnAdd.isEnabled = !btnReset.isEnabled
        
        Common.ListFileDownload = [FileDownload]()
        reloadDataTableFile()
        
        deleteFile()
        
        URLCache.shared.removeAllCachedResponses()
    }
   
    @IBAction func btnActionAdd(_ sender: UIBarButtonItem) {
        print("Add button click")
        btnReset.isEnabled = true
        btnPause.isEnabled = btnReset.isEnabled
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
        
        beginDownloadData()
        
        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: Const.notificationDownloadedZip, object: nil);
    }
    
    func  beginDownloadData()  {
        overallProgress = album?.importPhotos()
        
        
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
        listViewController.album = album
        
        self.navigationController?.pushViewController(listViewController, animated: true)
        
    }
}
