//
//  PopularMoviesViewModelInput.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol PopularMoviesViewModelInput: MoviesViewModelInput
{
    func loadPopularMovies()
}
