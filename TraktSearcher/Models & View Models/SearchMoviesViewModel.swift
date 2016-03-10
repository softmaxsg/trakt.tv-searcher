//
//  SearchMoviesViewModel.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import TraktSearchAPI

class SearchMoviesViewModel: MoviesViewModel, SearchMoviesViewModelInput
{
    private var lastSearchQuery: String?

    override var moreDataAvailable: Bool
    {
        get {
            if self.lastSearchQuery?.isEmpty ?? true {
                return false
            }

            return super.moreDataAvailable
        }
    }

    func searchMovies(query: String)
    {
        self.lastSearchQuery = query
        self.loadInitialData()
    }

    override func loadMovies(pageNumber pageNumber: UInt, responseValidationHandler: ((MoviesResponse) -> Bool)? = nil)
    {
        self.lastCancelableToken?.cancel()

        guard let query = self.lastSearchQuery where !query.isEmpty else {
            // To keep behavior of this function always same delegate's method calling is called after end of this function
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.clearData()

                let error = NSError(domain: MoviesViewModelInputErrorDomain, code: MoviesViewModelInputInvalidSearchQueryErrorCode, userInfo: nil)
                self.delegate?.viewModelLoadingDidFail(error)
            }

            return
        }

        super.loadMovies(pageNumber: pageNumber, responseValidationHandler: { [weak self] response in
            guard let currentQuery = self?.lastSearchQuery where currentQuery == query else {
                // Another search was already started, so, these results are irrelevant
                return false
            }

            return true
        })
    }

    override func performAPIRequest(pageNumber pageNumber: UInt, pageSize: UInt, completionHandler: (MoviesResponse) -> ()) -> TraktSearchAPICancelable?
    {
        return self.searchAPI.searchMovies(self.lastSearchQuery ?? "", pageNumber: pageNumber, pageSize: pageSize, completionHandler: completionHandler)
    }
}
