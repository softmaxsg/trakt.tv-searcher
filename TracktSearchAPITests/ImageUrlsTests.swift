//
//  ImageUrlsTests.swift
//  TracktSearchAPITests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import TracktSearchAPI

class ImageUrlsTests: XCTestCase
{
    private static let jsonFullKey = "full"
    private static let jsonMediumKey = "medium"
    private static let jsonThumbKey = "thumb"

    func testMappingNormal()
    {
        let fullUrl = "https://example.com/full.jpg"
        let mediumUrl = "https://example.com/medium.jpg"
        let thumbUrl = "https://example.com/thumb.jpg"

        let dictionary = [
            self.dynamicType.jsonFullKey: fullUrl,
            self.dynamicType.jsonMediumKey: mediumUrl,
            self.dynamicType.jsonThumbKey: thumbUrl,
        ]

        let imageUrls = Mapper<ImageUrls>().map(dictionary)
        XCTAssertNotNil(imageUrls)

        XCTAssertEqual(imageUrls!.full!.absoluteString, fullUrl)
        XCTAssertEqual(imageUrls!.medium!.absoluteString, mediumUrl)
        XCTAssertEqual(imageUrls!.thumbnail!.absoluteString, thumbUrl)

        XCTAssertTrue(imageUrls!.isValid())
    }

    func testMappingEmpty()
    {
        let imageUrls = Mapper<ImageUrls>().map([:])
        XCTAssertNotNil(imageUrls)

        XCTAssertNil(imageUrls!.full)
        XCTAssertNil(imageUrls!.medium)
        XCTAssertNil(imageUrls!.thumbnail)

        XCTAssertFalse(imageUrls!.isValid())
    }

    func testMappingInvalidValues()
    {
        let dictionary = [
            self.dynamicType.jsonFullKey: 0,
            self.dynamicType.jsonMediumKey: 0,
            self.dynamicType.jsonThumbKey: 0,
        ]

        let imageUrls = Mapper<ImageUrls>().map(dictionary)
        XCTAssertNotNil(imageUrls)

        XCTAssertNil(imageUrls!.full)
        XCTAssertNil(imageUrls!.medium)
        XCTAssertNil(imageUrls!.thumbnail)

        XCTAssertFalse(imageUrls!.isValid())
    }

    func testIsValidTrue()
    {
        let fullUrl = "https://example.com/full.jpg"
        let mediumUrl = "https://example.com/medium.jpg"
        let thumbUrl = "https://example.com/thumb.jpg"

        let validDictionaries = [
            [
                self.dynamicType.jsonFullKey: fullUrl,
            ],
            [
                self.dynamicType.jsonMediumKey: mediumUrl,
            ],
            [
                self.dynamicType.jsonThumbKey: thumbUrl,
            ],
        ]

        for dictionary in validDictionaries {
            let imageUrls = Mapper<ImageUrls>().map(dictionary)
            XCTAssertNotNil(imageUrls)
            XCTAssertTrue(imageUrls!.isValid())
        }
    }

    // As far as this is exactly same as testMappingEmpty or testMappingInvalidValues there is no need in this test case
    // func testIsValidFalse()
}
