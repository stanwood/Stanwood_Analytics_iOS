//
//  DataStore.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Stanwood GmbH (www.stanwood.io)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public protocol DataStorage {
    static func setTracking(enabled: Bool)
    static var trackingEnabled: Bool { get }
}

/// Wrapper class for saving tracking flag to UserDefaults
public class DataStore: DataStorage {

    /// The key
    private static let userDefaultsKey = "Stanwood.Analytics.tracking"

    /// Read the stored value
    public static var trackingEnabled: Bool {
        return UserDefaults.standard.bool(forKey: DataStore.userDefaultsKey)
    }

    /// Register defaults
    public static func registerDefaults() {
        UserDefaults.standard.register(defaults: [DataStore.userDefaultsKey: true])
    }

    /// Set tracking boolean value
    ///
    /// - Parameter enabled: boolean value
    public static func setTracking(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: DataStore.userDefaultsKey)
        UserDefaults.standard.synchronize()
    }
}
