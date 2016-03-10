//
//  XCTestCase+Helpers.swift
//  TraktSearchTests
//
//  Copyright © 2016 Vitaly Chupryk. All rights reserved.
//

import XCTest

extension XCTestCase
{
    func URLForFileName(fileName: String) -> NSURL?
    {
        return NSBundle(forClass: self.dynamicType).URLForResource(fileName, withExtension: nil)
    }

    func JSONObjectWithFileName(fileName: String) -> AnyObject?
    {
        guard let fileUrl = self.URLForFileName(fileName) else {
            return nil
        }

        guard let jsonData = NSData(contentsOfURL: fileUrl) else {
            return nil
        }

        return try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions())
    }
}