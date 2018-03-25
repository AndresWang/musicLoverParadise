//
//  Music_Lover_ParadiseUITests.swift
//  Music Lover ParadiseUITests
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import XCTest

class Music_Lover_ParadiseUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImportantUIFlow() {
        let app = XCUIApplication()
        sleep(3)
        app.typeText("your song")
        app.typeText("\n")
        sleep(3)
        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["2017"]/*[[".cells.staticTexts[\"2017\"]",".staticTexts[\"2017\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        sleep(3)
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Rita Ora"].tap()
        sleep(3)
        app.otherElements.element.children(matching: .scrollView).element.swipeUp()
        let navigationBar = app.navigationBars.element
        navigationBar.buttons.element.tap()
        navigationBar.buttons.element.tap()
    }
    
}
