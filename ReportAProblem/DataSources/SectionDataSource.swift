//
//  SectionDataSource.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 16/10/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices


struct Section<T: Itemable> {
    let title: String
    var items: [T]
    var titleDescription: String? {
        var count = 0
        items.forEach { (item: T) in
            if let i = item as? Itemable {
                count =  (i.isSelected == true) ? (count + 1) : count
            }
        }
        return title + ((count > 0) ? "\(count)" : "")
    }
    var isDragEnabled: Bool
}


final class CollectionViewDataManipulator<T: Itemable, C: ConfigurableCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate where C: UICollectionViewCell {
    
    var sections: [Section<T>]
    init(secions: [Section<T>]) {
        sections = secions
    }
    
    func getSelectedSections() -> [Section<T>]? {
        var selected = [Section<T>]()
        self.sections.forEach { (kSection:Section<T>) in
            kSection.items.forEach({ (kItem: T) in
                if kItem.isSelected == true || kItem.isDragged == false {
                    selected.append(kSection)
                }
            })
        }
        return selected
    }
    
    func getSelectedItems() -> [T]? {
        var selected = [T]()
        self.sections.forEach { (kSection: Section<T>) in
            kSection.items.forEach({ (kItem: T) in
                if kItem.isSelected == true || kItem.isDragged == false {
                    selected.append(kItem)
                }
            })
        }
        return selected
    }
    
    
    func item(at indexPath: IndexPath) -> T? {
        if indexPath.row < self.sections[indexPath.section].items.count &&
            indexPath.row >= 0 {
            return self.sections[indexPath.section].items[indexPath.row]
        }
        return nil
    }
    
    func update(item: T, at indexPath: IndexPath) {
        self.sections[indexPath.section].items[indexPath.row] = item
    }
    
    
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator,
                              destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: destinationIndexPath.section) {
                dIndexPath.row = collectionView.numberOfItems(inSection: destinationIndexPath.section) - 1
                if dIndexPath.row < 0 {
                    dIndexPath.row = 0
                }
            }
            collectionView.performBatchUpdates({
                self.sections[sourceIndexPath.section].items.remove(at: sourceIndexPath.row)
                guard let dragItem = item.dragItem.localObject as? Itemable  else {
                    return
                }
                if dragItem.isDragged != nil {
                    dragItem.isDragged = self.sections[dIndexPath.section].isDragEnabled
                }
                if dragItem.isSelected != nil {
                    dragItem.isSelected = dragItem.isSelected
                }
                
                sections[dIndexPath.section].items.insert(dragItem as! T, at: dIndexPath.row)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                guard let dragItem = item.dragItem.localObject as? Itemable  else {
                    return
                }
                if dragItem.isDragged != nil {
                    dragItem.isDragged = self.sections[indexPath.section].isDragEnabled
                }
                if dragItem.isSelected != nil {
                    dragItem.isSelected = dragItem.isSelected
                }
                
                self.sections[indexPath.section].items.insert(dragItem as! T, at: indexPath.row)
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
    
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.reuseIdentifier,
                                                            for: indexPath) as? C else {
                                                                return UICollectionViewCell()
        }
        
        if let item = self.item(at: indexPath) {
            cell.configure(item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case CollectionViewLayout.Element.sectionHeader.kind:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewLayout.Element.sectionHeader.id, for: indexPath) as! ShortVideoListHeader
            header.titleLabel.text = self.sections[indexPath.section].titleDescription
            
            header.setNeedsLayout()
            return header
            
        case CollectionViewLayout.Element.header.kind:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: CollectionViewLayout.Element.header.id,
                                                                         for: indexPath) as! CustomListHeader
            //header.backgroundColor = UIColor(patternImage: UIImage(named: "header")!)
            header.setNeedsLayout()
            return header
        case CollectionViewLayout.Element.sectionFooter.kind:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: CollectionViewLayout.Element.sectionFooter.id,
                                                                         for: indexPath) as! CustomListHeader
            //header.backgroundColor = UIColor(patternImage: UIImage(named: "header")!)
            header.setNeedsLayout()
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let item = self.item(at: indexPath) {
            let size1 = UILabel.textSize(font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.small.rawValue) ?? UIFont.systemFont(ofSize: 17), text: item.title)
            let size2 = UILabel.textSize(font: UIFont.systemFont(ofSize: 17), text: item.subtitle)
            var size3 = CGSize.zero
            if item.isDragged != nil {
                size3 = UILabel.textSize(font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.medium.rawValue) ?? UIFont.systemFont(ofSize: 17), text: (item.isDragged == false) ? Icon.IconLibrary.cancel.rawValue : "")
            }
            
            if item.isSelected != nil {
                size3 = UILabel.textSize(font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.medium.rawValue) ?? UIFont.systemFont(ofSize: 17), text:  Icon.IconLibrary.cancel.rawValue)
            }
            
            return CGSize(width: size1.width + size2.width + size3.width + 30, height: size2.height + 20)
        }
        return CGSize(width: 100, height: 40)
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
        if sections[indexPath.section].isDragEnabled == false {
            var dIndexPath = indexPath
            
            if let item = self.item(at: indexPath), item.isDragged != nil {
                collectionView.performBatchUpdates({
                    let section = indexPath.section - 1
                    if section >= 0 && section < collectionView.numberOfSections {
                        let row = collectionView.numberOfItems(inSection: section)
                        dIndexPath = IndexPath(row: row, section: section)
                        self.sections[indexPath.section].items.remove(at: indexPath.row)
                        item.isDragged = self.sections[dIndexPath.section].isDragEnabled
                        self.sections[dIndexPath.section].items.insert(item, at: dIndexPath.row)
                        collectionView.deleteItems(at: [indexPath])
                        collectionView.insertItems(at: [dIndexPath])
                    }
                })
            }
            
            
            if let item = self.item(at: indexPath), item.isSelected != nil {
                //self.sections[indexPath.section].items.remove(at: indexPath.row)
                item.isSelected = !item.isSelected!
                //self.sections[indexPath.section].items.insert(item, at: dIndexPath.row)
                self.update(item: item, at: indexPath)
                UIView.performWithoutAnimation {
                    collectionView.reloadSections([indexPath.section])
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard sections[indexPath.section].isDragEnabled == true else {
            return []
        }
        
        if let item = self.item(at: indexPath) {
            let itemProvider = NSItemProvider(object: item)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        }
        return []
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        itemsForAddingTo session: UIDragSession,
                        at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        
        guard sections[indexPath.section].isDragEnabled == true else {
            return []
        }
        if let item = self.item(at: indexPath) {
            let itemProvider = NSItemProvider(object: item)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        }
        
        return []
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let previewParameters = UIDragPreviewParameters()
        let cell = collectionView.cellForItem(at: indexPath)
        previewParameters.visiblePath = UIBezierPath(rect: cell?.bounds ?? CGRect.zero)
        return previewParameters
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: T.self)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break
            
        case .copy:
            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            
        default:
            return
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
