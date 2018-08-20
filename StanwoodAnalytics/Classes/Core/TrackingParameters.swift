//
//  TrackingParameters.swift
//  StanwoodAnalytics.common
//
//  Created by Ronan on 28/07/2018.
//

import Foundation

/**
 A struct to hold all the values to be sent to the trackers.
 */
public struct TrackingParameters {
    /// The event name
    public let eventName: String
    /// Item Id
    public var itemId: String?
    /// Name
    public var name: String?
    /// Description
    public var description: String?
    /// Category
    public var category: String?
    /// Content Type
    public var contentType: String?
    /// Define custom parameters here
    public var customParameters: [String: Any] = [:]

    /// Init with event name only. The remaining parameters are all set to nil.
    ///
    /// - Parameter eventName: event name
    public init(eventName: String) {
        self.eventName = eventName
        itemId = nil
        name = nil
        description = nil
        category = nil
        contentType = nil
    }

    /// Init with all the parameters. Event name is required, the remaining parameters are optionals.
    ///
    /// - Parameters:
    ///   - eventName: event name
    ///   - itemId: item id
    ///   - name: name
    ///   - description: description
    ///   - category: category
    ///   - contentType: content type
    public init(eventName: String,
                itemId: String?,
                name: String?,
                description: String?,
                category: String?,
                contentType: String?) {

        self.eventName = eventName
        self.itemId = itemId
        self.name = name
        self.description = description
        self.category = category
        self.contentType = contentType
    }

    /// Init with event name and content type only. The remaining parameters are all set to nil.
    ///
    /// - Parameters:
    ///   - eventName: event name
    ///   - contentType: content type
    public init(eventName: String,
                contentType: String?) {

        self.eventName = eventName
        itemId = nil
        name = nil
        description = nil
        category = nil
        self.contentType = contentType
    }

    /// Init with event name and name only. The remaining parameters are all set to nil.
    ///
    /// - Parameters:
    ///   - eventName: event name
    ///   - name: name
    public init(eventName: String,
                name: String?) {

        self.eventName = eventName
        itemId = nil
        self.name = name
        description = nil
        category = nil
        contentType = nil
    }

    /// The info displayed for the local notification when debugging tracking.
    ///
    /// - Returns: A string with each non-nil parameter
    public func debugInfo() -> String {
        var line1 = "Event: " + eventName + "\n"

        if let debugName = name {
            line1.append("Name: " + debugName + " ")
        }

        if let debugId = itemId {
            line1.append("ItemId: " + debugId + " ")
        }

        if let debugDescription = description {
            line1.append("Description: " + debugDescription + " ")
        }

        if let debugCategory = category {
            line1.append("Category: " + debugCategory + " ")
        }

        if let debugContentType = contentType {
            line1.append("Content Type: " + debugContentType + " ")
        }

        return line1
    }
    
    public func payload() -> [String:String] {
        var payload: [String:String] = [StanwoodAnalytics.Keys.eventName: eventName]
        if itemId != nil {
            payload[StanwoodAnalytics.Keys.itemId] = itemId
        }
        if category != nil {
            payload[StanwoodAnalytics.Keys.category] = category
        }
        
        if contentType != nil {
            payload[StanwoodAnalytics.Keys.contentType] = contentType
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        payload[StanwoodAnalytics.Keys.createdAt] = dateFormatter.string(from: Date())
        return payload
    }
}
