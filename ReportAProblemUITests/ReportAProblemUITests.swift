//
//  ReportAProblemUITests.swift
//  ReportAProblemUITests
//
//  Created by Mohammad Arafat Hossain on 13/10/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import XCTest

class ReportAProblemUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
       continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
      // let page = app.otherElements["__page__ListViewController"]
        
        let firstChild = app.collectionViews.children(matching:.any).element(boundBy: 3)
        let destination = app.collectionViews.children(matching:.any).element(boundBy: 11)
        let doneButton = app.buttons["doneButton"]
        if firstChild.exists && doneButton.exists {
            //.tap()
            firstChild.dragAndDropUsingCenterPos(forDuration: 0.5, thenDragTo: destination)
            doneButton.tap()
            
            let reportGeneratorController = app.otherElements["__page__ReportGeneratorController"]
            let exists = NSPredicate(format: "exists == 1")
            expectation(for: exists, evaluatedWith: reportGeneratorController, handler: nil)
            waitForExpectations(timeout: 5, handler: nil)
            let numbertwo = app.collectionViews.children(matching:.any).element(boundBy: 3)
            numbertwo.tap()
            sleep(5)
            
            let secondDone = app.navigationBars.buttons["doneButton"]
            secondDone.tap()
            
            sleep(5)

        }
    }

}


extension XCUIElement {
    
    func dragAndDropUsingCenterPos(forDuration duration: TimeInterval,
                                   thenDragTo destElement: XCUIElement) {
        
        let sourceCoordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.5, dy:0.5))
        
        let destCorodinate: XCUICoordinate = destElement.coordinate(withNormalizedOffset: CGVector(dx:0.5, dy:0.5))
        
        sourceCoordinate.press(forDuration: duration, thenDragTo: destCorodinate)
    }
    
}
