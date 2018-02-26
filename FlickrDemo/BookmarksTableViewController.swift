//
//  BookmarksTableViewController.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//


import UIKit

import AlamofireImage

import AppDeveloperKit

import RealmSwift


// ==========================================================================
// Protocols
// ==========================================================================
//

// MARK: - Protocols
//

protocol BookmarksTableViewControllerDelegate: class {
    
}


class BookmarksTableViewController: UITableViewController {
    
    
    // ==========================================================================
    // Properties
    // ==========================================================================
    //
    // MARK: - Properties - Outlets
    //
    
    
    // MARK: - Instance Properties - Stored
    //
    
    // We use an optional (and not implicitly unwrapped) so that we can tell if
    // we were successfully able to get Results from Realm.  This variable might
    // remain nil if for example the Realm DB was migrated and we expected an older version.
    var bookmarks: Results<PhotoBookmark>?
    
    var subscription: NotificationToken?
    

    
    
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
        adk_deinitBookmarksTableViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        adk_initBookmarksTableViewController()
        tableView.rowHeight = CGFloat(rowHeight)
        
        // Don't set title, as this will set both the navigation bar title and override
        // what was set for Tab Bar Controller item title.
        //title = "Bookmarked Photos"
        navigationItem.title = "Bookmarked Photos"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        do {
            bookmarks = try getBookmarks(sortOrder: PhotoBookmark.BookmarkOrder.PhotoTitle.rawValue, sortAscending: true)
        }
        catch {
            bookmarks = nil
        }
        
        if let bookmarks = bookmarks {
            subscription = notificationSubscription(bookmarks: bookmarks)
        }
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination .isKind(of: PhotoViewController.self) {
            
            if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
                
                let photoViewController = segue.destination as! PhotoViewController
                
                
                guard let bookmarks = bookmarks else {
                    return
                }
                
                photoViewController.photoTitle = bookmarks[selectedRow].photoTitle
                photoViewController.photoDescription = bookmarks[selectedRow].photoDescription
                photoViewController.photoImageUrl = bookmarks[selectedRow].photoUrl
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

extension BookmarksTableViewController {
    
    // ==========================================================================
    // Protocol methods
    // ==========================================================================
    //
    // MARK: Protocol methods
    //
    
    
    // MARK: - UITableViewDelegate
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            guard let origBookmarks = bookmarks else {
                return
            }
            
            var realm: Realm
            do {
                realm = try Realm()
            }
            catch {
                return
            }
            
            let photoUrl = origBookmarks[indexPath.row].photoUrl
            
            // Try to fetch data record using URL
            guard let bookmark = realm.object(ofType: PhotoBookmark.self, forPrimaryKey: photoUrl as AnyObject) else {
                return
            }
            
            
            // Attempt to delete bookmark
            do {
                try realm.write {
                    realm.delete(bookmark)
                }
            }
            catch {
                return
            }
            
            // Deletion of bookmark will trigger notification and call updateUI() which calls
            // tableView.deleteRows()  so we don't need to do this here.
            //
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        }
    }
    

    
    
    // MARK: - UITableViewDataSource
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bookmarks = bookmarks {
            return bookmarks.count
        }
        else {
            return 0
        }

    }
    
    
    fileprivate enum CellIdentifiers {
        static let PhotoCell = "PhotoCellID"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RecentsTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PhotoCell, for: indexPath) as! RecentsTableViewCell

        guard let bookmarks = bookmarks else {
            return cell
        }

        
        // Configure the cell
        let bookmark = bookmarks[indexPath.row]
                
        cell.title?.text = bookmark.photoTitle
        
        if let url = URL(string: bookmark.photoUrl) {
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

private extension BookmarksTableViewController {
    
    
    // ==========================================================================
    // Private Instance methods
    // ==========================================================================
    //
    // MARK: Private Instance methods
    
    func getBookmarks(sortOrder: String, sortAscending: Bool) throws -> Results<PhotoBookmark> {
        
        var realm: Realm
        do {
            realm = try Realm()
        }
        catch {
            throw error
        }
        
        let objects = realm.objects(PhotoBookmark.self)
        
        //objects = objects.filter("???")
        
        
        // Note:  Because we return sorted objects, we get changes as insertions and deletions
        //        for modified objects.   See updateUI().
        //
        //        If we instead returned the unsorted objects, changes appear as
        //        modifications instead.
        //
        // Reference on notifications
        // https://realm.io/docs/swift/latest/#collection-notifications
        
        return objects.sorted(by: [
            SortDescriptor(keyPath: sortOrder, ascending: sortAscending)
            ])
    }
    
    
    func notificationSubscription(bookmarks: Results<PhotoBookmark>) -> NotificationToken {
        return bookmarks.observe {[weak self] (changes: RealmCollectionChange<Results<PhotoBookmark>>) in
            self?.updateUI(changes: changes)
        }
        
    }
    
    
    func updateUI(changes: RealmCollectionChange<Results<PhotoBookmark>>) {
        switch changes {
            
        case .initial(_):
            tableView.reloadData()
            
        case .update(_, let deletions, let insertions, let modifications):
            
            
            // deletions, insertions and modifications are arrays of Int.
            
            
            tableView.beginUpdates()
            
            
            // Modifications
            let modificationIndexPaths = modifications.map({ (row) -> IndexPath in
                IndexPath(row: row, section: 0)
            })
            tableView.reloadRows(at: modificationIndexPaths, with: .automatic)
            
            
            
            // Must handle deletions before insertions!
            //

            
            // Deletions
            let deletionIndexPaths = deletions.map({ (row) -> IndexPath in
                IndexPath(row: row, section: 0)
            })
            tableView.deleteRows(at: deletionIndexPaths, with: .automatic)
            
            
            // Insertions
            let insertionIndexPaths = insertions.map({ (row) -> IndexPath in
                IndexPath(row: row, section: 0)
            })
            tableView.insertRows(at: insertionIndexPaths, with: .automatic)
            
            
            tableView.endUpdates()
            
            

            // If we are inserting a new entry here we will make it visible.  Must do this
            // after we call tableView.endUpdates()
            //
            if insertions.count >= 1 {
                
                let indexPath = IndexPath(row: insertions.first!, section: 0)
                
                tableView.scrollToRow(at:indexPath, at: .middle, animated: true)
            }

            
            
            break
        case .error(let error):
            print(error)
        }
        
    }
    

        
    
    
}



