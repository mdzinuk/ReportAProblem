//
//  DefaultLayoutSettings.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 15/11/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import UIKit

struct DefaultLayoutSettings {
    
    // Elements sizes
    var itemSize: CGSize?
    var headerSize: CGSize?
    
    var sectionsHeaderSize: CGSize?
    var sectionsFooterSize: CGSize?
    
    // Behaviours
    var isHeaderStretchy: Bool
    var isParallaxOnCellsEnabled: Bool
    
    // Spacing
    var minimumInteritemSpacing: CGFloat
    var minimumLineSpacing: CGFloat
    var maxParallaxOffset: CGFloat
}

extension DefaultLayoutSettings {
    
    init() {
        let bound = UIScreen.main.bounds.size
        self.itemSize = nil
        
        self.headerSize = CGSize(width: bound.width, height: 150)
        self.sectionsHeaderSize = CGSize(width: bound.width, height: 50)
        self.sectionsFooterSize = nil
        self.isHeaderStretchy = false
        self.isParallaxOnCellsEnabled = false
        self.maxParallaxOffset = 0.0
        self.minimumInteritemSpacing = 10.0
        self.minimumLineSpacing = 10.0
    }
}
