//
//  Observable.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 20/10/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import Foundation

public final class Observable<T> {
    
    public typealias Observer = (T) -> Void
    
    private var observers: [Int: Observer] = [:]
    private var uniqueID = (0...).makeIterator()
    
    public var value: T {
        didSet {
            observers.values.forEach { $0(value) }
        }
    }
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func observe(_ observer: @escaping Observer) -> Disposable {
        guard let id = uniqueID.next() else { fatalError("There should always be a next unique id") }
        
        observers[id] = observer
        observer(value)
        
        let disposable = Disposable {
            self.observers[id] = nil
        }
        
        return disposable
    }
    
    public func removeAllObservers() {
        observers.removeAll()
    }
}
