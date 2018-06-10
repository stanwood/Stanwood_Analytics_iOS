//
//  AppData.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 24/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import Foundation

class AppData {
    static let userDefaultsKey = "tracking"
    
    init() {
        registerDefaults()
    }
    
    private func registerDefaults() {
        UserDefaults.standard.register(defaults: [AppData.userDefaultsKey : false])
    }
    
    func saveTracking(enable: Bool) {
        UserDefaults.standard.set(enable, forKey: AppData.userDefaultsKey)
    }
    
    func readTrackingEnable() -> Bool {
        return UserDefaults.standard.bool(forKey: AppData.userDefaultsKey)
        // ?? false
    }
}
