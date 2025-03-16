//
//  Untitled.swift
//  LloydBakingTest
//
//  Created by Nitin on 05/03/25.
//


import Foundation
import XCTest

public func loadLocalTestData(from fileName: String, for testClass: AnyClass) -> Data {
    let bundle = Bundle(for: testClass)
    guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
        fatalError("Local test data file \(fileName).json not found in the bundle for \(testClass)")
    }
    return try! Data(contentsOf: url)
}
