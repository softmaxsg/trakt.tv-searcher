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
    func testMappingNormal()
    {
        let resultItem = Mapper<SearchResultItem>().map(JSONHelpers.SearchResultItem.defaultValue)
        XCTAssertNotNil(resultItem)

        XCTAssertEqual(resultItem!.kind!, ItemKind.Movie)
        XCTAssertEqual(resultItem!.score!, JSONHelpers.SearchResultItem.DefaultValues.score)

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
            JSONHelpers.SearchResultItem.Keys.type: JSONHelpers.InvalidValues.string,
            JSONHelpers.SearchResultItem.Keys.score: JSONHelpers.InvalidValues.string,
            JSONHelpers.SearchResultItem.Keys.movie: JSONHelpers.InvalidValues.string,
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
        let dictionary = [
            JSONHelpers.SearchResultItem.Keys.type: JSONHelpers.SearchResultItem.DefaultValues.type,
            JSONHelpers.SearchResultItem.Keys.movie: JSONHelpers.Movie.defaultValue,
        ]

        let resultItem = Mapper<SearchResultItem>().map(dictionary)
        XCTAssertNotNil(resultItem)
        XCTAssertTrue(resultItem!.isValid())
    }

    func testIsValidFalse()
    {
        let invalidDictionaries = [
            [
                JSONHelpers.SearchResultItem.Keys.type: JSONHelpers.InvalidValues.string,
                JSONHelpers.SearchResultItem.Keys.movie: JSONHelpers.Movie.defaultValue,
            ],
            [
                JSONHelpers.SearchResultItem.Keys.type: JSONHelpers.SearchResultItem.DefaultValues.type,
                JSONHelpers.SearchResultItem.Keys.movie: JSONHelpers.InvalidValues.string,
            ],
            [
                JSONHelpers.SearchResultItem.Keys.movie: JSONHelpers.Movie.defaultValue,
            ],
            [
                JSONHelpers.SearchResultItem.Keys.type: JSONHelpers.SearchResultItem.DefaultValues.type,
            ],
        ]

        for dictionary in invalidDictionaries {
            let resultItem = Mapper<SearchResultItem>().map(dictionary)
            XCTAssertNotNil(resultItem)
            XCTAssertFalse(resultItem!.isValid())
        }
    }
}
