//
//  ML_iOSTests.swift
//  ML_iOSTests
//
//  Created by Daniil Ignatev on 19.07.23.
//

import XCTest
@testable import ML_iOS

final class ML_iOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    
//    func testOLS_1() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//
//        let w0 = ML.ols_1(input: [1,2,3], out: [2,4,6])
//        XCTAssert(w0 == 2)
//    }
    
//    func testGettingVector() throws {
//        let points = [CGPoint(x: 2, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 3, y: 1), CGPoint(x: 0, y: 2), CGPoint(x: 4, y: 2), CGPoint(x: 1, y: 3), CGPoint(x: 3, y: 3), CGPoint(x: 2, y: 4)]
//        let resultVector = Figures_Recogniser_UI.getVector(from: points, length: 5)
//        let expectedVector = [
//            0, 0, 1, 0, 0,
//            0, 1, 0, 1, 0,
//            1, 0, 0, 0, 1,
//            0, 1, 0, 1, 0,
//            0, 0, 1, 0, 0
//        ]
//        XCTAssertEqual(expectedVector, resultVector)
//    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
