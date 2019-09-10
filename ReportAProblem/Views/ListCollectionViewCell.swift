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
        
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.borderWidth = 0.30
        layer.borderColor = UIColor.gray.cgColor
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func configure(_ item: Itemable?) {
        var iconColor = UIColor.darkGray
        var textColor = UIColor.lightGray
        var contentColor = UIColor.white
        var crossButtonColor = UIColor.lightGray
        if item?.isSpecial == true {
            contentColor = .orange
            iconColor = UIColor.white
            textColor = UIColor.white
            crossButtonColor = UIColor.white
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
                                                           attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.medium.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: crossButtonColor])
            titleLabel.isHidden = false
        } else {
            titleLabel.text = nil
            titleLabel.isHidden = true
        }
        titleLabel.backgroundColor = UIColor.clear
        backgroundColor = contentColor
    }
}
