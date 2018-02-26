//
//  PresentAnimator.swift
//  FlickrDemo
//
//  Created by Scott Carter on 2/26/18.
//  Copyright © 2017 Scott Carter. All rights reserved.
//

import UIKit

import AppDeveloperKit



// ==========================================================================
// Protocols
// ==========================================================================
//

// MARK: - Protocols
//

protocol PresentAnimatorDelegate: class {
    
}


class PresentAnimator: NSObject  {
    
    
    // ==========================================================================
    // Properties
    // ==========================================================================
    //
    
    
    // MARK: - Instance Properties - Stored
    //
    
    let animationDelay: TimeInterval = 0.01
    
    var totalDuration: TimeInterval!
    
    var originFrame = CGRect.zero
    
    
    var _flipAnimation: Bool = true
    
    var _animationDuration: Double = 2.0
    
    
    // MARK: - Instance Properties - Computed
    //
    
    var flipAnimation: Bool {
        get {
            return _flipAnimation
        }
        
        set {
            _flipAnimation = newValue
        }
    }
    
    var animationDuration: Double {
        get {
            return _animationDuration
        }
        
        set {
            _animationDuration = newValue
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
        adk_deinitPresentAnimator()
    }
    
    override init() {
        
        super.init()
        
        adk_initPresentAnimator()
        
        totalDuration = animationDelay + animationDuration
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

extension PresentAnimator: UIViewControllerAnimatedTransitioning {
    
    // ==========================================================================
    // Protocol methods
    // ==========================================================================
    //
    // MARK: Protocol methods
    //
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return totalDuration
    }
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if flipAnimation {
            animateTransitionFlip(using: transitionContext);
        }
        else {
            animateTransitionScale(using: transitionContext);
        }
    }
    
    // ==========================================================================
    // Public Instance methods
    // ==========================================================================
    //
    // MARK: Public Instance methods
    
    // None
    
    
}


// MARK: -

private extension PresentAnimator {
    
    
    // ==========================================================================
    // Private Instance methods
    // ==========================================================================
    //
    // MARK: Private Instance methods
    
    

    
    // Animate by scaling up to final frame.
    //
    func animateTransitionScale(using transitionContext: UIViewControllerContextTransitioning) {
        
        //1) setup the transition
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        //2) create animation
        
        // Will will cause toView to start with size of originFrame and scale up to final frame.
        
        
        let finalFrame = toView.frame
        
        let xScaleFactor = originFrame.width / finalFrame.width
        let yScaleFactor = originFrame.height / finalFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        toView.transform = scaleTransform
        toView.center = CGPoint(
            x: originFrame.midX,
            y: originFrame.midY
        )
        toView.clipsToBounds = true
        
        containerView.addSubview(toView)
        
        
        // Let's fade in the "to" view.
        toView.alpha = 0
        
        
        UIView.animate(withDuration: totalDuration, delay: 0.0,
                       usingSpringWithDamping: 0.8, initialSpringVelocity: 5.0,
                       options: [], animations: {
                        
                        toView.alpha = 1.0
                        
                        toView.transform = CGAffineTransform.identity
                        toView.center = CGPoint(
                            x: finalFrame.midX,
                            y: finalFrame.midY
                        )
                        
        }, completion: {_ in
            
            //3 complete the transition
            transitionContext.completeTransition(
                !transitionContext.transitionWasCancelled
            )
        })
        
        
    }
    
    

    // Animate by flipping to final frame.
    //
    func animateTransitionFlip(using transitionContext: UIViewControllerContextTransitioning) {
        
        //1) setup the transition
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        

        //2) create animation

        // Start with toView hidden.  
        //
        toView.isHidden = true
        
        
        containerView.addSubview(toView)

        //print("Start animation")
        
        
        // For the flip animation (unlike animating transform and center properties in
        // animateTransitionScale method) we need to delay until next run loop before beginning
        // animation.
        //
        delay(seconds: animationDelay) {
            UIView.transition(from: fromView, to: toView, duration: self.animationDuration, options: [.transitionFlipFromLeft]) { (animationComplete) in
                
                //print("Animation complete")
                
                // 3 complete the transition
                
                let transitionComplete = animationComplete && !transitionContext.transitionWasCancelled
                
                // Return true if the transition to the presented view controller completed
                // successfully or false if the original view controller is still being displayed.
                transitionContext.completeTransition(transitionComplete)
            }
        }
        

        // Half way into duration (both views on edge) we show toView.
        //
        delay(seconds: totalDuration/2) {
            //print("Show toView")
            toView.isHidden = false
        }


        
    }
    
    
    func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }

    
}








