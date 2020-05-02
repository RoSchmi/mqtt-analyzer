//
//  MQTTAnalyzerUITests.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 01.05.20.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import XCTest

class TakeScreenshots: XCTestCase {
	var app: MQTTAnalyzer!

    override func setUp() {
        continueAfterFailure = false
		app = MQTTAnalyzer()
		setupSnapshot(app.app)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testMain() {
		app.launch()
		
		snapshot("Main")
	}
	
	func testAbout() {
		app.launch()
		
		app.openAbout()
		snapshot("About")
		app.closeAbout()
	}
	
	func testSettings() {
		app.launch()
		
		app.openSettings()
		snapshot("Settings")
		app.cancelSettings()
	}
}
