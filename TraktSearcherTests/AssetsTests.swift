//
//  AssetsTests.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest

@testable import TraktSearcher

class AssetsTests: XCTestCase
{
    func testImageAssets()
    {
        XCTAssertNotNil(UIImage(named: ImageAssets.Background.rawValue))

        XCTAssertNotNil(UIImage(named: ImageAssets.Logo.rawValue))
    }
}
