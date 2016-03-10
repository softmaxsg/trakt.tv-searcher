//
//  MovieInfoViewModelData.swift
//  TraktSearcher
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol MovieInfoViewModelData
{
    var title: String { get }
    var overview: String? { get }
    var year: UInt { get }
    var imageUrl: NSURL? { get }
}
