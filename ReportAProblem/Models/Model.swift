import Foundation
import UIKit

enum ItemError: Error {
    case identifierError
}

protocol ConfigurableCell: class {
    func configure(_ item: Itemable?)
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension ConfigurableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: Self.reuseIdentifier, bundle: .main)
    }
}

public protocol Itemable: Codable, NSItemProviderWriting, NSItemProviderReading {
    var title: String { get }
    var subtitle: String { get }
    var rightSubtitle: String { get }
    var isDragged: Bool? { get set }
    var isSelected: Bool? { get set }
    var isSpecial: Bool { get }
    static var Identifier: String { get }
    init(title: String, subtitle: String, rightSubtitle: String, isDraggable: Bool)
    func didDrop()
}

extension Itemable {
    var title: String { return "" }
    var subtitle: String { return "" }
    var rightSubtitle: String { return "" }
    static var Identifier: String {
        return String(describing: type(of: self))
    }
    
    func didDrop() {
        guard let isDragged = isDragged else {
            return
        }
        self.isDragged = !isDragged
    }
}

extension Itemable where Self: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.title == rhs.title &&
            lhs.subtitle == rhs.subtitle &&
            lhs.rightSubtitle == rhs.rightSubtitle &&
            lhs.isDragged == rhs.isDragged
    }
}

@objc final class Item: NSObject, Itemable {
    var title: String
    var subtitle: String
    var rightSubtitle: String
    var isDragged: Bool?
    var isSelected: Bool?
    var isSpecial: Bool
    
    init(title: String, subtitle: String, rightSubtitle: String, isDraggable: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.rightSubtitle = rightSubtitle
        self.isDragged = isDraggable
        self.isSpecial = false
    }
    
    init(title: String, subtitle: String, rightSubtitle: String, isSelectable: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.rightSubtitle = rightSubtitle
        self.isSelected = isSelectable
        self.isSpecial = false
    }
    
    init(title: String, subtitle: String, rightSubtitle: String, isSpecial: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.rightSubtitle = rightSubtitle
        self.isDragged = true
        self.isSpecial = true
    }
}

extension Item {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [self.Identifier]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Item {
        return try self.object(withItemProviderData: data, typeIdentifier: typeIdentifier)
    }
}

extension Item {
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [self.Identifier]
    }
    
    @objc func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil//return self.loadData(withTypeIdentifier:typeIdentifier, forItemProviderCompletionHandler: completionHandler)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.title == rhs.title &&
            lhs.subtitle == rhs.subtitle &&
            lhs.rightSubtitle == rhs.rightSubtitle &&
            lhs.isDragged == rhs.isDragged
    }
}
