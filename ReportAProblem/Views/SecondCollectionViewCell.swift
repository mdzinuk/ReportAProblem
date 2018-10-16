//
//  SecondCollectionViewCell.swift
//  DragAndDropInCollectionView
//
//  Created by Mohammad Arafat Hossain on 10/9/18.
//  Copyright © 2018 Payal Gupta. All rights reserved.
//

import UIKit

class SecondCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    func loadItem(_ item: Item) {
        //label.text = product.name
        
        var string = NSAttributedString(string: Icon.IconLibrary.add_circle.rawValue,
                                        attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.small.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.orange])
        if item.selected == true {
            string =  NSAttributedString(string: Icon.IconLibrary.add_circle.rawValue,
                                         attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.small.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.red])
        }
        
        let attributedText = NSMutableAttributedString(string: item.title,
                                                       attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
        attributedText.append(string)
        
        label.attributedText = attributedText
        
        /*label.text = product.name + Icon.IconLibrary.shopping_cart.rawValue
         label.font = UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.small.rawValue)*/
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        
        contentView.backgroundColor = .white
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.9
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
}
