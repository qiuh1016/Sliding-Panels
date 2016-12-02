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
    var tableView: UITableView!
    let panelTransition = PanelTransition()
    
    var room: Room?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        contentView.backgroundColor = UIColor.white
        contentView.frame = CGRect(x: 0, y: kContentViewTopOffset, width: view.bounds.width, height: view.bounds.height - kContentViewTopOffset)
        view.addSubview(contentView)
        
        //table view
        tableView = UITableView(frame: CGRect(x: 0, y: 0 , width: view.bounds.width, height: view.bounds.height - kContentViewTopOffset), style: .plain)
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        
        //button view
        let buttonSize: CGFloat = 52
        let buttonSpace: CGFloat = 10
        let buttonView = UIView(frame: CGRect(x: view.bounds.width - buttonSize - buttonSpace, y: contentView.bounds.height - buttonSpace - buttonSize, width: buttonSize, height: buttonSize))
        buttonView.backgroundColor = UIColor.colorFromRGB(rgbValue: 0xC4752B, alpha: 1)
        buttonView.layer.cornerRadius = buttonSize / 2
        buttonView.layer.shadowRadius = 1
        buttonView.layer.shadowColor = UIColor.black.cgColor
        buttonView.layer.shadowOpacity = 0.7
        buttonView.layer.shadowOffset = CGSize.zero
        contentView.addSubview(buttonView)
        
        let addImageView = UIImageView(frame: CGRect(x: buttonSize / 4, y: buttonSize / 4, width: buttonSize / 2, height: buttonSize / 2))
        addImageView.image = #imageLiteral(resourceName: "close-button")
        addImageView.transform = buttonView.transform.rotated(by: CGFloat(PI / 4))
        buttonView.addSubview(addImageView)
        
        
        
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

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
    }

}

