//
//  SearchResultItem.swift
//  TraktSearchAPI
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import ObjectMapper

public struct SearchResultItem: Mappable, Validable
{
    private static let jsonKindKey = "type"
    private static let jsonScoreKey = "score"

    public private(set) var kind: ItemKind?
    public private(set) var score: Double?
    public private(set) var item: TraktItem?

    public init?(_ map: Map)
    {
    }

    // MARK: Mappable
    private let movieTransformer = TransformOf<TraktItem, [String: AnyObject]>(
        fromJSON: { jsonValue in
            guard let value = jsonValue, let movie = Movie(JSON: value) where movie.isValid() else {
                return nil
            }

            return movie
        },
        // We don't generate JSON, so, this isn't required
        toJSON: { value in nil }
    )

    mutating public func mapping(map: Map)
    {
        self.kind   <- map[SearchResultItem.jsonKindKey]
        self.score  <- map[SearchResultItem.jsonScoreKey]

        if let kind = self.kind {
            switch kind {
            case .Movie: self.item <- (map[kind.rawValue], movieTransformer)
            }

            if !((self.item as? Validable)?.isValid() ?? false) {
                self.item = nil
            }
        } else {
            self.item = nil
        }
    }

    // MARK: Validable
    public func isValid() -> Bool
    {
        return self.kind != nil && self.item != nil
    }
}
