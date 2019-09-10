//
//  CustomListHeader.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 15/11/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//


import UIKit

class CustomListHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white//UIColor(displayP3Red: 0.835, green: 0.392, blue: 0.192, alpha: 1.0)
        clipsToBounds = true
        
        addSubview(imageView)
        
        let views = ["label": imageView]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[label]-50-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[label]-20-|", options: [], metrics: nil, views: views))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        label.text = nil
        
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "header")
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.contentMode = .scaleAspectFill
        label.numberOfLines = 0
        label.textColor = .orange
        label.text = "To support drag and drop, you need to drag top rows to bottom section. To support drag and drop, you need to drag top rows to bottom section."
        return label
    }()
}
