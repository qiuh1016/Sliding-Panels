//
//  PanelTransition.swift
//  Sliding Panels
//
//  Created by qiuhong on 02/12/2016.
//  Copyright © 2016 CETCME. All rights reserved.
//

import UIKit

@objc
protocol PanelTransitionViewController {
    func panelTransitionDetailViewForTransition(transition: PanelTransition) -> DetailView!
    @objc optional func panelTransitionWillAnimateTransition(transition: PanelTransition, presenting: Bool, isForeground: Bool)
}

class PanelTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    enum State {
        case none
        case presenting
        case dismissing
    }
    
    var state = State.none
    
    var presentingController: UIViewController!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        var backgroundViewController = fromViewController
        var forgroundViewController = toViewController
        
        if state == .dismissing {
            backgroundViewController = toViewController
            forgroundViewController = fromViewController
        }
        // get detail view from view controllers
        let backgroundDetailViewMaybe = (backgroundViewController as? PanelTransitionViewController)?.panelTransitionDetailViewForTransition(transition: self)
        let foregroundDetailViewMaybe = (forgroundViewController as? PanelTransitionViewController)?.panelTransitionDetailViewForTransition(transition: self)
        
        assert(backgroundDetailViewMaybe != nil, "Cannot find detail view in background view controller")
        assert(foregroundDetailViewMaybe != nil, "Cannot find detail view in foreground view controller")
        
        let backgroundDetailView = backgroundDetailViewMaybe!
        let foregroundDetailView = foregroundDetailViewMaybe!
        
        // add views to container
        containerView.addSubview(backgroundViewController.view)
        
        let wrapperView = UIView(frame: forgroundViewController.view.frame)
        wrapperView.layer.shadowRadius = 5
        wrapperView.layer.shadowOpacity = 0.3
        wrapperView.layer.shadowOffset = CGSize.zero
        wrapperView.addSubview(forgroundViewController.view)
        forgroundViewController.view.clipsToBounds = true
        
        containerView.addSubview(wrapperView)
        
        // perform animation
        (forgroundViewController as? PanelTransitionViewController)?.panelTransitionWillAnimateTransition?(transition: self, presenting: state == .presenting, isForeground: true)
        
        backgroundDetailView.isHidden = true
        
        let backgroundFrame = containerView.convert(backgroundDetailView.frame, from: backgroundDetailView.superview)
        let screenBounds = UIScreen.main.bounds
        let scale = backgroundFrame.width / screenBounds.width
    
        
        if state == .presenting {
            wrapperView.transform = CGAffineTransform(scaleX: scale, y: scale)
            foregroundDetailView.transitionProgress = 1
        } else {
            wrapperView.transform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            if self.state == .presenting {
                wrapperView.transform = CGAffineTransform.identity
                foregroundDetailView.transitionProgress = 0
            } else {
                wrapperView.transform = CGAffineTransform(scaleX: scale, y: scale)
                foregroundDetailView.transitionProgress = 1
            }
            }, completion: { _ in
                backgroundDetailView.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
        

    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentingController = presenting
        if presented is PanelTransitionViewController && presenting is PanelTransitionViewController {
            state = .presenting
            return self
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is PanelTransitionViewController && presentingController is PanelTransitionViewController {
            state = .dismissing
            return self
        }
        return nil
    }
    

    
}
