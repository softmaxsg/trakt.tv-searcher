//
//  TraktSearchAPIProtocol.swift
//  TraktSearchAPI
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation

public protocol TraktSearchAPIProtocol
{
    func loadPopularMovies(pageNumber pageNumber: UInt, pageSize: UInt, completionHandler: (MoviesResponse) -> ()) -> TraktSearchAPICancelable
    func searchMovies(query: String, pageNumber: UInt, pageSize: UInt, completionHandler: (MoviesResponse) -> ()) -> TraktSearchAPICancelable
}
