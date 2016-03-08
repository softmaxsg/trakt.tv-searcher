//
//  TraktSearchAPI.swift
//  TraktSearchAPI
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public class TraktSearchAPI
{
    // MARK: Private constants
    private static let headerContentTypeKey = "Content-Type"
    private static let headerAcceptKey = "Accept"
    private static let headerContentJSONValue = "application/json"

    private static let headerTraktVersionKey = "trakt-api-version"
    private static let headerTraktApplicationKey = "trakt-api-key"

    private static let headerTraktVersionValue = "2"

    private static let urlPathNameMovies = "movies"
    private static let urlPathNameSearch = "search"

    private static let parameterNameQuery = "query"
    private static let parameterNameType = "type"
    private static let parameterNamePageNumber = "page"
    private static let parameterNamePageSize = "limit"
    private static let parameterNameExtendedData = "extended"

    private static let parameterValueExtendedData = "full,images"

    private static let badServerResponseError = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil)

    internal static let baseServerUrl = NSURL(string: "https://api-v2launch.trakt.tv")!

    // MARK: Public properties
    public private(set) var resultQueue: NSOperationQueue
    public private(set) var applicationKey: String

    init(queue: NSOperationQueue, applicationKey: String)
    {
        self.resultQueue = queue
        self.applicationKey = applicationKey
    }

    // MARK: Private members
    private func callCompletionHandler<T>(completionHandler: (T) -> (), object: T)
    {
        self.resultQueue.addOperationWithBlock {
            completionHandler(object)
        }
    }

    // MARK: Internal API Requests
    internal func performMoviesListRequest<T: Mappable>(url: NSURL, pageNumber: UInt, pageSize: UInt, additionalParameters: [String : AnyObject]?, filterMoviesHandler: ([T]?) -> [Movie]?, completionHandler: (MoviesResponse) -> ())
    {
        assert(pageNumber > 0, "Parameter pageNumber has to be greater than 0")

        let headers: [String: String] = [
            self.dynamicType.headerContentTypeKey : self.dynamicType.headerContentJSONValue,
            self.dynamicType.headerAcceptKey: self.dynamicType.headerContentJSONValue,
            self.dynamicType.headerTraktVersionKey: self.dynamicType.headerTraktVersionValue,
            self.dynamicType.headerTraktApplicationKey: self.applicationKey,
        ]

        var parameters: [String: AnyObject] = [
            self.dynamicType.parameterNamePageNumber: pageNumber,
            self.dynamicType.parameterNamePageSize: pageSize,
            self.dynamicType.parameterNameExtendedData: self.dynamicType.parameterValueExtendedData,
        ]

        if let additionalParameters = additionalParameters {
            for (key, value) in additionalParameters {
                parameters[key] = value
            }
        }

        let defaultError = self.dynamicType.badServerResponseError

        Alamofire.request(.GET, url, headers: headers, parameters: parameters, encoding: .URLEncodedInURL)
        .validate()
        .responseArray { [weak self] (response: Response<[T], NSError>) in
            guard response.result.isSuccess else {
                self?.callCompletionHandler(completionHandler, object: .Error(response.result.error ?? defaultError))
                return
            }

            // Skip invalid search results and fail in case all search results are invalid
            guard let validMovies = filterMoviesHandler(response.result.value)
                where validMovies.count > 0 || response.result.value?.count == 0 else {
                self?.callCompletionHandler(completionHandler, object: .Error(response.result.error ?? defaultError))
                return
            }

            // Fail in case pagination info is not available
            guard let paginationInfo = Mapper<PaginationInfo>().map(response.response?.allHeaderFields as? [String: AnyObject] ?? [:])
                where paginationInfo.isValid() else {
                self?.callCompletionHandler(completionHandler, object: .Error(response.result.error ?? defaultError))
                return
            }

            self?.callCompletionHandler(completionHandler, object: .Success(validMovies, paginationInfo))
        }
    }

    internal func loadMovies(requestType: MoviesRequestType, pageNumber: UInt, pageSize: UInt, completionHandler: (MoviesResponse) -> ())
    {
        self.performMoviesListRequest(
            self.dynamicType.baseServerUrl.URLByAppendingPathComponent("\(self.dynamicType.urlPathNameMovies)/\(requestType.rawValue)"),
            pageNumber: pageNumber,
            pageSize: pageSize,
            additionalParameters: nil,
            filterMoviesHandler: { (movies: [Movie]?) in
                movies?.filter { $0.isValid() }
            },
            completionHandler: completionHandler
        )
    }

    // MARK: Public API Requests
    public func loadPopularMovies(pageNumber pageNumber: UInt, pageSize: UInt, completionHandler: (MoviesResponse) -> ())
    {
        self.loadMovies(.Popular, pageNumber: pageNumber, pageSize: pageSize, completionHandler: completionHandler)
    }

    public func searchMovies(query: String, pageNumber: UInt, pageSize: UInt, completionHandler: (MoviesResponse) -> ())
    {
        self.performMoviesListRequest(
            self.dynamicType.baseServerUrl.URLByAppendingPathComponent(self.dynamicType.urlPathNameSearch),
            pageNumber: pageNumber,
            pageSize: pageSize,
            additionalParameters: [
                self.dynamicType.parameterNameQuery: query,
                self.dynamicType.parameterNameType: ItemKind.Movie.rawValue,
            ],
            filterMoviesHandler: { (resultItems: [SearchResultItem]?) in
                resultItems?.map { $0.item as? Movie ?? Movie(JSON: [:])! }.filter { $0.isValid() }
            },
            completionHandler: completionHandler
        )
    }
}
