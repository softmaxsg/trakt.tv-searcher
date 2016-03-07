//
//  SearchResultItemTests.swift
//  TracktSearchAPITests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import TracktSearchAPI

class SearchResultItemTests: XCTestCase
{
    private static let jsonTypeKey = "type"
    private static let jsonScoreKey = "score"
    private static let jsonMovieKey = "movie"

    private static let jsonTitleKey = "title"
    private static let jsonOverviewKey = "overview"
    private static let jsonYearKey = "year"

    func testMappingNormal()
    {
        let movieDictionary = [
            self.dynamicType.jsonTitleKey: "Title",
            self.dynamicType.jsonOverviewKey: "Overview",
            self.dynamicType.jsonYearKey: 2016,
        ]

        let score = 123.456

        let dictionary = [
            self.dynamicType.jsonTypeKey: "movie",
            self.dynamicType.jsonScoreKey: score,
            self.dynamicType.jsonMovieKey: movieDictionary,
        ]

        let resultItem = Mapper<SearchResultItem>().map(dictionary)
        XCTAssertNotNil(resultItem)

        XCTAssertEqual(resultItem!.kind!, ItemKind.Movie)
        XCTAssertEqual(resultItem!.score!, score)

        XCTAssertNotNil(resultItem!.item as? Movie)
        XCTAssertTrue(resultItem!.item!.isValid())

        XCTAssertTrue(resultItem!.isValid())
    }

    func testMappingEmpty()
    {
        let resultItem = Mapper<SearchResultItem>().map([:])
        XCTAssertNotNil(resultItem)

        XCTAssertNil(resultItem!.kind)
        XCTAssertNil(resultItem!.score)
        XCTAssertNil(resultItem!.item)

        XCTAssertFalse(resultItem!.isValid())
    }

    func testMappingInvalidValues()
    {
        let dictionary = [
            self.dynamicType.jsonTypeKey: "invalid",
            self.dynamicType.jsonScoreKey: "invalid",
            self.dynamicType.jsonMovieKey: "invalid",
        ]

        let resultItem = Mapper<SearchResultItem>().map(dictionary)
        XCTAssertNotNil(resultItem)

        XCTAssertNil(resultItem!.kind)
        XCTAssertNil(resultItem!.score)
        XCTAssertNil(resultItem!.item)

        XCTAssertFalse(resultItem!.isValid())
    }

    func testIsValidTrue()
    {
        let movieDictionary = [
            self.dynamicType.jsonTitleKey: "Title",
            self.dynamicType.jsonOverviewKey: "Overview",
            self.dynamicType.jsonYearKey: 2016,
        ]

        let dictionary = [
            self.dynamicType.jsonTypeKey: "movie",
            self.dynamicType.jsonMovieKey: movieDictionary,
        ]

        let resultItem = Mapper<SearchResultItem>().map(dictionary)
        XCTAssertNotNil(resultItem)
        XCTAssertTrue(resultItem!.isValid())
    }

    func testIsValidFalse()
    {
        let movieDictionary = [
            self.dynamicType.jsonTitleKey: "Title",
            self.dynamicType.jsonOverviewKey: "Overview",
            self.dynamicType.jsonYearKey: 2016,
        ]

        let invalidDictionaries = [
            [
                self.dynamicType.jsonTypeKey: "invalid",
                self.dynamicType.jsonMovieKey: movieDictionary,
            ],
            [
                self.dynamicType.jsonTypeKey: "movie",
                self.dynamicType.jsonMovieKey: "invalid",
            ],
            [
                self.dynamicType.jsonMovieKey: movieDictionary,
            ],
            [
                self.dynamicType.jsonTypeKey: "movie",
            ],
        ]

        for dictionary in invalidDictionaries {
            let resultItem = Mapper<SearchResultItem>().map(dictionary)
            XCTAssertNotNil(resultItem)
            XCTAssertFalse(resultItem!.isValid())
        }
    }
}
