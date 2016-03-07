//
//  MoviesResponse.swift
//  TraktSearchAPI
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation

public enum MoviesResponse
{
    case Error(ErrorType)
    case Success([Movie], PaginationInfo)
}
