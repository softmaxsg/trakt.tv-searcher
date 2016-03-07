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
            self.dynamicType.headerPageNumberKey: String(pageNumber),
            self.dynamicType.headerPageSizeKey: String(pageSize),
            self.dynamicType.headerItemsCountKey: String(itemsCount),
            self.dynamicType.headerPagesCountKey: String(pagesCount),
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
            self.dynamicType.headerPageNumberKey: "invalid",
            self.dynamicType.headerPageSizeKey: "invalid",
            self.dynamicType.headerItemsCountKey: "invalid",
            self.dynamicType.headerPagesCountKey: "invalid",
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
            self.dynamicType.headerPageNumberKey: "1",
            self.dynamicType.headerPageSizeKey: "1",
        ]

        let paginationInfo = Mapper<PaginationInfo>().map(validDictionary)
        XCTAssertNotNil(paginationInfo)
        XCTAssertTrue(paginationInfo!.isValid())
    }

    func testIsValidFalse()
    {
        let invalidDictionaries = [
            [
                self.dynamicType.headerPageNumberKey: "0",
                self.dynamicType.headerPageSizeKey: "0",
            ],
            [
                self.dynamicType.headerPageNumberKey: "0",
                self.dynamicType.headerPageSizeKey: "1",
            ],
            [
                self.dynamicType.headerPageNumberKey: "1",
                self.dynamicType.headerPageSizeKey: "0",
            ],
            [
                self.dynamicType.headerPageSizeKey: "1",
            ],
            [
                self.dynamicType.headerPageNumberKey: "1",
            ],
        ]

        for dictionary in invalidDictionaries {
            let paginationInfo = Mapper<PaginationInfo>().map(dictionary)
            XCTAssertNotNil(paginationInfo)
            XCTAssertFalse(paginationInfo!.isValid())
        }
    }
}
