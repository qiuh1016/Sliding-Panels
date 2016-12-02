//
//  RoomCell.swift
//  Sliding Panels
//
//  Created by qiuhong on 02/12/2016.
//  Copyright © 2016 CETCME. All rights reserved.
//

import UIKit

class RoomCell: UICollectionViewCell {
    
    let detailView = DetailView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.clear
        contentView.addSubview(detailView)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let screenBounds = UIScreen.main.bounds
        let scale = bounds.width / screenBounds.width
        
        detailView.transitionProgress = 1
        detailView.frame = screenBounds
        detailView.transform = CGAffineTransform(scaleX: scale, y: scale)
        detailView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
}
