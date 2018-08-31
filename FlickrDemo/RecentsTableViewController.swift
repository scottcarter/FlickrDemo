//
//  RecentsTableViewController.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import UIKit

import AlamofireImage

import AppDeveloperKit



// ==========================================================================
// Protocols
// ==========================================================================
//

// MARK: - Protocols
//

protocol RecentsTableViewControllerDelegate: class {
    
}



class RecentsTableViewController: UITableViewController {
    
    
    // ==========================================================================
    // Properties
    // ==========================================================================
    //
    // MARK: - Properties - Outlets
    //
    
    
    
    // MARK: - Instance Properties - Stored
    //
    
    // Our cached copy of Result array
    var resultArr : [RecentPhotos.FlickrResult] = []
    
    
    // Flag to prevent multiple fetches to be outstanding.
    var fetchInProgress = false
    


    // How many photos to fetch at a time.  This can be up to 500.
    // https://www.flickr.com/services/api/flickr.photos.getRecent.html
    let PhotosPerFetch = 40
    
    let ThumbnailSize = RecentPhotos.PhotoSize.Large

    
    
    var _rowHeight: Double = 40.0

    
    // MARK: - Instance Properties - Computed
    //
    
    var rowHeight: Double {
        get {
            return _rowHeight
        }
        
        set {
            
            // Need to put some reasonable restrictions in place
            guard (newValue >= 40.0) && (newValue <= 200.0) else {
                return
            }
            

            _rowHeight = newValue
        
            tableView.rowHeight = CGFloat(rowHeight)
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Type Properties - Stored
    //
    // Use "static" or "class" prefix
    //
    
    
    
    // MARK: - Type Properties - Computed
    //
    // Use "static" or "class" prefix
    
    
    
    
    
    
    // ==========================================================================
    // Enumerationss
    // ==========================================================================
    //
    // MARK: - Enumerations
    
    // None
    
    
    
    
    // ==========================================================================
    // Actions
    // ==========================================================================
    //
    // MARK: - Actions
    
    
    // None
    
    
    
    // ==========================================================================
    // Initializations
    // ==========================================================================
    //
    // MARK: - Initializations
    
    deinit {
        adk_deinitRecentsTableViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        adk_initRecentsTableViewController()
        tableView.rowHeight = CGFloat(rowHeight)
        

        // Don't set title, as this will set both the navigation bar title and override
        // what was set for Tab Bar Controller item title.
        //title = "Recent Photos"
        navigationItem.title = "Recent Photos"
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull to refresh")
        self.refreshControl?.attributedTitle = NSAttributedString(string: title)
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
    
        
        // Initial load of photos
        initialPhotoLoad() {}
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination .isKind(of: PhotoViewController.self) {
            
            if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
                
                let photoViewController = segue.destination as! PhotoViewController
                
                photoViewController.photoTitle = resultArr[selectedRow].title
                photoViewController.photoDescription = resultArr[selectedRow].description
                photoViewController.photoImageUrl = resultArr[selectedRow].url
            }
            
        }
        
     }
    
    
    
    
    // ==========================================================================
    // Type methods
    // ==========================================================================
    //
    // Use static or class prefix
    //
    // Note: We include Type methods in main class, since class methods in extensions cannot be overriden currently.
    //
    // MARK: - Type methods
    
    
    // None
    
    
}


// MARK: -

extension RecentsTableViewController {
    
    // ==========================================================================
    // Protocol methods
    // ==========================================================================
    //
    // MARK: Protocol methods
    //
    
    
    // MARK: - UITableViewDelegate
    
    // https://michiganlabs.com/ios/development/2016/11/10/ios-infinite-scrolling/
    //
    // Another option for infinite scrolling: https://stackoverflow.com/a/10404477/1949877
    //
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // The index which will trigger a new fetch.
        let triggerIndex = Int(Double(self.resultArr.count) * 0.9)
        
        
        if (indexPath.row > triggerIndex)  && !fetchInProgress {
            
            //print("Fetch new photos. indexPath.row \(indexPath.row) > triggerIndex \(triggerIndex)")
            
            fetchInProgress = true
            
            // Figure out which page to fetch
            let pageToFetch = self.resultArr.count/PhotosPerFetch + 1
            
            RecentPhotos.shared().photos(perPage: PhotosPerFetch, page: pageToFetch, size: ThumbnailSize) { (success, resultArr, error) in
                
                if !success {
                    print("Got error = \(String(describing: error))")
                    self.fetchInProgress = false
                    return
                }
                
                self.resultArr.append(contentsOf: resultArr)
                
                
                tableView.reloadData()

                self.fetchInProgress = false
                
                
            }
        }
    }

    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArr.count
    }

    
    fileprivate struct CellIdentifiers {
        static let PhotoCell = "PhotoCellID"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RecentsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PhotoCell, for: indexPath) as! RecentsTableViewCell
        
        // Configure the cell
        let result = resultArr[indexPath.row]
        
        cell.title?.text = result.title
        
        if let url = URL(string: result.url) {
            cell.photo?.af_setImage(withURL: url)
        }
        
        //print("row=\(indexPath.row) title=\(result.title)  description=\(result.description)")
        
        return cell
    }
    
    
    
    

    
    
    
    // ==========================================================================
    // Public Instance methods
    // ==========================================================================
    //
    // MARK: Public Instance methods
    
    // None
    
}


// MARK: -

private extension RecentsTableViewController {
    
    
    // ==========================================================================
    // Private Instance methods
    // ==========================================================================
    //
    // MARK: Private Instance methods
    
    // Reference:
    // https://www.andrewcbancroft.com/2015/03/17/basics-of-pull-to-refresh-for-swift-developers/
    @objc func handleRefresh(refreshControl: UIRefreshControl) {

        initialPhotoLoad(){
            refreshControl.endRefreshing()
        }
    }
    
    
    func initialPhotoLoad(completion:@escaping ()->(Void)) {
        
        fetchInProgress = true
        RecentPhotos.shared().photos(perPage: PhotosPerFetch, page: 1, size: ThumbnailSize) { (success, resultArr, error) in
            
            if !success {
                print("Got error = \(String(describing: error))")
                self.fetchInProgress = false
                return
            }
            
            self.resultArr = resultArr
            
            self.tableView.reloadData()
            
            self.fetchInProgress = false
            
            completion()
        }
    }
    
}












