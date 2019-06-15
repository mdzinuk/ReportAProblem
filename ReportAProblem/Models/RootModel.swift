//
//  RootModel.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 28/10/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import Foundation
import UIKit


struct ListViewModel {
    /*static func reportModels() -> [Item] {
        return SectionName.allSections().map { (section) in
            return Item(title: section.title, subtitle: section.subTitle, rightSubtitle: "", isSelectable: false)
        }
    }*/
    
    static func listModels(modules: [Module]) -> [Item] {
        var mm =
            modules
                .map { SectionName(rawValue: $0.feature)}
                .compactMap({$0})
                .map({
                    Item(title: $0.title,
                         subtitle: $0.subTitle,
                         rightSubtitle: "",
                         isDraggable: true)
                })
        //mm.append(ListViewModel.customModel())
        return mm
    }
    
    static func customModel() -> Item {
        return Item(title: Icon.IconLibrary.add_box.rawValue, subtitle: "Compose", rightSubtitle: "", isSpecial: true)
    }
    
    static func reportModels(module: Module) -> [Item] {
        var items = [Item]()
        
        module.issues?.forEach({ (issue: Issue) in
            items.append(Item(title: SectionName(rawValue: module.feature)?.title ?? "", subtitle: issue.description, rightSubtitle: issue.other, isSelectable: true))
        })
        return items
    }
}

enum SectionName: String {

    static func allSections() -> [SectionName] {
        return [login, feed, profile, location, order, shipping, card, cart, notification]
    }
    
    case login = "Login"
    case feed = "News Feed"
    case profile = "Profile"
    case location = "GPS"
    case order = "Order error"
    case shipping = "Shipping"
    case card = "Master Card"
    case cart = "Shopping cart"
    case notification = "Push Notification"
    
    var title: String {
        switch self {
        case .login:
            return Icon.IconLibrary.person.rawValue
        case .feed:
            return Icon.IconLibrary.home.rawValue
        case .profile:
            return Icon.IconLibrary.account_circle.rawValue
        case .order:
            return Icon.IconLibrary.account_balance.rawValue
        case .location:
            return Icon.IconLibrary.location_searching.rawValue
        case .shipping:
            return Icon.IconLibrary.transform.rawValue
        case .card:
            return Icon.IconLibrary.settings_input_antenna.rawValue
        case .cart:
            return Icon.IconLibrary.credit_card.rawValue
        case .notification:
            return Icon.IconLibrary.payment.rawValue
        }
    }
    
    var subTitle: String {
        return rawValue
    }
}


struct Module: Codable {
    let feature: String
    let detail: String
    let issues: [Issue]?
}
//extension Module {
//    init(_ itemable: Itemable) {
//        self = Module(feature : itemable.title, detail: itemable.subtitle)
//    }
//}

struct Issue: Codable {
    let id: Int
    let title: String
    let description: String
    let other: String
}
