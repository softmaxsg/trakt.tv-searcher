//
//  MovieTests.swift
//  TraktSearchAPITests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import TraktSearchAPI

class MovieTests: XCTestCase
{
    func testMappingNormal()
    {
        let movie = Mapper<Movie>().map(JSONHelpers.Movie.defaultValue)
        XCTAssertNotNil(movie)

        XCTAssertEqual(movie!.title!, JSONHelpers.Movie.DefaultValues.title)
        XCTAssertEqual(movie!.overview!, JSONHelpers.Movie.DefaultValues.overview)
        XCTAssertEqual(movie!.year!, JSONHelpers.Movie.DefaultValues.year)

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
            JSONHelpers.Movie.Keys.title: JSONHelpers.InvalidValues.integer,
            JSONHelpers.Movie.Keys.overview: JSONHelpers.InvalidValues.integer,
            JSONHelpers.Movie.Keys.year: JSONHelpers.InvalidValues.string,
            JSONHelpers.Movie.Keys.images: JSONHelpers.InvalidValues.string,
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
            JSONHelpers.Movie.Keys.title: JSONHelpers.Movie.DefaultValues.title,
            JSONHelpers.Movie.Keys.year: JSONHelpers.Movie.DefaultValues.year,
        ]

        let movie = Mapper<Movie>().map(dictionary)
        XCTAssertNotNil(movie)
        XCTAssertTrue(movie!.isValid())
    }

    func testIsValidFalse()
    {
        let invalidDictionaries = [
            [
                JSONHelpers.Movie.Keys.title: JSONHelpers.InvalidValues.integer,
                JSONHelpers.Movie.Keys.year: JSONHelpers.InvalidValues.string,
            ],
            [
                JSONHelpers.Movie.Keys.title: JSONHelpers.Movie.DefaultValues.title,
            ],
            [
                JSONHelpers.Movie.Keys.year: JSONHelpers.Movie.DefaultValues.year,
            ],
            [
                JSONHelpers.Movie.Keys.title: JSONHelpers.InvalidValues.integer,
                JSONHelpers.Movie.Keys.year: JSONHelpers.Movie.DefaultValues.year,
            ],
            [
                JSONHelpers.Movie.Keys.title: JSONHelpers.Movie.DefaultValues.title,
                JSONHelpers.Movie.Keys.year: JSONHelpers.InvalidValues.string,
            ],
            [
                JSONHelpers.Movie.Keys.title: JSONHelpers.Movie.DefaultValues.title,
                JSONHelpers.Movie.Keys.year: JSONHelpers.InvalidValues.integer,
            ],
        ]

        for dictionary in invalidDictionaries {
            let movie = Mapper<Movie>().map(dictionary)
            XCTAssertNotNil(movie)
            XCTAssertFalse(movie!.isValid())
        }
    }

    func testEqual()
    {
        XCTAssertEqual(Mapper<Movie>().map(JSONHelpers.Movie.defaultValue), Mapper<Movie>().map(JSONHelpers.Movie.defaultValue))
        XCTAssertNotEqual(Mapper<Movie>().map(JSONHelpers.Movie.defaultValue), Mapper<Movie>().map([:]))
    }
}
