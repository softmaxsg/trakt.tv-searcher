//
//  PopularMoviesViewModel.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import TraktSearchAPI

class PopularMoviesViewModel: MoviesViewModel, PopularMoviesViewModelInput
{
    func loadPopularMovies()
    {
        self.loadInitialData()
    }

    override func performAPIRequest(pageNumber pageNumber: UInt, pageSize: UInt, completionHandler: (MoviesResponse) -> ()) -> TraktSearchAPICancelable?
    {
        return self.searchAPI.loadPopularMovies(pageNumber: pageNumber, pageSize: pageSize, completionHandler: completionHandler)
    }
}
