//
//  ListCollectionViewCell.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 25/10/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import UIKit


final class ListCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1.0
        //self.layer.backgroundColor = UIColor.red.cgColor
        //self.backgroundColor = .white
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func configure(_ item: Itemable?) {
        var iconColor = UIColor.darkGray
        var textColor = UIColor.lightGray
        var contentColor = UIColor.white
        if item?.isSpecial == true {
            contentColor = .orange
            iconColor = UIColor.white
            textColor = UIColor.white
        }
        
        
        let attributedText =  NSMutableAttributedString(string: item?.title ?? "",
                                                        attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.small.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: iconColor])
        
        attributedText.append(NSAttributedString(string: item?.subtitle ?? "",
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: textColor]))
        crossButton.setAttributedTitle(attributedText, for: .normal)
        crossButton.setAttributedTitle(attributedText, for: .highlighted)
        crossButton.setAttributedTitle(attributedText, for: .selected)
        crossButton.backgroundColor = UIColor.clear
        if item?.isDragged == false {
            titleLabel.attributedText = NSAttributedString(string: Icon.IconLibrary.cancel.rawValue,
                                                           attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.medium.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            titleLabel.isHidden = false
        } else {
            titleLabel.text = nil
            titleLabel.isHidden = true
        }
        titleLabel.backgroundColor = UIColor.clear
        backgroundColor = contentColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /* self.contentView.layer.cornerRadius = 10.0
         self.contentView.layer.borderWidth = 1.0
         
         contentView.backgroundColor = .white
         self.contentView.layer.borderColor = UIColor.lightGray.cgColor
         
         
         
         self.contentView.layer.masksToBounds = true
         
         self.layer.shadowColor = UIColor.gray.cgColor
         self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
         self.layer.shadowRadius = 2.0
         self.layer.shadowOpacity = 0.9
         self.layer.masksToBounds = false
         self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath*/
    }
    
}
