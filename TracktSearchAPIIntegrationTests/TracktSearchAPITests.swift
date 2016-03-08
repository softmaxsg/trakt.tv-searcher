//
//  TracktSearchAPITests.swift
//  TracktSearchAPIIntegrationTests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
import ObjectMapper
import OHHTTPStubs

@testable import TracktSearchAPI

class TracktSearchAPITests: XCTestCase
{
    private static let popularMoviesUrlPath = "/movies/popular"
    private static let searchMoviesUrlPath = "/search"

    private static let fileResponseNormalPopularMovies = "PopularMovies.normal.json"
    private static let fileResponseNormalSearchMovies = "SearchMovies.normal.json"
    private static let fileHeadersNormal = "Headers.normal.json"

    let applicationKey = NSUUID().UUIDString
    let queue: NSOperationQueue = NSOperationQueue()

    var searchAPI: TracktSearchAPI?

    override func setUp()
    {
        super.setUp()

        self.searchAPI = TracktSearchAPI(queue: self.queue, applicationKey: self.applicationKey)
    }

    override func tearDown()
    {
        self.searchAPI = nil

        super.tearDown()
    }

    func URLForFileName(fileName: String) -> NSURL?
    {
        return NSBundle(forClass: self.dynamicType).URLForResource(fileName, withExtension: nil)
    }

    func JSONObjectWithFileName(fileName: String) -> AnyObject?
    {
        guard let fileUrl = self.URLForFileName(fileName) else {
            return nil
        }

        guard let jsonData = NSData(contentsOfURL: fileUrl) else {
            return nil
        }

        return try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions())
    }

    func normalResponseHeaders() -> [String: String]
    {
        return self.JSONObjectWithFileName(self.dynamicType.fileHeadersNormal) as? [String: String] ?? [:]
    }

    func stubRequestsWithNormalResponse()
    {
        stub({ request in
            switch request.URL?.path ?? "" {
            case self.dynamicType.popularMoviesUrlPath,
                 self.dynamicType.searchMoviesUrlPath: return true
            default: return false
            }
        }, response: { request in
            let fileName: String

            switch request.URL?.path ?? "" {
            case self.dynamicType.popularMoviesUrlPath: fileName = self.dynamicType.fileResponseNormalPopularMovies
            case self.dynamicType.searchMoviesUrlPath: fileName = self.dynamicType.fileResponseNormalSearchMovies
            default: return OHHTTPStubsResponse()
            }

            guard let fileUrl = self.URLForFileName(fileName) else {
                return OHHTTPStubsResponse()
            }

            return OHHTTPStubsResponse(fileURL: fileUrl, statusCode: 200, headers: self.normalResponseHeaders())
        })
    }

    func validateMoviesResponse(response: MoviesResponse, movies originalMovies: [Movie], paginationInfo originalPaginationInfo: PaginationInfo)
    {
        switch response {
        case .Success(let movies, let paginationInfo):
            XCTAssertEqual(movies, originalMovies)
            XCTAssertEqual(paginationInfo, originalPaginationInfo)

        default: XCTAssertTrue(false)
        }
    }

    func testLoadPopularMoviesNormal()
    {
        self.stubRequestsWithNormalResponse()

        var moviesResponse: MoviesResponse?
        let expectation = self.expectationWithDescription("Performing loadMovies request to Search API")

        self.searchAPI!.loadPopularMovies(pageNumber:1, pageSize: 20) { response in
            moviesResponse = response
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5, handler: nil)

        guard let response = moviesResponse else {
            XCTAssertTrue(false)
            return
        }

        guard let movies = Mapper<Movie>().mapArray(self.JSONObjectWithFileName(self.dynamicType.fileResponseNormalPopularMovies)) else {
            XCTAssertTrue(false)
            return
        }

        guard let paginationInfo = Mapper<PaginationInfo>().map(self.normalResponseHeaders()) else {
            XCTAssertTrue(false)
            return
        }

        self.validateMoviesResponse(response, movies: movies, paginationInfo: paginationInfo)
    }

    func testSearchMoviesNormal()
    {
        self.stubRequestsWithNormalResponse()

        var moviesResponse: MoviesResponse?
        let expectation = self.expectationWithDescription("Performing searchMovies request to Search API")

        self.searchAPI!.searchMovies("batman", pageNumber:1, pageSize: 20) { response in
            moviesResponse = response
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5, handler: nil)

        guard let response = moviesResponse else {
            XCTAssertTrue(false)
            return
        }

        guard let searchItems = Mapper<SearchResultItem>().mapArray(self.JSONObjectWithFileName(self.dynamicType.fileResponseNormalSearchMovies)) else {
            XCTAssertTrue(false)
            return
        }

        guard let paginationInfo = Mapper<PaginationInfo>().map(self.normalResponseHeaders()) else {
            XCTAssertTrue(false)
            return
        }

        let movies = searchItems.map { $0.item as? Movie ?? Movie(JSON: [:])! }.filter { $0.isValid() }

        self.validateMoviesResponse(response, movies: movies, paginationInfo: paginationInfo)
    }
}
