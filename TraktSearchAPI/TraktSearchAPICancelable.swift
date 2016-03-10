//
//  TraktSearchAPICancelable.swift
//  TraktSearchAPI
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import Alamofire

public protocol TraktSearchAPICancelable
{
    func cancel()
}

extension Alamofire.Request: TraktSearchAPICancelable
{

}