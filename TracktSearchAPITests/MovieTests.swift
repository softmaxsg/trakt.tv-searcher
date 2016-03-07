//
//  MovieTests.swift
//  TracktSearchAPITests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import TracktSearchAPI

class MovieTests: XCTestCase
{
    private static let jsonTitleKey = "title"
    private static let jsonOverviewKey = "overview"
    private static let jsonYearKey = "year"
    private static let jsonImagesKey = "images"

    private static let jsonFullKey = "full"
    private static let jsonMediumKey = "medium"
    private static let jsonThumbKey = "thumb"

    func testMappingNormal()
    {
        let movieTitle = "Title"
        let movieOverview = "Overview"
        let movieYear: UInt = 2016

        let imageUrls = [
            self.dynamicType.jsonFullKey: "https://example.com/full.jpg",
            self.dynamicType.jsonMediumKey: "https://example.com/medium.jpg",
            self.dynamicType.jsonThumbKey: "https://example.com/thumb.jpg",
        ]

        let movieImages = [
            MovieImageKind.FanArt.rawValue: imageUrls,
            MovieImageKind.Poster.rawValue: imageUrls,
            MovieImageKind.Logo.rawValue: imageUrls,
            MovieImageKind.ClearArt.rawValue: imageUrls,
            MovieImageKind.Banner.rawValue: imageUrls,
            MovieImageKind.Thumbnail.rawValue: imageUrls,
        ]

        let dictionary = [
            self.dynamicType.jsonTitleKey: movieTitle,
            self.dynamicType.jsonOverviewKey: movieOverview,
            self.dynamicType.jsonYearKey: movieYear,
            self.dynamicType.jsonImagesKey: movieImages,
        ]

        let movie = Mapper<Movie>().map(dictionary)
        XCTAssertNotNil(movie)

        XCTAssertEqual(movie!.title!, movieTitle)
        XCTAssertEqual(movie!.overview!, movieOverview)
        XCTAssertEqual(movie!.year!, movieYear)

        XCTAssertNotNil(movie!.images![MovieImageKind.FanArt])
        XCTAssertNotNil(movie!.images![MovieImageKind.Poster])
        XCTAssertNotNil(movie!.images![MovieImageKind.Logo])
        XCTAssertNotNil(movie!.images![MovieImageKind.ClearArt])
        XCTAssertNotNil(movie!.images![MovieImageKind.Banner])
        XCTAssertNotNil(movie!.images![MovieImageKind.Thumbnail])

        XCTAssertTrue(movie!.isValid())
    }

    func testMappingEmpty()
    {
        let movie = Mapper<Movie>().map([:])
        XCTAssertNotNil(movie)

        XCTAssertNil(movie!.title)
        XCTAssertNil(movie!.overview)
        XCTAssertNil(movie!.year)
        XCTAssertNil(movie!.images)

        XCTAssertFalse(movie!.isValid())
    }

    func testMappingInvalidValues()
    {
        let dictionary = [
            self.dynamicType.jsonTitleKey: 0,
            self.dynamicType.jsonOverviewKey: 0,
            self.dynamicType.jsonYearKey: "invalid",
            self.dynamicType.jsonImagesKey: "invalid",
        ]

        let movie = Mapper<Movie>().map(dictionary)
        XCTAssertNotNil(movie)

        XCTAssertNil(movie!.title)
        XCTAssertNil(movie!.overview)
        XCTAssertNil(movie!.year)
        XCTAssertNil(movie!.images)

        XCTAssertFalse(movie!.isValid())
    }

    func testIsValidTrue()
    {
        let dictionary = [
            self.dynamicType.jsonTitleKey: "Title",
            self.dynamicType.jsonYearKey: 2016,
        ]

        let movie = Mapper<Movie>().map(dictionary)
        XCTAssertNotNil(movie)
        XCTAssertTrue(movie!.isValid())
    }

    func testIsValidFalse()
    {
        let invalidDictionaries = [
            [
                self.dynamicType.jsonTitleKey: 0,
                self.dynamicType.jsonYearKey: "invalid",
            ],
            [
                self.dynamicType.jsonTitleKey: "Title",
            ],
            [
                self.dynamicType.jsonYearKey: 2016,
            ],
            [
                self.dynamicType.jsonTitleKey: 0,
                self.dynamicType.jsonYearKey: 2016,
            ],
            [
                self.dynamicType.jsonTitleKey: "Title",
                self.dynamicType.jsonYearKey: "invalid",
            ],
            [
                self.dynamicType.jsonTitleKey: "Title",
                self.dynamicType.jsonYearKey: 0,
            ],
        ]

        for dictionary in invalidDictionaries {
            let movie = Mapper<Movie>().map(dictionary)
            XCTAssertNotNil(movie)
            XCTAssertFalse(movie!.isValid())
        }
    }
}
