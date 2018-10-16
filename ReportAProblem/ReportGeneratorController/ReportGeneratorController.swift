//
//  SecondViewController.swift
//  DragAndDropInCollectionView
//
//  Created by Mohammad Arafat Hossain on 10/9/18.
//  Copyright © 2018 Payal Gupta. All rights reserved.
//

import UIKit

class ReportGeneratorController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewLayout = MosaicLayout()
    
    var currentDataSource: SectionsDataSource? {
        didSet {
            self.collectionView.dataSource = currentDataSource
            self.collectionView.delegate = currentDataSource
            self.collectionViewLayout.delegate = currentDataSource
            
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = collectionViewLayout
        
        collectionView.register(UINib(nibName: "SecondCollectionViewCell", bundle: .main),
                                 forCellWithReuseIdentifier: "kSecondCollectionViewCell")
        
       currentDataSource = SectionsDataSource(secions:
        [SectionsDataSource.Section(title: "section1",
                                    items: [Product(name: "Product 1 heidfds sdfsdf sdf sdfsdf sdf", category: "cat 1", price: 1.0),
                                            Product(name: "Product 2", category: "cat 2", price: 5.0),
                                            Product(name: "Product 5", category: "cat 4", price: 7.0),
                                            Product(name: "Mrs Romana Begom Ki", category: "cat 4", price: 7.0),
                                            Product(name: "Product 15 ", category: "cat 18", price: 7.0)]),
         SectionsDataSource.Section(title: "section 2",
                                    items: [Product(name: "Product 1", category: "cat 1", price: 1.0),
                                            Product(name: "Product 2", category: "cat 2", price: 5.0),
                                            Product(name: "Product 5", category: "cat 35", price: 7.0),
                                            Product(name: "Product aktoo boro dudu", category: "cat 34", price: 7.0),
                                            Product(name: "Product 7", category: "cat 33", price: 7.0),
                                            Product(name: "Product 5", category: "cat 31", price: 7.0),
                                            Product(name: "Product 8", category: "cat 32", price: 7.0)]),
         SectionsDataSource.Section(title: "section 3",
                                    items: [Product(name: "Product 1", category: "cat 1", price: 1.0),
                                            Product(name: "Product 2", category: "cat 2", price: 5.0),
                                            Product(name: "Product 5", category: "cat 35", price: 7.0),
                                            Product(name: "Product aktoo boro dudu", category: "cat 34", price: 7.0),
                                            Product(name: "Product 7", category: "cat 33", price: 7.0),
                                            Product(name: "Product 5", category: "cat 31", price: 7.0),
                                            Product(name: "Product 8", category: "cat 32", price: 7.0)]),
        SectionsDataSource.Section(title: "section 4",
                                   items: [Product(name: "Product 1 heidfds sdfsdf sdf sdfsdf sdf", category: "cat 1", price: 1.0),
                                           Product(name: "Product 2", category: "cat 2", price: 5.0),
                                           Product(name: "Product 5", category: "cat 4", price: 7.0),
                                           Product(name: "Mrs Romana Begom Ki", category: "cat 4", price: 7.0),
                                           Product(name: "Product 15 heelodd ", category: "cat 18", price: 7.0)]),
        SectionsDataSource.Section(title: "section 5",
                                   items: [Product(name: "Product 1", category: "cat 1", price: 1.0),
                                           Product(name: "Product 2", category: "cat 2", price: 5.0),
                                           Product(name: "Product 5", category: "cat 35", price: 7.0),
                                           Product(name: "Product aktoo boro dudu", category: "cat 34", price: 7.0),
                                           Product(name: "Product 7", category: "cat 33", price: 7.0),
                                           Product(name: "Product 5", category: "cat 31", price: 7.0),
                                           Product(name: "Product 8", category: "cat 32", price: 7.0)])
        ])
        
        
        
        collectionView.register(ShortVideoListHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        
       // collectionView.delegate = currentDataSource as! UICollectionViewDelegate
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = CGSize(width: view.bounds.width, height: 100)
    }
}


struct Product {
    let name: String
    let category: String
    let price: Double
    var selected: Bool?
    
    init(name: String, category: String, price: Double) {
        self.name = name
        self.category = category
        self.price = price
        self.selected = false
    }
    
    mutating func didSelected() {
        guard let sel = selected else {
            selected = true
            return
        }
        selected = !sel
    }
}

class SectionsDataSource: NSObject {
    struct Section {
        let title: String
        var items: [Product]
        var titleDescription: String? {
            return title + "(\(items.filter({$0.selected == true}).count))"
        }
    }
    var sections: [Section]
    
    init(secions: [Section]) {
        sections = secions
    }
    
    func myItem(at indexPath: IndexPath) -> Product {
        return self.sections[indexPath.section].items[indexPath.row]
    }
    func update(item: Product, at indexPath: IndexPath) {
        self.sections[indexPath.section].items[indexPath.row] = item
    }

}

extension SectionsDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kSecondCollectionViewCell", for: indexPath) as! SecondCollectionViewCell
        cell.loadItem(self.myItem(at: indexPath))//self.sections[indexPath.section].items[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! ShortVideoListHeader
            header.titleLabel.text = self.sections[indexPath.section].titleDescription
            
            header.setNeedsLayout()
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
}

extension SectionsDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let text = self.myItem(at: indexPath).name
            let size = UILabel.textSize(font: UIFont.systemFont(ofSize: 17), text: text)
            return CGSize(width: size.width + 40, height: size.height + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item = self.myItem(at: indexPath)
        item.didSelected()
        self.update(item: item, at: indexPath)
        
        UIView.performWithoutAnimation {
            //collectionView.reloadItems(at: [indexPath])
            collectionView.reloadSections([indexPath.section])
        }
    }
}

extension SectionsDataSource : MyLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView(collectionView,
                                   layout: collectionView.collectionViewLayout,
                                   sizeForItemAt: indexPath)
    }
}


extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)
        return ceil(labelSize.width)
    }
    
    class func textSize(font: UIFont, text: String) -> CGSize {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)
        return labelSize.size
    }
}
