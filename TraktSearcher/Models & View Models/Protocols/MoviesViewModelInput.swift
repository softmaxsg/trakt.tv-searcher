//
//  MoviesViewModelInput.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation

let MoviesViewModelInputErrorDomain = "MoviesViewModelInputError"

let MoviesViewModelInputNoMoreDataAvailableErrorCode = 1
let MoviesViewModelInputInvalidSearchQueryErrorCode = 2

protocol MoviesViewModelInput: class
{
    var moreDataAvailable: Bool { get }
    var loading: Bool { get }

    func loadInitialData()
    func loadMoreData()
}

