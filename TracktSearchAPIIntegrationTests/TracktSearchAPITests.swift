//
//  TracktSearchAPITests.swift
//  TracktSearchAPIIntegrationTests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest
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

    func normalResponseHeaders() -> [String: String]
    {
        guard let fileUrl = NSBundle(forClass: self.dynamicType).URLForResource(self.dynamicType.fileHeadersNormal, withExtension: nil) else {
            return [:]
        }

        guard let jsonData = NSData(contentsOfURL: fileUrl) else {
            return [:]
        }

        guard let headers = (try? Foundation.NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions())) as? [String: String] else {
            return [:]
        }

        return headers
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

            guard let fileUrl = NSBundle(forClass: self.dynamicType).URLForResource(fileName, withExtension: nil) else {
                return OHHTTPStubsResponse()
            }

            return OHHTTPStubsResponse(fileURL: fileUrl, statusCode: 200, headers: self.normalResponseHeaders())
        })
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

        //
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

        //
    }
}
