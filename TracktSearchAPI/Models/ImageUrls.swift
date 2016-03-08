//
//  ImageUrls.swift
//  TraktSearchAPI
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ImageUrls: Mappable, Validable, Equatable
{
    private static let jsonFullKey = "full"
    private static let jsonMediumKey = "medium"
    private static let jsonThumbKey = "thumb"

    public private(set) var full: NSURL?
    public private(set) var medium: NSURL?
    public private(set) var thumbnail: NSURL?

    public init?(_ map: Map)
    {
    }

    // MARK: Mappable
    mutating public func mapping(map: Map)
    {
        self.full <- (map[self.dynamicType.jsonFullKey], URLTransform())
        self.medium <- (map[self.dynamicType.jsonMediumKey], URLTransform())
        self.thumbnail <- (map[self.dynamicType.jsonThumbKey], URLTransform())
    }

    // MARK: Validable
    public func isValid() -> Bool
    {
        return self.full != nil || self.medium != nil || self.thumbnail != nil
    }
}

// MARK: Equatable
public func ==(lhs: ImageUrls, rhs: ImageUrls) -> Bool
{
    return lhs.full == rhs.full &&
        lhs.medium == rhs.medium &&
        lhs.thumbnail == rhs.thumbnail
}
