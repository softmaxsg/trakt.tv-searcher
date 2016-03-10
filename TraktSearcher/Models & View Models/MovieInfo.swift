//
//  MovieInfo.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct MovieInfo: MovieInfoViewModelData
{
    let title: String
    let overview: String?
    let year: UInt
    let imageUrl: NSURL?
}
