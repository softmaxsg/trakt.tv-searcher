//
//  MovieImageKind.swift
//  TraktSearchAPI
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import ObjectMapper

public enum MovieImageKind: String
{
    case FanArt = "fanart"
    case Poster = "poster"
    case Logo = "logo"
    case ClearArt = "clearart"
    case Banner = "banner"
    case Thumbnail = "thumb"
}

public class MovieImageKindTransform: TransformType
{
    public typealias Object = [MovieImageKind: ImageUrls]
    public typealias JSON = [String: AnyObject]

    public func transformFromJSON(value: AnyObject?) -> [MovieImageKind: ImageUrls]?
    {
        guard let dictionary = value as? [String: AnyObject] else {
            return nil
        }

        var result: [MovieImageKind: ImageUrls] = [:]
        for (key, value) in dictionary {
            guard let imageKind = MovieImageKind(rawValue: key) else {
                continue
            }

            guard let imageUrls = Mapper<ImageUrls>().map(value) where imageUrls.isValid() else {
                continue
            }

            result[imageKind] = imageUrls
        }

        if result.count == 0 {
            return nil
        }

        return result
    }

    // We don't generate JSON, so, this isn't required
    public func transformToJSON(value: [MovieImageKind: ImageUrls]?) -> [String: AnyObject]?
    {
        return nil
    }
}