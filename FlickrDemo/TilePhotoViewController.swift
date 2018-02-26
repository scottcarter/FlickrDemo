//
//  TilePhotoViewController.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import UIKit

import RealmSwift



// ==========================================================================
// Protocols
// ==========================================================================
//

// MARK: - Protocols
//


protocol TilePhotoViewControllerDelegate: class {
    
}



class TilePhotoViewController: UIViewController {
    
    
    // ==========================================================================
    // Properties
    // ==========================================================================
    //
    // MARK: - Properties - Outlets
    //
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    

    
    // MARK: - Instance Properties - Stored
    //
    
    var photoTitle: String = ""
    var photoDescription: String = ""
    var photoImageUrl: String = ""
    
    
    
    // MARK: - Instance Properties - Computed
    //
    
    
    
    
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
    
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addBookmarkAction(_ sender: UIBarButtonItem) {
        
        var realm: Realm
        do {
            realm = try Realm()
        }
        catch {
            return
        }
        
        
        // Has bookmark already been added?
        let filter = "photoUrl == \"\(photoImageUrl)\""
        
        let bookmarks: Results<PhotoBookmark> = realm.objects(PhotoBookmark.self).filter(filter)
        
        if bookmarks.count != 0 {
            let alertController = UIAlertController(title: "Already added bookmark", message: "Success!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true) {() -> Void in }
            return
        }
        
        
        let bookmark = PhotoBookmark(photoUrl: photoImageUrl, photoTitle: photoTitle, photoDescription: photoDescription)
        
        do {
            try realm.write {
                realm.add(bookmark)
            }
        }
        catch {
            return
        }
        
        let alertController = UIAlertController(title: "Added bookmark", message: "Success!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true) {() -> Void in }
        
    }
    
    // None
    
    
    
    // ==========================================================================
    // Initializations
    // ==========================================================================
    //
    // MARK: - Initializations
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        
        titleLabel.text = photoTitle
        descriptionLabel.text = photoDescription
        
        if let url = URL(string: photoImageUrl) {
            photoImageView.af_setImage(withURL:  url)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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

extension TilePhotoViewController {
    
    // ==========================================================================
    // Protocol methods
    // ==========================================================================
    //
    // MARK: Protocol methods
    //
    
    // None
    
    
    
    // ==========================================================================
    // Public Instance methods
    // ==========================================================================
    //
    // MARK: Public Instance methods
    
    // None
    
}


// MARK: -

private extension TilePhotoViewController {
    
    
    // ==========================================================================
    // Private Instance methods
    // ==========================================================================
    //
    // MARK: Private Instance methods
    
    // None
    
}









