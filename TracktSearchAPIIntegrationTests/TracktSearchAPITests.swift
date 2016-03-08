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
    private static let fileResponseInvalidPopularMovies = "PopularMovies.invalid.json"
    private static let fileResponseInvalidSearchMovies = "SearchMovies.invalid.json"
    private static let fileHeadersNormal = "Headers.normal.json"
    private static let fileHeadersInvalid = "Headers.invalid.json"

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
        OHHTTPStubs.removeAllStubs()

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

    func invalidResponseHeaders() -> [String: String]
    {
        return self.JSONObjectWithFileName(self.dynamicType.fileHeadersInvalid) as? [String: String] ?? [:]
    }

    func stubRequestsWithResponses(responses: [String: (fileName: String, statusCode: Int32, headers: [String: String]?)])
    {
        stub({ request in
            return responses[request.URL?.path ?? ""] != nil
        }, response: { request in
            guard let response = responses[request.URL?.path ?? ""] else {
                return OHHTTPStubsResponse()
            }

            guard let fileUrl = self.URLForFileName(response.fileName) else {
                return OHHTTPStubsResponse()
            }

            return OHHTTPStubsResponse(fileURL: fileUrl, statusCode: response.statusCode, headers: response.headers)
        })
    }

    func stubRequestsWithNormalResponse()
    {
        self.stubRequestsWithResponses([
            self.dynamicType.popularMoviesUrlPath: (
                fileName: self.dynamicType.fileResponseNormalPopularMovies,
                statusCode: 200,
                headers: self.normalResponseHeaders()
            ),
            self.dynamicType.searchMoviesUrlPath: (
                fileName: self.dynamicType.fileResponseNormalSearchMovies,
                statusCode: 200,
                headers: self.normalResponseHeaders()
            ),
        ])
    }

    func stubRequestsWithEmptyResponse()
    {
        self.stubRequestsWithResponses([
            self.dynamicType.popularMoviesUrlPath: (
                fileName: "",
                statusCode: 200,
                headers: nil
            ),
            self.dynamicType.searchMoviesUrlPath: (
                fileName: "",
                statusCode: 200,
                headers: nil
            ),
        ])
    }

    func stubRequestsWithInvalidResponse()
    {
        self.stubRequestsWithResponses([
            self.dynamicType.popularMoviesUrlPath: (
                fileName: self.dynamicType.fileResponseInvalidPopularMovies,
                statusCode: 200,
                headers: self.normalResponseHeaders()
            ),
            self.dynamicType.searchMoviesUrlPath: (
                fileName: self.dynamicType.fileResponseInvalidSearchMovies,
                statusCode: 200,
                headers: self.normalResponseHeaders()
            ),
        ])
    }

    func stubRequestsWithInvalidHeadersResponse()
    {
        self.stubRequestsWithResponses([
            self.dynamicType.popularMoviesUrlPath: (
                fileName: self.dynamicType.fileResponseNormalPopularMovies,
                statusCode: 200,
                headers: self.invalidResponseHeaders()
            ),
            self.dynamicType.searchMoviesUrlPath: (
                fileName: self.dynamicType.fileResponseNormalSearchMovies,
                statusCode: 200,
                headers: self.invalidResponseHeaders()
            ),
        ])
    }

    func validateMoviesResponse(moviesResponse: MoviesResponse?, movies originalMovies: [Movie], paginationInfo originalPaginationInfo: PaginationInfo)
    {
        guard let response = moviesResponse else {
            XCTAssertTrue(false)
            return
        }

        switch response {
        case .Success(let movies, let paginationInfo):
            XCTAssertEqual(movies, originalMovies)
            XCTAssertEqual(paginationInfo, originalPaginationInfo)

        default: XCTAssertTrue(false)
        }
    }

    func validateErrorResponse(moviesResponse: MoviesResponse?)
    {
        guard let response = moviesResponse else {
            XCTAssertTrue(false)
            return
        }

        switch response {
        case .Error: XCTAssertTrue(true)
        default: XCTAssertTrue(false)
        }
    }

    func testLoadPopularMoviesNormal()
    {
        self.stubRequestsWithNormalResponse()

        var moviesResponse: MoviesResponse?
        let expectation = self.expectationWithDescription("Performing loadPopularMovies request to Search API")

        self.searchAPI!.loadPopularMovies(pageNumber:1, pageSize: 20) { response in
            moviesResponse = response
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5, handler: nil)

        guard let movies = Mapper<Movie>().mapArray(self.JSONObjectWithFileName(self.dynamicType.fileResponseNormalPopularMovies)) else {
            XCTAssertTrue(false)
            return
        }

        guard let paginationInfo = Mapper<PaginationInfo>().map(self.normalResponseHeaders()) else {
            XCTAssertTrue(false)
            return
        }

        self.validateMoviesResponse(moviesResponse, movies: movies, paginationInfo: paginationInfo)
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

        guard let searchItems = Mapper<SearchResultItem>().mapArray(self.JSONObjectWithFileName(self.dynamicType.fileResponseNormalSearchMovies)) else {
            XCTAssertTrue(false)
            return
        }

        guard let paginationInfo = Mapper<PaginationInfo>().map(self.normalResponseHeaders()) else {
            XCTAssertTrue(false)
            return
        }

        let movies = searchItems.map { $0.item as? Movie ?? Movie(JSON: [:])! }.filter { $0.isValid() }

        self.validateMoviesResponse(moviesResponse, movies: movies, paginationInfo: paginationInfo)
    }

    func testLoadPopularMoviesEmpty()
    {
        self.stubRequestsWithEmptyResponse()

        var moviesResponse: MoviesResponse?
        let expectation = self.expectationWithDescription("Performing loadPopularMovies request to Search API")

        self.searchAPI!.loadPopularMovies(pageNumber:1, pageSize: 20) { response in
            moviesResponse = response
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5, handler: nil)

        self.validateErrorResponse(moviesResponse)
    }

    func testSearchMoviesEmpty()
    {
        self.stubRequestsWithEmptyResponse()

        var moviesResponse: MoviesResponse?
        let expectation = self.expectationWithDescription("Performing searchMovies request to Search API")

        self.searchAPI!.searchMovies("batman", pageNumber:1, pageSize: 20) { response in
            moviesResponse = response
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5, handler: nil)

        self.validateErrorResponse(moviesResponse)
    }

    func testLoadPopularMoviesInvalid()
    {
        self.stubRequestsWithInvalidResponse()

        var moviesResponse: MoviesResponse?
        let expectation = self.expectationWithDescription("Performing loadPopularMovies request to Search API")

        self.searchAPI!.loadPopularMovies(pageNumber:1, pageSize: 20) { response in
            moviesResponse = response
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5, handler: nil)

        self.validateErrorResponse(moviesResponse)
    }

    func testSearchMoviesInvalid()
    {
        self.stubRequestsWithInvalidResponse()

        var moviesResponse: MoviesResponse?
        let expectation = self.expectationWithDescription("Performing searchMovies request to Search API")

        self.searchAPI!.searchMovies("batman", pageNumber:1, pageSize: 20) { response in
            moviesResponse = response
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5, handler: nil)

        self.validateErrorResponse(moviesResponse)
    }

    func testLoadPopularMoviesInvalidHeaders()
    {
        self.stubRequestsWithInvalidHeadersResponse()

        var moviesResponse: MoviesResponse?
        let expectation = self.expectationWithDescription("Performing loadPopularMovies request to Search API")

        self.searchAPI!.loadPopularMovies(pageNumber:1, pageSize: 20) { response in
            moviesResponse = response
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5, handler: nil)

        self.validateErrorResponse(moviesResponse)
    }

    func testSearchMoviesInvalidHeaders()
    {
        self.stubRequestsWithInvalidHeadersResponse()

        var moviesResponse: MoviesResponse?
        let expectation = self.expectationWithDescription("Performing searchMovies request to Search API")

        self.searchAPI!.searchMovies("batman", pageNumber:1, pageSize: 20) { response in
            moviesResponse = response
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5, handler: nil)

        self.validateErrorResponse(moviesResponse)
    }
}
