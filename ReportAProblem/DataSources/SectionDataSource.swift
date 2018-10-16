//
//  SectionDataSource.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 16/10/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import Foundation
import UIKit

struct Item {
    let title: String
    let subtitle: String
    let rightSubtitle: String
    var selected: Bool?
    
    init(title: String, subtitle: String, rightSubtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.rightSubtitle = rightSubtitle
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


class CollectionViewDataManipulator: NSObject {
    struct Section {
        let title: String
        var items: [Item]
        var titleDescription: String? {
            return title + "(\(items.filter({$0.selected == true}).count))"
        }
    }
    var sections: [Section]
    
    init(secions: [Section]) {
        sections = secions
    }
    
    func item(at indexPath: IndexPath) -> Item {
        return self.sections[indexPath.section].items[indexPath.row]
    }
    func update(item: Item, at indexPath: IndexPath) {
        self.sections[indexPath.section].items[indexPath.row] = item
    }
    
}

extension CollectionViewDataManipulator: UICollectionViewDataSource {
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
        cell.loadItem(self.item(at: indexPath))//self.sections[indexPath.section].items[indexPath.row].name
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

extension CollectionViewDataManipulator: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = self.item(at: indexPath).title
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
        var item = self.item(at: indexPath)
        item.didSelected()
        self.update(item: item, at: indexPath)
        
        UIView.performWithoutAnimation {
            //collectionView.reloadItems(at: [indexPath])
            collectionView.reloadSections([indexPath.section])
        }
    }
}

extension CollectionViewDataManipulator : CollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView(collectionView,
                                   layout: collectionView.collectionViewLayout,
                                   sizeForItemAt: indexPath)
    }
}
