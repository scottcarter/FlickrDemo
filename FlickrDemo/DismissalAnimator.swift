//
//  DismissalAnimator.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2017 Scott Carter. All rights reserved.
//

import UIKit


// ==========================================================================
// Protocols
// ==========================================================================
//

// MARK: - Protocols
//

protocol DismissalAnimatorDelegate: class {
    
}


class DismissalAnimator: NSObject  {
    
    
    // ==========================================================================
    // Properties
    // ==========================================================================
    //
    
    
    // MARK: - Instance Properties - Stored
    //
    
    
    let duration = 1.0
    
    
    
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
    // Enumerations
    // ==========================================================================
    //
    // MARK: - Enumerations
    
    // None
    
    
    
    
    
    
    // ==========================================================================
    // Initializations
    // ==========================================================================
    //
    // MARK: - Initializations
    
    deinit {
        
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

extension DismissalAnimator: UIViewControllerAnimatedTransitioning {
    
    // ==========================================================================
    // Protocol methods
    // ==========================================================================
    //
    // MARK: Protocol methods
    //
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    
  
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //1) setup the transition
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        //2) animations!
        UIView.animate(withDuration: duration/2, delay: 0.0,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 0,
                       options: [], animations: {
                        
                        fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                        
        }, completion: nil)
        
        UIView.animate(withDuration: duration/2, delay: duration/2, options: [], animations: {
            
            fromView.center.x += containerView.frame.size.width
            
        }, completion: {_ in
            
            //3) complete the transition
            transitionContext.completeTransition(
                !transitionContext.transitionWasCancelled
            )
        })
        
        
        // 4) Dim the background while the from view is dismissed.
        
        let background = UIView(frame: containerView.bounds)
        background.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
        containerView.insertSubview(background, belowSubview: fromView)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            background.alpha = 0 }, completion: {_ in
                background.removeFromSuperview()
        })
        
        
    } // func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    
    
    // ==========================================================================
    // Public Instance methods
    // ==========================================================================
    //
    // MARK: Public Instance methods
    
    // None
    
    
}


// MARK: -

private extension DismissalAnimator {
    
    
    // ==========================================================================
    // Private Instance methods
    // ==========================================================================
    //
    // MARK: Private Instance methods
    
    // None
    
}








