//
//  ReportSubmitCollectionViewCell.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 11/11/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import UIKit

class ReportSubmitCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 0.50
        contentView.backgroundColor = .white
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.masksToBounds = true
        /*self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.9*/
        self.layer.masksToBounds = false
    }
    
    func configure(_ item: Itemable?) {
        let attributedText =  NSMutableAttributedString(string: item?.title ?? "",
                                                        attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.small.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedText.append(NSAttributedString(string: item?.subtitle ?? "",
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        titleLabel.attributedText = attributedText
        detailLabel.text = "\(item?.rightSubtitle ?? "")"
        
        //self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
