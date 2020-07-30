//
//  SelectionViewCell.swift
//  SASelectionView
//
//  Created by Srujan Simha Adicharla on 7/29/20.
//  Copyright © 2020 Srujan Simha Adicharla. All rights reserved.
//

import UIKit

class SelectionViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // disable Xcode inset defaults
        backgroundColor = .clear
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
