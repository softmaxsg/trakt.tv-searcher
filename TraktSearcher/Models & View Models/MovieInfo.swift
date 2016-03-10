//
//  MovieInfo.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct MovieInfo: MovieInfoViewModelData, Equatable
{
    let title: String
    let overview: String?
    let year: UInt
    let imageUrl: NSURL?
}

// MARK: Equatable
func ==(lhs: MovieInfo, rhs: MovieInfo) -> Bool
{
    return lhs.title == rhs.title &&
        lhs.overview == rhs.overview &&
        lhs.year == rhs.year &&
        lhs.imageUrl == rhs.imageUrl
}
