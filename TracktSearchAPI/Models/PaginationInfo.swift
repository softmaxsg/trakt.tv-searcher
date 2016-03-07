//
//  PaginationInfo.swift
//  TraktSearchAPI
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import ObjectMapper

public struct PaginationInfo: Mappable, Validable
{
    // Keys are in lowercase because they are lowercased somewhere before they reach us
    private static let headerPageNumberKey = "x-pagination-page"
    private static let headerPageSizeKey = "x-pagination-limit"
    private static let headerItemsCountKey = "x-pagination-item-count"
    private static let headerPagesCountKey = "x-pagination-page-count"

    public private(set) var pageNumber: UInt?
    public private(set) var pageSize: UInt?
    public private(set) var itemsCount: UInt?
    public private(set) var pagesCount: UInt?

    public init?(_ map: Map)
    {
    }

    // MARK: Mappable
    private let uintTransformer = TransformOf<UInt, String>(fromJSON: { UInt($0 ?? "") }, toJSON: { $0.map { String($0) } })

    mutating public func mapping(map: Map)
    {
        self.pageNumber <- (map[PaginationInfo.headerPageNumberKey], self.uintTransformer)
        self.pageSize   <- (map[PaginationInfo.headerPageSizeKey], self.uintTransformer)
        self.itemsCount <- (map[PaginationInfo.headerItemsCountKey], self.uintTransformer)
        self.pagesCount <- (map[PaginationInfo.headerPagesCountKey], self.uintTransformer)
    }

    // MARK: Validable
    public func isValid() -> Bool
    {
        return (self.pageNumber ?? 0) > 0 && (self.pageSize ?? 0) > 0
    }
}
