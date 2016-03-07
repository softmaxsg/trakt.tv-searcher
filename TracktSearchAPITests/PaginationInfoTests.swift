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
    private static let headerPageNumberKey = "x-pagination-page"
    private static let headerPageSizeKey = "x-pagination-limit"
    private static let headerItemsCountKey = "x-pagination-item-count"
    private static let headerPagesCountKey = "x-pagination-page-count"

    func testMappingNormal()
    {
        let pageNumber: UInt = 27
        let pageSize: UInt = 30
        let itemsCount: UInt = 123456
        let pagesCount: UInt = 4116

        let dictionary = [
            PaginationInfoTests.headerPageNumberKey: String(pageNumber),
            PaginationInfoTests.headerPageSizeKey: String(pageSize),
            PaginationInfoTests.headerItemsCountKey: String(itemsCount),
            PaginationInfoTests.headerPagesCountKey: String(pagesCount),
        ]

        let paginationInfo = Mapper<PaginationInfo>().map(dictionary)
        XCTAssertNotNil(paginationInfo)

        XCTAssertEqual(paginationInfo!.pageNumber!, pageNumber)
        XCTAssertEqual(paginationInfo!.pageSize!, pageSize)
        XCTAssertEqual(paginationInfo!.itemsCount!, itemsCount)
        XCTAssertEqual(paginationInfo!.pagesCount!, pagesCount)

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
            PaginationInfoTests.headerPageNumberKey: "invalid",
            PaginationInfoTests.headerPageSizeKey: "invalid",
            PaginationInfoTests.headerItemsCountKey: "invalid",
            PaginationInfoTests.headerPagesCountKey: "invalid",
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
            PaginationInfoTests.headerPageNumberKey: "1",
            PaginationInfoTests.headerPageSizeKey: "1",
        ]

        let paginationInfo = Mapper<PaginationInfo>().map(validDictionary)
        XCTAssertNotNil(paginationInfo)
        XCTAssertTrue(paginationInfo!.isValid())
    }

    func testIsValidFalse()
    {
        let invalidDictionaries = [
            [
                PaginationInfoTests.headerPageNumberKey: "0",
                PaginationInfoTests.headerPageSizeKey: "0",
            ],
            [
                PaginationInfoTests.headerPageNumberKey: "0",
                PaginationInfoTests.headerPageSizeKey: "1",
            ],
            [
                PaginationInfoTests.headerPageNumberKey: "1",
                PaginationInfoTests.headerPageSizeKey: "0",
            ],
            [
                PaginationInfoTests.headerPageSizeKey: "1",
            ],
            [
                PaginationInfoTests.headerPageNumberKey: "1",
            ],
        ]

        for dictionary in invalidDictionaries {
            let paginationInfo = Mapper<PaginationInfo>().map(dictionary)
            XCTAssertNotNil(paginationInfo)
            XCTAssertFalse(paginationInfo!.isValid())
        }
    }
}
