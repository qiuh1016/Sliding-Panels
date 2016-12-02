//
//  ViewController.swift
//  Sliding Panels
//
//  Created by qiuhong on 02/12/2016.
//  Copyright © 2016 CETCME. All rights reserved.
//

import UIKit

private let kContentViewTopOffset: CGFloat = 64
private let kContentViewBottomOffset: CGFloat = 64
private let kContentViewAnimationDuration: TimeInterval = 1.4

class DetailViewController: UIViewController, PanelTransitionViewController {
    @IBOutlet weak var detailView: DetailView!
    @IBOutlet weak var closeButton: UIButton!
    
    let contentView = UIView()
    let panelTransition = PanelTransition()
    
    var room: Room?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backgroundColor = UIColor.white
        contentView.frame = CGRect(x: 0, y: kContentViewTopOffset, width: view.bounds.width, height: view.bounds.height - kContentViewTopOffset)
        
        let imageView = UIImageView(image: UIImage(named: "IMG_0061"))
        contentView.addSubview(imageView)
        
        view.addSubview(contentView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(DetailViewController.handlePan(pan:)))
        view.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.handleTap(tap:)))
        detailView.addGestureRecognizer(tap)
        
        detailView.room = room
        transitioningDelegate = panelTransition
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent 
    }
    
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    func handlePan(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            fallthrough
        case .changed:
            contentView.frame.origin.y += pan.translation(in: view).y
            pan.setTranslation(CGPoint.zero, in: view)
            
            let progress = (contentView.frame.origin.y - kContentViewTopOffset) / (view.bounds.height - kContentViewTopOffset - kContentViewBottomOffset)
            detailView.transitionProgress = progress
            
        case .ended:
            fallthrough
        case .cancelled:
            let progress = (contentView.frame.origin.y - kContentViewTopOffset) / (view.bounds.height - kContentViewTopOffset - kContentViewBottomOffset)
            print(progress)
            if progress < 0.4 {
                
                let duration = TimeInterval(progress) * kContentViewAnimationDuration
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    self.detailView.transitionProgress = 0
                    self.contentView.frame.origin.y = kContentViewTopOffset
                    }, completion: nil)
                
            } else if progress > 0.8 {
                
                dismiss(animated: true, completion: nil)
               
            } else {
                
                let duration = TimeInterval(1-progress) * kContentViewAnimationDuration
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    self.detailView.transitionProgress = 1
                    self.contentView.frame.origin.y = self.view.bounds.height - kContentViewBottomOffset
                    }, completion: nil)
            }
            
        default:
            ()
        }
    }
    
    func handleTap(tap: UITapGestureRecognizer) {
        let expanded = detailView.transitionProgress == 0
        
        UIView.animate(withDuration: kContentViewAnimationDuration / 2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.detailView.transitionProgress = expanded ? 1 : 0
            self.contentView.frame.origin.y = expanded ? self.view.bounds.height - kContentViewBottomOffset : kContentViewTopOffset
            }, completion: nil)
    }

    //MARK: PanelTransitionViewController
    
    func panelTransitionDetailViewForTransition(transition: PanelTransition) -> DetailView! {
        return detailView
    }
    
    func panelTransitionWillAnimateTransition(transition: PanelTransition, presenting: Bool, isForeground: Bool) {
        if presenting {
            contentView.frame.origin.y = view.bounds.height
            closeButton.alpha = 0
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                self.contentView.frame.origin.y = kContentViewTopOffset
                self.closeButton.alpha = 1
                }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                self.contentView.frame.origin.y = self.view.bounds.height
                self.closeButton.alpha = 0
                }, completion: nil)
        }
    }


}

