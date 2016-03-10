//
//  MoviesAssembly.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import UIKit
import TraktSearchAPI

class MoviesAssembly
{
    private static let traktApplicationKey = "ad005b8c117cdeee58a1bdb7089ea31386cd489b21e14b19818c91511f12a086"

    func createMoviesViewController() -> MainViewController
    {
        let searchAPI = TraktSearchAPI(queue: NSOperationQueue(), applicationKey: self.dynamicType.traktApplicationKey)

        let popularMoviesViewModel = PopularMoviesViewModel(searchAPI: searchAPI)
        let searchMoviesViewModel = SearchMoviesViewModel(searchAPI: searchAPI)

        let mainController = MainViewController(popularMoviesViewModel: popularMoviesViewModel, searchMoviesViewModel: searchMoviesViewModel)
        mainController.popularMoviesDelegate = popularMoviesViewModel
        mainController.searchMoviesDelegate = searchMoviesViewModel

        popularMoviesViewModel.delegate = mainController
        searchMoviesViewModel.delegate = mainController

        return mainController
    }
}
