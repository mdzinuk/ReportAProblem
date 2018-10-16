//
//  MyCollectionViewCell.swift
//  DragAndDropInCollectionView
//
//  Created by Mohammad Arafat Hossain on 10/2/18.
//  Copyright © 2018 Payal Gupta. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor =  .orange // the color applied to the shadowLayer, rather than the view's backgroundColor
    
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
    
    func setModel(_ model: Model) {
        
        if model.isSelected {
            label.text = model.detail
        } else {
            label.text = model.title.capitalized
        }
        label.textColor = .gray//model.isSelected ? UIColor.lightGray : UIColor.gray
       // label.textColor = model.isHightLighted ? UIColor.lightGray : UIColor.orange
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isHighlighted: Bool{
        didSet{
            /*if isHighlighted{
             contentView.layer.borderColor = UIColor.green.cgColor
             //contentView.layer.masksToBounds = true;
             contentView.backgroundColor = .orange
             UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
             self.transform = self.transform.scaledBy(x: 1.25, y: 1.25)
             }, completion: nil)
             }else{
             contentView.layer.borderColor = UIColor.orange.cgColor
             contentView.backgroundColor = .green
             UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
             self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
             }, completion: nil)
             }*/
        }
    }
    
    override var isSelected: Bool{
        didSet{
            /*
             if isSelected {
             label.layer.borderColor = UIColor.green.cgColor
             label.backgroundColor = .orange
             } else{
             contentView.layer.borderColor = UIColor.orange.cgColor
             contentView.backgroundColor = .green
             }*/
        }
    }
}

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}


class RoundShadowView: UIView {
    
    let containerView = UIView()
    let cornerRadius: CGFloat = 6.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        
        //
        // add additional views to the containerView here
        //
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
