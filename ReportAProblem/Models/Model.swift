import Foundation
import UIKit

class Model {
    var isHightLighted: Bool
    var isSelected: Bool
    var title: String
    var detail: String
    private let  unselectedsize: CGSize
    private let selectedSize: CGSize
    
    
    init(_ high: Bool, _ sel: Bool, _ t: String, _ d: String) {
        isHightLighted = high
        isSelected = sel
        title = t
        detail = d
        unselectedsize = Model.textSize(font: UIFont.systemFont(ofSize: 17.0), text: t)
        selectedSize = Model.textSize(font: UIFont.systemFont(ofSize: 17.0), text: d)
    }
}

extension Model {
    static func allObject() -> [Model] {
        return [Model(false, false, "First Mohammad", "bezierPathWithRoundedRect Hello we have little kar posha pakhi noyon"),
                Model(false, false, "Second Md", "chrome"),
                Model(false, false, "Third Arafat", "falseColor"),
                Model(false, false, "Fourth Mohammad Arafat", "instant"),
                Model(false, false, "Five Arafat", "mono"),
                Model(false, false, "Six", "noir"),
                Model(false, false, "Seven", "process"),
                Model(false, false, "Eight Zinuk", "sepia"),
                Model(false, false, "Nine", "tonal"),
                Model(false, false, "Ten Hossain", "transfer")]
    }
    
    class func textSize(font: UIFont, text: String) -> CGSize {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)
        return labelSize.size
    }
}

extension Model: Equatable, Hashable {
    var hashValue: Int {
        return title.hashValue
    }
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.title == rhs.title && lhs.detail == rhs.detail
    }
    
    var size: CGSize {
        return isSelected ? selectedSize : unselectedsize
    }
}


struct Icon {
    enum IconLibrary: String {
        case shopping_cart = "\u{E8CC}"
        case add_circle = "\u{e147}"
    }
    enum IconSize: CGFloat {
        case small = 20.0
    }
    enum IconFont: String {
        case material = "MaterialIcons-Regular"
    }
}
