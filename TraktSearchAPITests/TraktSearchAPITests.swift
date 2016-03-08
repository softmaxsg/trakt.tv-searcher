//
//  TraktSearchAPITests.swift
//  TraktSearchAPITests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import TraktSearchAPI

class TraktSearchAPITests: XCTestCase
{
    func testInitializer()
    {
        let queue = NSOperationQueue()
        let applicationKey = NSUUID().UUIDString

        let searchAPI = TraktSearchAPI(queue: queue, applicationKey: applicationKey)
        XCTAssertNotNil(searchAPI)

        XCTAssertEqual(searchAPI.resultQueue, queue)
        XCTAssertEqual(searchAPI.applicationKey, applicationKey)
    }
}
