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
            SearchResultItemTests.jsonTitleKey: "Title",
            SearchResultItemTests.jsonOverviewKey: "Overview",
            SearchResultItemTests.jsonYearKey: 2016,
        ]

        let score = 123.456

        let dictionary = [
            SearchResultItemTests.jsonTypeKey: "movie",
            SearchResultItemTests.jsonScoreKey: score,
            SearchResultItemTests.jsonMovieKey: movieDictionary,
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
            SearchResultItemTests.jsonTypeKey: "invalid",
            SearchResultItemTests.jsonScoreKey: "invalid",
            SearchResultItemTests.jsonMovieKey: "invalid",
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
            SearchResultItemTests.jsonTitleKey: "Title",
            SearchResultItemTests.jsonOverviewKey: "Overview",
            SearchResultItemTests.jsonYearKey: 2016,
        ]

        let dictionary = [
            SearchResultItemTests.jsonTypeKey: "movie",
            SearchResultItemTests.jsonMovieKey: movieDictionary,
        ]

        let resultItem = Mapper<SearchResultItem>().map(dictionary)
        XCTAssertNotNil(resultItem)
        XCTAssertTrue(resultItem!.isValid())
    }

    func testIsValidFalse()
    {
        let movieDictionary = [
            SearchResultItemTests.jsonTitleKey: "Title",
            SearchResultItemTests.jsonOverviewKey: "Overview",
            SearchResultItemTests.jsonYearKey: 2016,
        ]

        let invalidDictionaries = [
            [
                SearchResultItemTests.jsonTypeKey: "invalid",
                SearchResultItemTests.jsonMovieKey: movieDictionary,
            ],
            [
                SearchResultItemTests.jsonTypeKey: "movie",
                SearchResultItemTests.jsonMovieKey: "invalid",
            ],
            [
                SearchResultItemTests.jsonMovieKey: movieDictionary,
            ],
            [
                SearchResultItemTests.jsonTypeKey: "movie",
            ],
        ]

        for dictionary in invalidDictionaries {
            let resultItem = Mapper<SearchResultItem>().map(dictionary)
            XCTAssertNotNil(resultItem)
            XCTAssertFalse(resultItem!.isValid())
        }
    }
}
