//
//  DetailView.swift
//  Sliding Panels
//
//  Created by qiuhong on 02/12/2016.
//  Copyright © 2016 CETCME. All rights reserved.
//

import UIKit

@IBDesignable
class DetailView: UIView {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0.655, green: 0.737, blue: 0.835, alpha: 0.8)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    var transitionProgress: CGFloat = 0 {
        didSet {
            updateViews()
        }
    }
    
    var room: Room? {
        didSet {
            if let room = room {
                titleLabel.text = room.title
                subtitleLabel.text = room.subtitle
                imageView.image = room.image
                overlayView.backgroundColor = room.color
            }
        }
    }
    
    func updateViews() {
        let progress = min(max(transitionProgress, 0), 1)
        let antiProgress = 1.0 - progress
        
        let titleLabelOffsetTop: CGFloat = 20.0
        let titleLabelOffsetMiddle: CGFloat = bounds.height / 2 - 44
        let titleLabelOffset = transitionProgress * titleLabelOffsetMiddle + antiProgress * titleLabelOffsetTop
        
        let subtitleLabelOffsetTop: CGFloat = 64
        let subtitleLabelOffsetMiddle: CGFloat = bounds.height / 2
        let subtitleLabelOffset = transitionProgress * subtitleLabelOffsetMiddle + antiProgress * subtitleLabelOffsetTop
        
        titleLabel.frame = CGRect(x: 0, y: titleLabelOffset, width: bounds.width, height: 44)
        subtitleLabel.preferredMaxLayoutWidth = bounds.width
        subtitleLabel.frame = CGRect(x: 0, y: subtitleLabelOffset, width: bounds.width, height: subtitleLabel.font.lineHeight)
        imageView.alpha = progress
    }
    
    func setup() {
        addSubview(imageView)
        addSubview(overlayView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        clipsToBounds = true
        
        titleLabel.text = "Title of Room"
        subtitleLabel.text = "Description of Room"
        imageView.image = UIImage(named: "bicycle-garage-gray")
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        overlayView.frame = bounds
        updateViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
