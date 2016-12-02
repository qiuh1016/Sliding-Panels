//
//  TableViewCell.swift
//  Sliding Panels
//
//  Created by qiuhong on 02/12/2016.
//  Copyright © 2016 CETCME. All rights reserved.
//

import UIKit

private let whoaColor = UIColor.colorFromRGB(rgbValue: 0xC4752B, alpha: 1)
private let commentColor = UIColor.colorFromRGB(rgbValue: 0xE5E5E5, alpha: 1)

class TableViewCell: UITableViewCell {

    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var whoaButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    let colors: [UInt] = [0x5599F5, 0xF5A623, 0xF8E71C, 0x7ED321, 0x9013FE, 0x50E3C2, 0xB8E986, 0x9B9B9B, 0x0093B6]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        whoaButton.layer.borderWidth = 2
        whoaButton.layer.borderColor = whoaColor.cgColor
        whoaButton.setTitleColor(whoaColor, for: .normal)
        whoaButton.layer.cornerRadius = 4
        
        commentButton.layer.borderWidth = 2
        commentButton.layer.borderColor = commentColor.cgColor
        commentButton.layer.cornerRadius = 4
        
        let index = Int(arc4random_uniform(UInt32(colors.count)))
        print(index)
        colorView.backgroundColor = UIColor.colorFromRGB(rgbValue: colors[index], alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
