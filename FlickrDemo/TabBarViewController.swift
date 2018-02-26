//
//  TabBarViewController.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    // MARK: - Properties - View controller config
    //
    
    override var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    
    // We can lock to Portrait by returning .portrait
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            //return .portrait
            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue | UIInterfaceOrientationMask.landscape.rawValue)
        }
    }
    
    

   

}
