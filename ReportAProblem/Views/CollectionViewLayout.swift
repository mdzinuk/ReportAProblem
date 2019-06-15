/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Custom view flow layout for mosaic-style appearance.
 */

import UIKit
import Foundation

protocol CollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class CollectionViewLayout: UICollectionViewLayout {
    init(with layout: CustomLayoutSettings? = nil) {
        super.init()
        self.layout = layout ?? CustomLayoutSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: CollectionViewLayoutDelegate?
    var contentBounds = CGRect.zero
    private var cachedAttributes = [Element: [IndexPath: CustomLayoutAttributes]]()
    public var layout: CustomLayoutSettings?
    
    enum Element: String {
        case header
        case menu
        case sectionHeader
        case sectionFooter
        case cell
        
        var id: String {
            return self.rawValue
        }
        
        var kind: String {
            return "Kind\(self.rawValue.capitalized)"
        }
    }
    
    
    
    override public class var layoutAttributesClass: AnyClass {
        return CustomLayoutAttributes.self
    }
    
    private func prepareCache() {
        cachedAttributes.removeAll(keepingCapacity: true)
        cachedAttributes[.header] = [IndexPath: CustomLayoutAttributes]()
        cachedAttributes[.menu] = [IndexPath: CustomLayoutAttributes]()
        cachedAttributes[.sectionHeader] = [IndexPath: CustomLayoutAttributes]()
        cachedAttributes[.sectionFooter] = [IndexPath: CustomLayoutAttributes]()
        cachedAttributes[.cell] = [IndexPath: CustomLayoutAttributes]()
    }
    
    private func prepareElement(rect: CGRect, size: CGSize,
                                type: Element, attributes: CustomLayoutAttributes) -> CGRect {
        guard size != .zero else { return CGRect.zero }
        let spacing = layout?.minimumInteritemSpacing ?? 0
        
        let interimOrigin = CGPoint(x: rect.minX + spacing, y: rect.maxY + spacing)
        let reducedSize = CGSize(width: size.width - (2 * spacing), height: size.height)
        attributes.frame = CGRect(origin: interimOrigin, size: reducedSize)
        attributes.zIndex = 1000//attributes.indexPath.section
        cachedAttributes[type]?[attributes.indexPath] = attributes
        let rectt = rect.union(attributes.frame)
        return rectt
    }
    
    
    private func prepareItem(givenFrame: CGRect, size: CGSize, type: Element, attributes: CustomLayoutAttributes) -> CGRect {
        let spacing = layout?.minimumInteritemSpacing ?? 0
        
        let minX = givenFrame.maxX + size.width + (2 * spacing)
        let maxX = collectionViewWidth - (2 * spacing)
        
        attributes.frame = minX > maxX ?
            CGRect(origin: CGPoint(x: spacing, y: givenFrame.maxY + spacing), size: size) :
            CGRect(origin: CGPoint(x: givenFrame.maxX + spacing, y: givenFrame.origin.y), size: size)
        attributes.zIndex = 0//attributes.indexPath.row
        cachedAttributes[type]?[attributes.indexPath] = attributes
        return attributes.frame
    }
    
    private func getItemSize(_ indexPath: IndexPath) -> CGSize {
        guard let itemSize = layout?.itemSize else {
            guard let collectionView = collectionView,
                let itemDynamicSize = delegate?.collectionView(collectionView, sizeForItemAt: indexPath) else {
                    return CGSize.zero
            }
            return itemDynamicSize
        }
        return itemSize
    }
    
    /// - Tag: PrepareMosaicLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        prepareCache()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        var lastFrame: CGRect = .zero
        
        let headerAttributes = CustomLayoutAttributes(
            forSupplementaryViewOfKind: Element.header.kind,
            with: IndexPath(item: 0, section: 0)
        )
        lastFrame = prepareElement(rect: CGRect.zero,
                                   size: layout?.headerSize ?? CGSize.zero,
                                   type: .header, attributes: headerAttributes)
        
        for section in 0 ..< collectionView.numberOfSections {
            
            let sectionAttribute = CustomLayoutAttributes(forSupplementaryViewOfKind:Element.sectionHeader.kind,
                                                          with: IndexPath(item: 0, section: section))
            let sectionFrame = prepareElement(rect: lastFrame,
                                              size: layout?.sectionsHeaderSize ?? CGSize.zero,
                                              type: .sectionHeader, attributes: sectionAttribute)
            
            lastFrame = lastFrame.union(sectionFrame)
            var initItemFrame = CGRect(x: lastFrame.minX, y: lastFrame.maxY + (layout?.minimumInteritemSpacing ?? 0), width: lastFrame.minX, height: lastFrame.minY)
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                
                let itemIndex = IndexPath(item: item, section: section)
                let itemSize = getItemSize(itemIndex)
                let itemAttributes = CustomLayoutAttributes(forCellWith: itemIndex)
                let itemFrame = prepareItem(givenFrame: initItemFrame, size: itemSize,
                                            type: .cell, attributes: itemAttributes)
                initItemFrame = itemFrame
                lastFrame = lastFrame.union(initItemFrame)
            }
            contentBounds = contentBounds.union(lastFrame)
        }
    }
    
    private var contentOffset: CGPoint {
        return collectionView!.contentOffset
    }
    
    private var collectionViewHeight: CGFloat {
        return collectionView!.frame.height
    }
    
    private var collectionViewWidth: CGFloat {
        return collectionView!.frame.width
    }
    
    /// - Tag: CollectionViewContentSize
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    /// - Tag: ShouldInvalidateLayout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                       at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case Element.sectionHeader.kind:
            return cachedAttributes[.sectionHeader]?[indexPath]
            
        case Element.sectionFooter.kind:
            return cachedAttributes[.sectionFooter]?[indexPath]
            
        case Element.header.kind:
            return cachedAttributes[.header]?[indexPath]
            
        default:
            return cachedAttributes[.menu]?[indexPath]
        }
    }
    
    /// - Tag: LayoutAttributesForItem
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[.cell]?[indexPath]
    }
    
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [CustomLayoutAttributes]()
        
        guard let collectionView = collectionView else {
            return nil
        }
        // 1
        let halfHeight = collectionViewHeight * 0.5
        // 2
        for (type, elementInfos) in cachedAttributes {
            for (indexPath, attributes) in elementInfos {
                // 3
                attributes.parallax = .identity
                attributes.transform = .identity
                // 4
                updateSupplementaryViews(
                    type,
                    attributes: attributes,
                    collectionView: collectionView,
                    indexPath: indexPath)
                if attributes.frame.intersects(rect) {
                    // 5
                    if type == .cell {
                        let halfCellHeight = getItemSize(indexPath).height * 0.5
                        updateCells(attributes, halfHeight: halfHeight, halfCellHeight: halfCellHeight)
                    }
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes
    }
    
    private func updateSupplementaryViews(_ type: Element, attributes: CustomLayoutAttributes, collectionView: UICollectionView, indexPath: IndexPath) {
        // 1
        if type == .sectionHeader {
            let upperLimit =
                CGFloat(collectionView.numberOfItems(inSection: indexPath.section))
                    * (getItemSize(indexPath).height + (layout?.minimumInteritemSpacing ?? 10.0))
            attributes.transform =  CGAffineTransform(
                translationX: 0,
                y: min(upperLimit,
                       max(0, contentOffset.y - attributes.initialOrigin.y)))
        }
            // 2
        else if type == .header {
            guard let headerSize = layout?.headerSize else { return }
            
            let updatedHeight = min(
                collectionView.frame.height,
                max(headerSize.height, headerSize.height - contentOffset.y))
            
            let scaleFactor = updatedHeight / headerSize.height
            let delta = (updatedHeight - headerSize.height) / 2
            let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            let translation = CGAffineTransform(
                translationX: 0,
                y: min(contentOffset.y, headerSize.height) + delta)
            attributes.transform = scale.concatenating(translation)
            attributes.headerOverlayAlpha = min(0.4, contentOffset.y / headerSize.height)
        }
    }
    
    private func updateCells(_ attributes: CustomLayoutAttributes, halfHeight: CGFloat, halfCellHeight: CGFloat) {
       let cellDistanceFromCenter = attributes.center.y - contentOffset.y - halfHeight
        
        // 2
        let parallaxOffset = -((layout?.maxParallaxOffset ?? 30) * cellDistanceFromCenter)
            / (halfHeight + halfCellHeight)
        // 3
        let boundedParallaxOffset = min(
            max(-(layout?.maxParallaxOffset ?? 30), parallaxOffset),
            (layout?.maxParallaxOffset ?? 30))
        // 4
        attributes.parallax = CGAffineTransform(translationX: 0, y: boundedParallaxOffset)
    }
}
