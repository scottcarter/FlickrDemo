//
//  TilesViewController.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//




import UIKit



// ==========================================================================
// Protocols
// ==========================================================================
//

// MARK: - Protocols
//


protocol TilesViewControllerDelegate: class {
    
}



class TilesViewController: UIViewController {
    
    
    // ==========================================================================
    // Properties
    // ==========================================================================
    //
    // MARK: - Properties - Outlets
    //
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var containerViewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerViewLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Instance Properties - Stored
    //
    
    var _wrapperBackgroundColor: UIColor = .white
    var _wrapperRightConstraint: Double = 0.0
    var _wrapperLeftConstraint: Double = 0.0
    var _wrapperTopConstraint: Double = 0.0
    var _wrapperBottomConstraint: Double = 0.0

    
    // MARK: - Instance Properties - Computed
    //
    
    var wrapperBackgroundColor: UIColor {
        get {
            return _wrapperBackgroundColor
        }
        
        set {
            _wrapperBackgroundColor = newValue
            
            wrapperView.backgroundColor = _wrapperBackgroundColor
        }
    }
    
    
    var wrapperRightConstraint: Double {
        get {
            return _wrapperRightConstraint
        }
        set {
            _wrapperRightConstraint = newValue
            
            containerViewRightConstraint.constant = CGFloat(_wrapperRightConstraint)
        }
    }

    
    var wrapperLeftConstraint: Double {
        get {
            return _wrapperLeftConstraint
        }
        set {
            _wrapperLeftConstraint = newValue
            
            containerViewLeftConstraint.constant = CGFloat(_wrapperLeftConstraint)
        }
    }

    
    var wrapperTopConstraint: Double {
        get {
            return _wrapperTopConstraint
        }
        set {
            _wrapperTopConstraint = newValue
            
            containerViewTopConstraint.constant = CGFloat(_wrapperTopConstraint)
        }
    }

    
    var wrapperBottomConstraint: Double {
        get {
            return _wrapperBottomConstraint
        }
        set {
            _wrapperBottomConstraint = newValue
            
            containerViewBottomConstraint.constant = CGFloat(_wrapperBottomConstraint)
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
        adk_deinitTilesViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Don't set title, as this will set both the navigation bar title and override
        // what was set for Tab Bar Controller item title.
        //title = "Collection Photos"
        navigationItem.title = "Collection Photos"
        
        
        adk_initTilesViewController()
        wrapperView.backgroundColor = wrapperBackgroundColor
        containerViewRightConstraint.constant = CGFloat(wrapperRightConstraint)
        containerViewLeftConstraint.constant = CGFloat(wrapperLeftConstraint)
        containerViewTopConstraint.constant = CGFloat(wrapperTopConstraint)
        containerViewBottomConstraint.constant = CGFloat(wrapperBottomConstraint)

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

extension TilesViewController {
    
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

private extension TilesViewController {
    
    
    // ==========================================================================
    // Private Instance methods
    // ==========================================================================
    //
    // MARK: Private Instance methods
    
    // None
    
}









