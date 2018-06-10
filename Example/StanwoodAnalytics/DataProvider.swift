//
//  DataProvider.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 24/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import Foundation

protocol SecondViewParametable {
    func setTracking(enable: Bool)
    func trackingEnabled() -> Bool
}

class DataProvider: SecondViewParametable {
    
    let appData: AppData!
    
    init(with appData: AppData) {
        self.appData = appData
    }
    
    func trackingEnabled() -> Bool {
        return appData.readTrackingEnable()
    }
    
    func setTracking(enable: Bool) {
        appData.saveTracking(enable: enable)
    }
}
