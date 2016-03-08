//
//  TracktSearchAPITests.swift
//  TracktSearchAPITests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import TracktSearchAPI

class TracktSearchAPITests: XCTestCase
{
    func testInitializer()
    {
        let queue = NSOperationQueue()
        let applicationKey = NSUUID().UUIDString

        let searchAPI = TracktSearchAPI(queue: queue, applicationKey: applicationKey)
        XCTAssertNotNil(searchAPI)

        XCTAssertEqual(searchAPI.resultQueue, queue)
        XCTAssertEqual(searchAPI.applicationKey, applicationKey)
    }
}
