//
//  PaginationInfoTests.swift
//  TracktSearchAPITests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import TracktSearchAPI

class PaginationInfoTests: XCTestCase
{
    func testMappingNormal()
    {
        let paginationInfo = Mapper<PaginationInfo>().map(JSONHelpers.PaginationInfo.defaultValue)
        XCTAssertNotNil(paginationInfo)

        XCTAssertEqual(paginationInfo!.pageNumber!, JSONHelpers.PaginationInfo.DefaultValues.pageNumber)
        XCTAssertEqual(paginationInfo!.pageSize!, JSONHelpers.PaginationInfo.DefaultValues.pageSize)
        XCTAssertEqual(paginationInfo!.itemsCount!, JSONHelpers.PaginationInfo.DefaultValues.itemsCount)
        XCTAssertEqual(paginationInfo!.pagesCount!, JSONHelpers.PaginationInfo.DefaultValues.pagesCount)

        XCTAssertTrue(paginationInfo!.isValid())
    }

    func testMappingEmpty()
    {
        let paginationInfo = Mapper<PaginationInfo>().map([:])
        XCTAssertNotNil(paginationInfo)

        XCTAssertNil(paginationInfo!.pageNumber)
        XCTAssertNil(paginationInfo!.pageSize)
        XCTAssertNil(paginationInfo!.itemsCount)
        XCTAssertNil(paginationInfo!.pagesCount)

        XCTAssertFalse(paginationInfo!.isValid())
    }

    func testMappingInvalidValues()
    {
        let dictionary = [
            JSONHelpers.PaginationInfo.Keys.pageNumber: JSONHelpers.InvalidValues.string,
            JSONHelpers.PaginationInfo.Keys.pageSize: JSONHelpers.InvalidValues.string,
            JSONHelpers.PaginationInfo.Keys.itemsCount: JSONHelpers.InvalidValues.string,
            JSONHelpers.PaginationInfo.Keys.pagesCount: JSONHelpers.InvalidValues.string,
        ]

        let paginationInfo = Mapper<PaginationInfo>().map(dictionary)
        XCTAssertNotNil(paginationInfo)

        XCTAssertNil(paginationInfo!.pageNumber)
        XCTAssertNil(paginationInfo!.pageSize)
        XCTAssertNil(paginationInfo!.itemsCount)
        XCTAssertNil(paginationInfo!.pagesCount)

        XCTAssertFalse(paginationInfo!.isValid())
    }

    func testIsValidTrue()
    {
        let validDictionary = [
            JSONHelpers.PaginationInfo.Keys.pageNumber: String(JSONHelpers.PaginationInfo.DefaultValues.pageNumber),
            JSONHelpers.PaginationInfo.Keys.pageSize: String(JSONHelpers.PaginationInfo.DefaultValues.pageSize),
        ]

        let paginationInfo = Mapper<PaginationInfo>().map(validDictionary)
        XCTAssertNotNil(paginationInfo)
        XCTAssertTrue(paginationInfo!.isValid())
    }

    func testIsValidFalse()
    {
        let invalidDictionaries = [
            [
                JSONHelpers.PaginationInfo.Keys.pageNumber: String(JSONHelpers.InvalidValues.integer),
                JSONHelpers.PaginationInfo.Keys.pageSize: String(JSONHelpers.PaginationInfo.DefaultValues.pageSize),
            ],
            [
                JSONHelpers.PaginationInfo.Keys.pageNumber: String(JSONHelpers.PaginationInfo.DefaultValues.pageNumber),
                JSONHelpers.PaginationInfo.Keys.pageSize: String(JSONHelpers.InvalidValues.integer),
            ],
            [
                JSONHelpers.PaginationInfo.Keys.pageSize: String(JSONHelpers.InvalidValues.integer),
            ],
            [
                JSONHelpers.PaginationInfo.Keys.pageNumber: String(JSONHelpers.InvalidValues.integer),
            ],
        ]

        for dictionary in invalidDictionaries {
            let paginationInfo = Mapper<PaginationInfo>().map(dictionary)
            XCTAssertNotNil(paginationInfo)
            XCTAssertFalse(paginationInfo!.isValid())
        }
    }

    func testEqual()
    {
        XCTAssertEqual(Mapper<PaginationInfo>().map(JSONHelpers.PaginationInfo.defaultValue), Mapper<PaginationInfo>().map(JSONHelpers.PaginationInfo.defaultValue))
        XCTAssertNotEqual(Mapper<PaginationInfo>().map(JSONHelpers.PaginationInfo.defaultValue), Mapper<PaginationInfo>().map([:]))
    }
}
