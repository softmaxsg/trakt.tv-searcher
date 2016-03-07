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
            MovieTests.jsonFullKey: "https://example.com/full.jpg",
            MovieTests.jsonMediumKey: "https://example.com/medium.jpg",
            MovieTests.jsonThumbKey: "https://example.com/thumb.jpg",
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
            MovieTests.jsonTitleKey: movieTitle,
            MovieTests.jsonOverviewKey: movieOverview,
            MovieTests.jsonYearKey: movieYear,
            MovieTests.jsonImagesKey: movieImages,
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
            MovieTests.jsonTitleKey: 0,
            MovieTests.jsonOverviewKey: 0,
            MovieTests.jsonYearKey: "invalid",
            MovieTests.jsonImagesKey: "invalid",
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
            MovieTests.jsonTitleKey: "Title",
            MovieTests.jsonYearKey: 2016,
        ]

        let movie = Mapper<Movie>().map(dictionary)
        XCTAssertNotNil(movie)
        XCTAssertTrue(movie!.isValid())
    }

    func testIsValidFalse()
    {
        let invalidDictionaries = [
            [
                MovieTests.jsonTitleKey: 0,
                MovieTests.jsonYearKey: "invalid",
            ],
            [
                MovieTests.jsonTitleKey: "Title",
            ],
            [
                MovieTests.jsonYearKey: 2016,
            ],
            [
                MovieTests.jsonTitleKey: 0,
                MovieTests.jsonYearKey: 2016,
            ],
            [
                MovieTests.jsonTitleKey: "Title",
                MovieTests.jsonYearKey: "invalid",
            ],
            [
                MovieTests.jsonTitleKey: "Title",
                MovieTests.jsonYearKey: 0,
            ],
        ]

        for dictionary in invalidDictionaries {
            let movie = Mapper<Movie>().map(dictionary)
            XCTAssertNotNil(movie)
            XCTAssertFalse(movie!.isValid())
        }
    }
}
