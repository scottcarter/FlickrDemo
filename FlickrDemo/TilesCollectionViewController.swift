//
//  TilesCollectionViewController.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2018 Scott Carter. All rights reserved.
//

import UIKit

import AlamofireImage

import AppDeveloperKit



private let reuseIdentifier = "Cell"


// ==========================================================================
// Protocols
// ==========================================================================
//

// MARK: - Protocols
//


protocol TilesCollectionViewControllerDelegate: class {
    
}


class TilesCollectionViewController: UICollectionViewController {
    
    
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
    
    
    
    var _minimumInteritemSpacing: Double = 2.0 // Spacing between columns for vertical scrolling (rows for horizontal scrolling).
    
    var _minimumLineSpacing: Double = 1.0      // Spacing between rows for vertical scrolling (columns for horizontal scrolling).
    
    var _scrollDirectionVertical: Bool = true
    
    var _numTileElements: Int = 5 // Number of tiles in non-scrolling direction
    
    var _viewBackgroundColor: UIColor = .white

    var _tileBackgroundColor: UIColor = .white
    var _tileCornerRadiusWidthPercentage: Double = 0.0
    var _tileBorderColor: UIColor = .white
    var _tileBorderWidth: Double = 0.0
    
    var _tileImageCornerRadiusWidthPercentage: Double = 0.0
    var _tileImageTopConstraint: Double = 0.0
    var _tileImageBottomConstraint: Double = 0.0
    var _tileImageLeftConstraint: Double = 0.0
    var _tileImageRightConstraint: Double = 0.0

    
    
    // MARK: - Instance Properties - Computed
    //
    
    
    // Spacing between columns for vertical scrolling (rows for horizontal scrolling).
    var minimumInteritemSpacing: Double {
        get {
            return _minimumInteritemSpacing
        }
        
        set {
            _minimumInteritemSpacing = newValue
            
            let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.minimumInteritemSpacing = CGFloat(_minimumInteritemSpacing)
            
            self.collectionView?.reloadData()
        }
    }

    
    // Spacing between rows for vertical scrolling (columns for horizontal scrolling).
    var minimumLineSpacing: Double {
        get {
            return _minimumLineSpacing
        }
        
        set {
            _minimumLineSpacing = newValue
            
            let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.minimumLineSpacing = CGFloat(_minimumLineSpacing)
            
            self.collectionView?.reloadData()
        }
    }


    var scrollDirectionVertical: Bool {
        get {
            return _scrollDirectionVertical
        }
        
        set {
            _scrollDirectionVertical = newValue
            
            let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.scrollDirection = _scrollDirectionVertical ? .vertical : .horizontal
            
            self.collectionView?.reloadData()
        }
    }

    
    // Number of tiles in non-scrolling direction
    var numTileElements: Int {
        get {
            return _numTileElements
        }
        
        set {
            // Put some restrictions in place
            guard newValue > 0 else {
                return
            }
            
            _numTileElements = newValue
            
            self.collectionView?.reloadData()
        }
    }
    
    
    var viewBackgroundColor: UIColor {
        get {
            return _viewBackgroundColor
        }
        
        set {
            
            _viewBackgroundColor = newValue
            
            collectionView?.backgroundColor = _viewBackgroundColor
        }
    }
    
    
    
    var tileBackgroundColor: UIColor {
        get {
            return _tileBackgroundColor
        }
        
        set {
            
            _tileBackgroundColor = newValue
            
            self.collectionView?.reloadData()
        }
    }

    
    var tileCornerRadiusWidthPercentage: Double {
        get {
            return _tileCornerRadiusWidthPercentage
        }
        
        set {
            
            _tileCornerRadiusWidthPercentage = newValue
            
            self.collectionView?.reloadData()
        }
    }

    var tileBorderColor: UIColor {
        get {
            return _tileBorderColor
        }
        
        set {
            
            _tileBorderColor = newValue
            
            self.collectionView?.reloadData()
        }
    }

    
    var tileBorderWidth: Double {
        get {
            return _tileBorderWidth
        }
        
        set {
            
            _tileBorderWidth = newValue
            
            self.collectionView?.reloadData()
        }
    }
    
    
    var tileImageCornerRadiusWidthPercentage: Double {
        get {
            return _tileImageCornerRadiusWidthPercentage
        }
        
        set {
            
            _tileImageCornerRadiusWidthPercentage = newValue
            
            self.collectionView?.reloadData()
        }
    }
    
    var tileImageTopConstraint: Double {
        get {
            return _tileImageTopConstraint
        }
        
        set {
            
            _tileImageTopConstraint = newValue
            
            self.collectionView?.reloadData()
        }
    }

    var tileImageBottomConstraint: Double {
        get {
            return _tileImageBottomConstraint
        }
        
        set {
            
            _tileImageBottomConstraint = newValue
            
            self.collectionView?.reloadData()
        }
    }

    var tileImageLeftConstraint: Double {
        get {
            return _tileImageLeftConstraint
        }
        
        set {
            
            _tileImageLeftConstraint = newValue
            
            self.collectionView?.reloadData()
        }
    }
    
    var tileImageRightConstraint: Double {
        get {
            return _tileImageRightConstraint
        }
        
        set {
            
            _tileImageRightConstraint = newValue
            
            self.collectionView?.reloadData()
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
        adk_deinitTilesCollectionViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adk_initTilesCollectionViewController()
        
        
        collectionView?.backgroundColor = viewBackgroundColor
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        
        
        // We already have a layout, so no need to create one.
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout

        // Set a placeholder size.
        // We control the actual size in collectionView(_:layout:sizeForItemAt)
        let size = CGSize(width: 10.0, height: 10.0)
        
        layout?.itemSize = size
        layout?.minimumInteritemSpacing = CGFloat(minimumInteritemSpacing)
        layout?.minimumLineSpacing = CGFloat(minimumLineSpacing)
        
        layout?.scrollDirection = scrollDirectionVertical ? .vertical : .horizontal
        
        
        // Refresh control for UICollectionViewController not available via Interface Builder
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Pull To Refresh", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(refreshControl:)),
                                 for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        
        // Initial load of photos
        initialPhotoLoad() {}
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

extension TilesCollectionViewController: UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
    
    // ==========================================================================
    // Protocol methods
    // ==========================================================================
    //
    // MARK: Protocol methods
    //
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let viewBottomPosition: CGFloat = scrollView.contentOffset.y + view.frame.size.height
        let contentHeight: CGFloat = scrollView.contentSize.height
        
        if (viewBottomPosition >= contentHeight * 0.9) && !fetchInProgress {
            
            fetchInProgress = true
        
            RecentPhotos.shared().photos(perPage: PhotosPerFetch, page: 1, size: ThumbnailSize) { (success, resultArr, error) in
                
                if !success {
                    print("Got error = \(String(describing: error))")
                    self.fetchInProgress = false
                    return
                }
                
                self.resultArr.append(contentsOf: resultArr)
                
                self.collectionView?.reloadData()
                
                self.fetchInProgress = false
            }
            
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedItem = indexPath.row
        
        let bundle = Bundle(for: TilePhotoViewController.self)
        let photoViewController = TilePhotoViewController(nibName: "TilePhotoViewController", bundle: bundle)
        
        photoViewController.photoTitle = resultArr[selectedItem].title
        photoViewController.photoDescription = resultArr[selectedItem].description
        photoViewController.photoImageUrl = resultArr[selectedItem].url
        
        photoViewController.transitioningDelegate = self
        
        
        // Need to set the frame when loading from XIB.
        // Otherwise toView.frame in PresentAnimator.swift, animateTransition will
        // have the wrong frame size (will show as 600 x 600) since the XIB is using
        // Trait Variations.   See File Inspector, Interface Builder Document section.
        //
        photoViewController.view.frame = UIScreen.main.bounds
        
        
        
        present(photoViewController, animated: true, completion: nil)
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> TilesCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TilesCollectionViewCell
        
        // Configure the cell
        
        // The row is our item number - an index into our array of images.
        let result = resultArr[indexPath.row]
        
        if let url = URL(string: result.url) {
            cell.imageView?.af_setImage(withURL: url)
        }

        
        
        // Properties affecting image rendering
        //
        cell.imageView.layer.masksToBounds = true
        
        
        // Express the corner radius as a percentage of width.  50% of width will yield a circle,
        // assuming that image constraints on all 4 side are equal (we are dealing with square images).
        //
        let imageLeftConstraint = CGFloat(tileImageLeftConstraint)
        let imageRightConstraint = CGFloat(tileImageRightConstraint)
        let cellWidth = cell.frame.size.width
        let imageCornerRadiusWidthPercentage = CGFloat(tileImageCornerRadiusWidthPercentage)
        let imageWidth = cellWidth - imageLeftConstraint - imageRightConstraint
        
        cell.imageView.layer.cornerRadius = imageWidth * imageCornerRadiusWidthPercentage/100
        
        
        cell.imageViewTopConstraint.constant = CGFloat(tileImageTopConstraint)
        cell.imageViewBottomConstraint.constant = CGFloat(tileImageBottomConstraint)
        cell.imageViewLeftConstraint.constant = imageLeftConstraint
        cell.imageViewRightConstraint.constant = imageRightConstraint

        
        // Properties affecting tile rendering
        cell.tileView.backgroundColor = tileBackgroundColor
        cell.tileView.layer.cornerRadius = cellWidth * CGFloat(tileCornerRadiusWidthPercentage)/100
        
        cell.contentView.layer.cornerRadius = cellWidth * CGFloat(tileCornerRadiusWidthPercentage)/100
        cell.contentView.layer.borderColor =  tileBorderColor.cgColor
        cell.contentView.layer.borderWidth = CGFloat(tileBorderWidth)
        

        
        return cell
    }
    
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var scrollDirection: UICollectionViewScrollDirection = .vertical
        
        if scrollDirectionVertical == false {
            scrollDirection = .horizontal
        }
        
        let numElementsFloat = CGFloat(numTileElements)
        
        let positionInRow: Int = indexPath.item % numTileElements
        
        var elementWidth: CGFloat = 0.0
        var elementHeight: CGFloat = 0.0
        
        
        let totalSpacing = (numElementsFloat - 1.0) * CGFloat(minimumInteritemSpacing)
        
        if scrollDirection == .vertical {
            // What width are we working with?
            let viewWidth = view.bounds.size.width
            elementWidth = dimension(forPosition: positionInRow, numElements: numTileElements, dimensionTotal: (viewWidth - totalSpacing))
            
            // Assuming square images since we use RecentPhotos.PhotoSize.Large (150x150)
            // The width might vary by a point (to squeeze in all numTileElements), but the height must remain constant!
            // Use a height equal to the width of the first position.
            //
            elementHeight = dimension(forPosition: 0, numElements: numTileElements, dimensionTotal: (viewWidth - totalSpacing))
            
            //print("elementWidth=\(elementWidth)  elementHeight=\(elementHeight)")
            
        }
        else {
            // What height are we working with?
            let viewHeight = view.bounds.size.height
            elementHeight = dimension(forPosition: positionInRow, numElements: numTileElements, dimensionTotal: (viewHeight - totalSpacing))
            
            // Assuming square images since we use RecentPhotos.PhotoSize.Large (150x150)
            // The height might vary by a point (to squeeze in all numTileElements), but the width must remain constant!
            // Use a width equal to the height of the first position.
            //
            elementWidth = dimension(forPosition: 0, numElements: numTileElements, dimensionTotal: (viewHeight - totalSpacing))
        }
        
        let size = CGSize(width: CGFloat(elementWidth), height: CGFloat(elementHeight))
        
        return size
    }
    
    
    // MARK: UIViewControllerTransitioningDelegate
    
    
    /* Use this method to create and return an object that implements the methods of the UIViewControllerAnimatedTransitioning protocol. Your implementation of that protocol must animate the appearance of the presented view controller’s view onscreen. Use the presented, presenting, and source parameters to initialize your animator object or perform any tasks necessary to prepare the transition animations. You may return nil from this method if you do not want to implement a custom transition animation for the specified set of view controllers.
     */
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        // Get selected cell
        guard let indexPath = collectionView?.indexPathsForSelectedItems?.first,
            let cell = collectionView?.cellForItem(at: indexPath) else {
                return nil
        }
        
        
        let animator = PresentAnimator()
        
        // Get frame of seleted cell in window coordinates
        let cellFrame = cell.superview!.convert(cell.frame, to: nil)
        
        animator.originFrame = cellFrame
        
        return animator
    }
    
    
    
    /* Use this method to create and return an object that implements the methods of the UIViewControllerAnimatedTransitioning protocol. Your implementation of that protocol must animate the disappearance of the dismissed view controller’s view from the screen. Use the dismissed parameter to initialize your object or perform any tasks necessary to prepare the transition animations. You may return nil from this method if you do not want to implement a custom transition animation when dismissing view controllers. */
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return DismissalAnimator()
    }
    
    
    
    // ==========================================================================
    // Public Instance methods
    // ==========================================================================
    //
    // MARK: Public Instance methods
    
    // None
    
}


// MARK: -

private extension TilesCollectionViewController {
    
    
    // ==========================================================================
    // Private Instance methods
    // ==========================================================================
    //
    // MARK: Private Instance methods
    
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
            
            
            self.collectionView?.reloadData()
            
            self.fetchInProgress = false
            
            completion()
        }
    }
    
    
    // Calculate element width (vertical scroll) or height (horizontal scroll) so
    // that all dimensions are non-fractional.   Fractional dimensions can result
    // in a gap between elements.
    //
    // Example sequences using width=320 and either 3 or 6 elements in non-scrolling direction.
    //
    // 320/3 =  106.666   107, 107, 106
    // 320/6 =  53.333   53, 53, 54, 53, 54, 53
    //
    // dimensionTotal = view available - total spacing
    //
    func dimension(forPosition position: Int, numElements: Int, dimensionTotal: CGFloat) -> CGFloat {
        var dimensionUsed: CGFloat = 0.0
        var dimension: CGFloat = 0.0
        
        for i in 0..<numElements {
            let dimensionRemaining: CGFloat = dimensionTotal - dimensionUsed
            
            // Last elements?
            if i == (numElements - 1) {
                dimension = dimensionRemaining
                break
            }
            
            let elementsRemaining: Int = numElements - i
            
            // We round dimension to nearest integer.  Half-way rounds up.
            dimension = round(dimensionRemaining / CGFloat(elementsRemaining))
            
            if i == position {
                break
            }
            
            dimensionUsed += dimension
        }
        
        return dimension
    }
    
    
    
}






