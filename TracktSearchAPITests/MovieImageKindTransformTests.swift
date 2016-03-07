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
    private static let jsonFullKey = "full"
    private static let jsonMediumKey = "medium"
    private static let jsonThumbKey = "thumb"

    func testToJSON()
    {
        let transformer = MovieImageKindTransform()

        // Just to make sure testing method will be updated after ading implementation for the method
        XCTAssertNil(transformer.transformToJSON([:]))
    }

    func testFromJSONNormal()
    {
        let imageUrls = [
            self.dynamicType.jsonFullKey: "https://example.com/full.jpg",
            self.dynamicType.jsonMediumKey: "https://example.com/medium.jpg",
            self.dynamicType.jsonThumbKey: "https://example.com/thumb.jpg",
        ]

        let dictionary = [
            MovieImageKind.FanArt.rawValue: imageUrls,
            MovieImageKind.Poster.rawValue: imageUrls,
            MovieImageKind.Logo.rawValue: imageUrls,
            MovieImageKind.ClearArt.rawValue: imageUrls,
            MovieImageKind.Banner.rawValue: imageUrls,
            MovieImageKind.Thumbnail.rawValue: imageUrls,
        ]


        let transformer = MovieImageKindTransform()
        let value = transformer.transformFromJSON(dictionary)
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
                "invalid": [
                    self.dynamicType.jsonFullKey: "https://example.com/full.jpg"
                ],
            ],
            [
                MovieImageKind.Poster.rawValue: Dictionary<String, AnyObject>(),
                MovieImageKind.Logo.rawValue: "invalid"
            ],
        ]

        for dictionary in invalidDictinoaries {
            XCTAssertNil(transformer.transformFromJSON(dictionary))
        }
    }
}
