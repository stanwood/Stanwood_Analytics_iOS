//
//  AppController.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 20/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import Foundation

protocol Actionable {
    func setTracking(enable: Bool)
}

class AppController: Actionable {

    private let appData = AppData()
    var dataProvider: DataProvider!
    
    init() {
        AnalyticsService.configure()
        dataProvider = DataProvider(with: appData)
        // AnalyticsService.setTracking(enable: dataProvider.trackingEnabled())
    }
    
    func setTracking(enable: Bool) {
        dataProvider.setTracking(enable: enable)
        AnalyticsService.setTracking(enable: enable)
    }
    
    func secondScreen() -> SecondViewController {
        let parameters = dataProvider as SecondViewParametable
        let action = self as Actionable
        return SecondWireframe.prepare(parameters: parameters, action: action)
    }
}
