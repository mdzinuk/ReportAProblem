/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Custom view flow layout for mosaic-style appearance.
 */

import UIKit

protocol CollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class CollectionViewLayout: UICollectionViewLayout {
    weak var delegate: CollectionViewLayoutDelegate?
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    /// - Tag: PrepareMosaicLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        var lastFrame: CGRect = .zero
        let padding: CGFloat = 10.0
        let contentMaxWidth = collectionView.bounds.size.width
        for section in 0 ..< collectionView.numberOfSections {
            // Handle Sections
            let sectionIndex = IndexPath(item: 0, section: section)
            let sectionHeaderAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: sectionIndex)
            sectionHeaderAttributes.frame = CGRect(x: contentBounds.minX + padding,
                                                   y: lastFrame.maxY + padding,
                                                   width: contentMaxWidth - (2 * padding), height: 50)
            cachedAttributes.append(sectionHeaderAttributes)
            lastFrame = sectionHeaderAttributes.frame
            
            // Handle Items
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let itemIndex = IndexPath(item: item, section: section)
                let delSize = delegate?.collectionView(collectionView, sizeForItemAt: itemIndex) ?? CGSize.zero
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: itemIndex)
                
                let needNewLine = ((lastFrame.maxX + delSize.width + (2 * padding)) > (contentMaxWidth - (2 * padding))) ? true : false
                
                if itemIndex.row > 2 {
                    print("================\(itemIndex.row)=============")
                    print((lastFrame.size.width + delSize.width + (2 * padding)))
                    print((contentMaxWidth - (2 * padding)))
                    print("=============================")
                }
                
                if needNewLine == true {
                    itemAttributes.frame = CGRect(x: contentBounds.minX + padding,
                                                  y: lastFrame.maxY + padding,
                                                  width: delSize.width, height: delSize.height)
                } else {
                    itemAttributes.frame = CGRect(x: lastFrame.maxX + padding,
                                                  y: lastFrame.origin.y,
                                                  width: delSize.width, height: delSize.height)
                }
                
                cachedAttributes.append(itemAttributes)
                lastFrame = itemAttributes.frame
                contentBounds = contentBounds.union(lastFrame)
            }
        }
    }
    
    /// - Tag: CollectionViewContentSize
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    /// - Tag: ShouldInvalidateLayout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    /// - Tag: LayoutAttributesForItem
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    /// - Tag: LayoutAttributesForElements
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        
        // Find any cell that sits within the query rect.
        guard let lastIndex = cachedAttributes.indices.last,
            let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }
        
        // Starting from the match, loop up and down through the array until all the attributes
        // have been added within the query rect.
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }
        
        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }
        
        return attributesArray
    }
    
    // Perform a binary search on the cached attributes array.
    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }
        
        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]
        
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }
    
}
