//
//  ImageUrls.swift
//  TraktSearchAPI
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ImageUrls: Mappable, Validable
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
        self.full <- (map[ImageUrls.jsonFullKey], URLTransform())
        self.medium <- (map[ImageUrls.jsonMediumKey], URLTransform())
        self.thumbnail <- (map[ImageUrls.jsonThumbKey], URLTransform())
    }

    // MARK: Validable
    public func isValid() -> Bool
    {
        return self.full != nil || self.medium != nil || self.thumbnail != nil
    }
}
