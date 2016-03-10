//
//  MoviesViewModelOutput.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol MoviesViewModelOutput: class
{
    func viewModelDidUpdate()
    func viewModelLoadingDidFail(error: ErrorType)
}
