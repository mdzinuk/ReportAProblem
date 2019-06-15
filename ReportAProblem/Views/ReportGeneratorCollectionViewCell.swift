//
//  ReportGeneratorCollectionViewCell.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 30/10/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import UIKit

final class ReportGeneratorCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var crossLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ item: Itemable?) {
        let attributedText =  NSMutableAttributedString(string: item?.title ?? "",
                                                        attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.small.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        attributedText.append(NSAttributedString(string: item?.subtitle ?? "",
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        titleLabel.attributedText = attributedText
        if item?.isSelected == false {
            crossLabel.attributedText = NSAttributedString(string: Icon.IconLibrary.remove_circle_outline.rawValue,
                                                           attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.medium.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
          //  crossLabel.isHidden = false
        } else {
            crossLabel.attributedText = NSAttributedString(string: Icon.IconLibrary.remove_circle_outline.rawValue,
                                                           attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.medium.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.orange])
           // crossLabel.text = nil
          //  crossLabel.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 0.50
        
        contentView.backgroundColor = .white
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        self.contentView.layer.masksToBounds = true
        /*
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.9
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath*/
    }
    
}
