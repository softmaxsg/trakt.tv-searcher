//
//  MovieImageKindTransformTests.swift
//  TracktSearchAPITests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import TracktSearchAPI

class MovieImageKindTransformTests: XCTestCase
{
    func testToJSON()
    {
        let transformer = MovieImageKindTransform()

        // Just to make sure testing method will be updated after ading implementation for the method
        XCTAssertNil(transformer.transformToJSON([:]))
    }

    func testFromJSONNormal()
    {
        let transformer = MovieImageKindTransform()
        let value = transformer.transformFromJSON(JSONHelpers.MovieImageKinds.defaultValue)
        XCTAssertNotNil(value)

        XCTAssertNotNil(value![MovieImageKind.FanArt])
        XCTAssertNotNil(value![MovieImageKind.Poster])
        XCTAssertNotNil(value![MovieImageKind.Logo])
        XCTAssertNotNil(value![MovieImageKind.ClearArt])
        XCTAssertNotNil(value![MovieImageKind.Banner])
        XCTAssertNotNil(value![MovieImageKind.Thumbnail])
    }

    func testFromJSONEmpty()
    {
        let transformer = MovieImageKindTransform()
        XCTAssertNil(transformer.transformFromJSON([:]))
    }

    func testFromJSONInvalidValues()
    {
        let transformer = MovieImageKindTransform()

        XCTAssertNil(transformer.transformFromJSON(nil))

        let invalidDictinoaries = [
            [
                JSONHelpers.InvalidValues.string: [
                    JSONHelpers.ImageUrls.Keys.full: JSONHelpers.ImageUrls.DefaultValues.full
                ],
            ],
            [
                MovieImageKind.Poster.rawValue: Dictionary<String, AnyObject>(),
                MovieImageKind.Logo.rawValue: JSONHelpers.InvalidValues.string
            ],
        ]

        for dictionary in invalidDictinoaries {
            XCTAssertNil(transformer.transformFromJSON(dictionary))
        }
    }
}
