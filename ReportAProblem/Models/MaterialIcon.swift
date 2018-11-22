//
//  MaterialIcon.swift
//  DragAndDropInCollectionView
//
//  Created by Mohammad Arafat Hossain on 13/10/18.
//  Copyright © 2018 Payal Gupta. All rights reserved.
//

import Foundation
import UIKit

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
