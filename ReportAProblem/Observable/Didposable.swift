//
//  Didposable.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 20/10/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import Foundation
import Foundation

public final class Disposable {
    
    private let dispose: () -> ()
    
    init(_ dispose: @escaping () -> ()) {
        self.dispose = dispose
    }
    
    deinit {
        dispose()
    }
}
