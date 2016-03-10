//
//  MoviesViewModel.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import TraktSearchAPI

class MoviesViewModel: MoviesViewModelData, MoviesViewModelInput
{
    static let pageSize: UInt = 10
    let searchAPI: TraktSearchAPIProtocol

    var lastPaginationInfo: PaginationInfo?
    var lastCancelableToken: TraktSearchAPICancelable?

    weak var delegate: MoviesViewModelOutput?

    private (set) var loading: Bool = false
    private (set) var movies: [MovieInfo] = []

    var moreDataAvailable: Bool
    {
        get {
            guard let pageNumber = self.lastPaginationInfo?.pageNumber, let pagesCount = self.lastPaginationInfo?.pagesCount else {
                return false
            }

            return pageNumber < pagesCount
        }
    }

    init(searchAPI: TraktSearchAPIProtocol)
    {
        self.searchAPI = searchAPI
    }

    func loadInitialData()
    {
        self.loadMovies(pageNumber: 1)
    }

    func loadMoreData()
    {
        if !self.moreDataAvailable {
            // To keep behavior of this function always same delegate's method calling is called after end of this function
            NSOperationQueue.mainQueue().addOperationWithBlock {
                let error = NSError(domain: MoviesViewModelInputErrorDomain, code: MoviesViewModelInputNoMoreDataAvailableErrorCode, userInfo: nil)
                self.delegate?.viewModelLoadingDidFail(error)
            }

            return
        }

        self.loadMovies(pageNumber: (self.lastPaginationInfo?.pageNumber ?? 0) + 1)
    }

    func clearData()
    {
        self.lastPaginationInfo = nil
        self.movies = []
    }

    func loadMovies(pageNumber pageNumber: UInt, responseValidationHandler: ((MoviesResponse) -> Bool)? = nil)
    {
        assert(pageNumber > 0)

        // It's preferable to call this method on the main thread
        assert(NSOperationQueue.currentQueue() == NSOperationQueue.mainQueue())

        if pageNumber == 1 {
            self.clearData()
        }

        self.lastCancelableToken?.cancel()

        self.loading = true

        self.lastCancelableToken = self.performAPIRequest(pageNumber: pageNumber, pageSize: self.dynamicType.pageSize) { [weak self] response in

            if !(responseValidationHandler?(response) ?? true) {
                return
            }

            switch response {
            case .Success(let movies, let paginationInfo):
                let loadedMovies = movies.map { MovieInfo(
                title: $0.title ?? "",
                    overview: $0.overview,
                    year: $0.year ?? 0,
                    imageUrl: $0.images?[MovieImageKind.Poster]?.thumbnail
                )}

                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self?.lastPaginationInfo = paginationInfo
                    self?.movies = (self?.movies ?? []) + loadedMovies
                    self?.loading = false
                    self?.delegate?.viewModelDidUpdate()
                }

            case .Error(let error):
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self?.loading = false
                    self?.delegate?.viewModelLoadingDidFail(error)
                }
            }
        }
    }

    func performAPIRequest(pageNumber pageNumber: UInt, pageSize: UInt, completionHandler: (MoviesResponse) -> ()) -> TraktSearchAPICancelable?
    {
        assert(false, "Has to be overriden")
        return nil
    }
}
