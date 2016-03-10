//
//  PopularMoviesViewModelTests.swift
//  TraktSearcherTests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import TraktSearchAPI

class TrackSearchAPIMock: TraktSearchAPIProtocol
{
    class TraktSearchAPICancelableStub: TraktSearchAPICancelable
    {
        func cancel()
        {
        }
    }

    private let queue = NSOperationQueue()

    private let popularMoviesResponse: MoviesResponse?
    private let searchMoviesResponse: MoviesResponse?

    init(popularMoviesResponse: MoviesResponse?)
    {
        self.popularMoviesResponse = popularMoviesResponse
        self.searchMoviesResponse = nil
    }

    init(searchMoviesResponse: MoviesResponse?)
    {
        self.popularMoviesResponse = nil
        self.searchMoviesResponse = searchMoviesResponse
    }

    init(popularMoviesResponse: MoviesResponse?, searchMoviesResponse: MoviesResponse?)
    {
        self.popularMoviesResponse = popularMoviesResponse
        self.searchMoviesResponse = searchMoviesResponse
    }

    func loadPopularMovies(pageNumber pageNumber: UInt, pageSize: UInt, completionHandler: (MoviesResponse) -> ()) -> TraktSearchAPICancelable
    {
        if let popularMoviesResponse = self.popularMoviesResponse {
            queue.addOperationWithBlock {
                completionHandler(popularMoviesResponse)
            }
        }

        return TraktSearchAPICancelableStub()
    }

    func searchMovies(query: String, pageNumber: UInt, pageSize: UInt, completionHandler: (MoviesResponse) -> ()) -> TraktSearchAPICancelable
    {
        if let searchMoviesResponse = self.searchMoviesResponse {
            queue.addOperationWithBlock {
                completionHandler(searchMoviesResponse)
            }
        }

        return TraktSearchAPICancelableStub()
    }
}
