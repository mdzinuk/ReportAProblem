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
        mm.append(ListViewModel.customModel())
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
        return [login, account, accountDetail, location, transfer, sso, creditScore, payment, notifi]
    }
    
    case login = "Login"
    case account = "Account"
    case accountDetail = "Account Detail"
    case location = "Location"
    case transfer = "Transfer"
    case sso = "SSO"
    case creditScore = "CreditScore"
    case payment = "Payment"
    case notifi = "Notifi"
    
    var title: String {
        switch self {
        case .login:
            return Icon.IconLibrary.person.rawValue
        case .notifi:
            return Icon.IconLibrary.home.rawValue
        case .account:
            return Icon.IconLibrary.account_circle.rawValue
        case .accountDetail:
            return Icon.IconLibrary.account_balance.rawValue
        case .location:
            return Icon.IconLibrary.location_searching.rawValue
        case .transfer:
            return Icon.IconLibrary.transform.rawValue
        case .sso:
            return Icon.IconLibrary.settings_input_antenna.rawValue
        case .creditScore:
            return Icon.IconLibrary.credit_card.rawValue
        case .payment:
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
