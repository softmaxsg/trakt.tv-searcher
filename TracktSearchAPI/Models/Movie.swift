//
//  Movie.swift
//  TraktSearchAPI
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Movie: TraktItem
{
    private static let jsonTitleKey = "title"
    private static let jsonOverviewKey = "overview"
    private static let jsonYearKey = "year"
    private static let jsonImagesKey = "images"

    public private(set) var title: String?
    public private(set) var overview: String?
    public private(set) var year: UInt?
    public private(set) var images: [MovieImageKind: ImageUrls]?

    public init?(_ map: Map)
    {
    }

    // MARK: Mappable
    mutating public func mapping(map: Map)
    {
        self.title     <- map[self.dynamicType.jsonTitleKey]
        self.overview  <- map[self.dynamicType.jsonOverviewKey]
        self.year      <- map[self.dynamicType.jsonYearKey]
        self.images    <- (map[self.dynamicType.jsonImagesKey], MovieImageKindTransform())
    }

    // MARK: Validable
    public func isValid() -> Bool
    {
        return self.title != nil && (self.year ?? 0) > 0
    }
}
