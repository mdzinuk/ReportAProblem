//
//  ShortVideoListHeader.swift
//  DragAndDropInCollectionView
//
//  Created by Mohammad Arafat Hossain on 10/9/18.
//  Copyright © 2018 Payal Gupta. All rights reserved.
//

import UIKit

class ShortVideoListHeader: UICollectionReusableView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textColor = .orange
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint(x: 15, y: (frame.height/2 - (titleLabel.frame.height) / 2))
        layer.borderWidth = 2.0
        layer.backgroundColor = UIColor.white.cgColor
        layer.borderColor = UIColor.white.cgColor
        layer.masksToBounds = true
    }
}
