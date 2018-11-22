//
//  File.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 15/11/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

//import UIKit
//
//class CustomListHeader: UICollectionReusableView {
//    let imageView = UIImageView()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        imageView.image = UIImage(named: "header")
//        addSubview(imageView)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
//}


import UIKit

class CustomListHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.95)
        clipsToBounds = true
        
        addSubview(label)
        
        let views = ["label": label]
        
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
        imageView.contentMode = .scaleAspectFill
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
