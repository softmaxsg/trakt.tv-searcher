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
    func testMappingNormal()
    {
        let imageUrls = Mapper<ImageUrls>().map(JSONHelpers.ImageUrls.defaultValue)
        XCTAssertNotNil(imageUrls)

        XCTAssertEqual(imageUrls!.full!.absoluteString, JSONHelpers.ImageUrls.DefaultValues.full)
        XCTAssertEqual(imageUrls!.medium!.absoluteString, JSONHelpers.ImageUrls.DefaultValues.medium)
        XCTAssertEqual(imageUrls!.thumbnail!.absoluteString, JSONHelpers.ImageUrls.DefaultValues.thumbnail)

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
            JSONHelpers.ImageUrls.Keys.full: JSONHelpers.InvalidValues.integer,
            JSONHelpers.ImageUrls.Keys.medium: JSONHelpers.InvalidValues.integer,
            JSONHelpers.ImageUrls.Keys.thumbnail: JSONHelpers.InvalidValues.integer,
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
        let validDictionaries = [
            [
                JSONHelpers.ImageUrls.Keys.full: JSONHelpers.ImageUrls.DefaultValues.full,
            ],
            [
                JSONHelpers.ImageUrls.Keys.medium: JSONHelpers.ImageUrls.DefaultValues.medium,
            ],
            [
                JSONHelpers.ImageUrls.Keys.thumbnail: JSONHelpers.ImageUrls.DefaultValues.thumbnail,
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
