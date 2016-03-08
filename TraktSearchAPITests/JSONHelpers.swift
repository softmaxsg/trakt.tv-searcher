//
//  JSONHelpers.swift
//  TraktSearchAPITests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import TraktSearchAPI

struct JSONHelpers
{
    struct InvalidValues
    {
        static let string = "invalid"
        static let integer = 0
    }

    struct ImageUrls
    {
        struct Keys
        {
            static let full = "full"
            static let medium = "medium"
            static let thumbnail = "thumb"
        }

        struct DefaultValues
        {
            static let full = "https://example.com/full.jpg"
            static let medium = "https://example.com/medium.jpg"
            static let thumbnail = "https://example.com/thumb.jpg"
        }

        static let defaultValue = [
            Keys.full: DefaultValues.full,
            Keys.medium: DefaultValues.medium,
            Keys.thumbnail: DefaultValues.thumbnail,
        ]
    }

    struct MovieImageKinds
    {
        static let defaultValue = [
            MovieImageKind.FanArt.rawValue: ImageUrls.defaultValue,
            MovieImageKind.Poster.rawValue: ImageUrls.defaultValue,
            MovieImageKind.Logo.rawValue: ImageUrls.defaultValue,
            MovieImageKind.ClearArt.rawValue: ImageUrls.defaultValue,
            MovieImageKind.Banner.rawValue: ImageUrls.defaultValue,
            MovieImageKind.Thumbnail.rawValue: ImageUrls.defaultValue,
        ]
    }

    struct Movie
    {
        struct Keys
        {
            static let title = "title"
            static let overview = "overview"
            static let year = "year"
            static let images = "images"
        }

        struct DefaultValues
        {
            static let title = "Title"
            static let overview = "Overview"
            static let year: UInt = 2016
        }

        static let defaultValue = [
            Keys.title: DefaultValues.title,
            Keys.overview: DefaultValues.overview,
            Keys.year: DefaultValues.year,
            Keys.images: MovieImageKinds.defaultValue,
        ]
    }

    struct SearchResultItem
    {
        struct Keys
        {
            static let type = "type"
            static let score = "score"
            static let movie = "movie"
        }

        struct DefaultValues
        {
            static let type = "movie"
            static let score = 123.456
        }

        static let defaultValue = [
            Keys.type: DefaultValues.type,
            Keys.score: DefaultValues.score,
            Keys.movie: Movie.defaultValue,
        ]
    }

    struct PaginationInfo
    {
        struct Keys
        {
            static let pageNumber = "x-pagination-page"
            static let pageSize = "x-pagination-limit"
            static let itemsCount = "x-pagination-item-count"
            static let pagesCount = "x-pagination-page-count"
        }

        struct DefaultValues
        {
            static let pageNumber: UInt = 27
            static let pageSize: UInt = 30
            static let itemsCount: UInt = 123456
            static let pagesCount: UInt = 4116
        }

        static let defaultValue = [
            Keys.pageNumber: String(DefaultValues.pageNumber),
            Keys.pageSize: String(DefaultValues.pageSize),
            Keys.itemsCount: String(DefaultValues.itemsCount),
            Keys.pagesCount: String(DefaultValues.pagesCount),
        ]
    }
}
