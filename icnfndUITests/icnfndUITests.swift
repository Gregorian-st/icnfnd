//
//  icnfndUITests.swift
//  icnfndUITests
//
//  Created by Grigory Stolyarov on 03.08.2024.
//

import XCTest

final class icnfndUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainViewController() throws {
        
        let getIconsExpectation = expectation(description: "Get Images from service Expectation")
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["Search Text"].tap()
        
        app.typeText("arrow")
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Search"]/*[[".buttons[\"Search\"].staticTexts[\"Search\"]",".staticTexts[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        DispatchQueue.global().async {
            while app.tables.cells.count == 0 { }
            getIconsExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testLaunchPerformance() throws {
        if #available(iOS 14.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
