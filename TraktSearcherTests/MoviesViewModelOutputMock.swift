//
//  PopularMoviesViewModelTests.swift
//  TraktSearcherTests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import TraktSearcher

class MoviesViewModelOutputMock: MoviesViewModelOutput
{
    private let viewModelDidUpdateHandler: (() -> ())?
    private let viewModelLoadingDidFailHandler: ((error: ErrorType) -> ())?

    init(viewModelDidUpdateHandler: () -> ())
    {
        self.viewModelDidUpdateHandler = viewModelDidUpdateHandler
        self.viewModelLoadingDidFailHandler = nil
    }

    init(viewModelLoadingDidFailHandler: (error: ErrorType) -> ())
    {
        self.viewModelDidUpdateHandler = nil
        self.viewModelLoadingDidFailHandler = viewModelLoadingDidFailHandler
    }

    init(viewModelDidUpdateHandler: () -> (), viewModelLoadingDidFailHandler: (error: ErrorType) -> ())
    {
        self.viewModelDidUpdateHandler = viewModelDidUpdateHandler
        self.viewModelLoadingDidFailHandler = viewModelLoadingDidFailHandler
    }

    func viewModelDidUpdate()
    {
        self.viewModelDidUpdateHandler?()
    }

    func viewModelLoadingDidFail(error: ErrorType)
    {
        self.viewModelLoadingDidFailHandler?(error: error)
    }
}
