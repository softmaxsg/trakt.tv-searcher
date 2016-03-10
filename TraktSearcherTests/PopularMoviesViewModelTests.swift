//
//  PopularMoviesViewModelTests.swift
//  TraktSearcherTests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
import ObjectMapper
import TraktSearchAPI

@testable import TraktSearcher

class PopularMoviesViewModelTests: XCTestCase
{
    private static let fileResponseNormalPopularMovies = "PopularMovies.normal.json"
    private static let fileHeadersNormal = "Headers.normal.json"

    func normalResponseHeaders() -> [String: String]
    {
        return self.JSONObjectWithFileName(self.dynamicType.fileHeadersNormal) as? [String: String] ?? [:]
    }

    func testLoadPopularMovies()
    {
        guard let movies = Mapper<Movie>().mapArray(self.JSONObjectWithFileName(self.dynamicType.fileResponseNormalPopularMovies)) else {
            XCTAssertTrue(false)
            return
        }

        guard let paginationInfo = Mapper<PaginationInfo>().map(self.normalResponseHeaders()) else {
            XCTAssertTrue(false)
            return
        }

        let searchAPI = TrackSearchAPIMock(popularMoviesResponse: .Success(movies, paginationInfo))
        let viewModel = PopularMoviesViewModel(searchAPI: searchAPI)

        let expectation = self.expectationWithDescription("Performing loadPopularMovies request to Search API")

        let delegateMock = MoviesViewModelOutputMock(viewModelDidUpdateHandler: {
            expectation.fulfill()
        }, viewModelLoadingDidFailHandler: { error in
            XCTAssertTrue(false)
        })

        viewModel.delegate = delegateMock
        viewModel.loadPopularMovies()

        self.waitForExpectationsWithTimeout(5, handler: nil)

        let movieInfos = movies.map { MovieInfo(
            title: $0.title ?? "",
                overview: $0.overview,
                year: $0.year ?? 0,
                imageUrl: $0.images?[MovieImageKind.Poster]?.thumbnail
            )
        }

        XCTAssertEqual(viewModel.movies, movieInfos)
        XCTAssert(viewModel.moreDataAvailable == (paginationInfo.pageNumber < paginationInfo.pagesCount))
    }
}
