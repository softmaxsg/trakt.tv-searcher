//
//  SearchMoviesViewModelInput.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol SearchMoviesViewModelInput: MoviesViewModelInput
{
    func searchMovies(query: String)
}
