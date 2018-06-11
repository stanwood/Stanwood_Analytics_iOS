//
//  AppController.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 20/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import UIKit

protocol Actionable {
    func setTracking(enable: Bool, viewController: UIViewController?)
}

class AppController: Actionable {

    private let appData = AppData()
    var dataProvider: DataProvider!
    
    init() {
        AnalyticsService.configure()
        dataProvider = DataProvider(with: appData)
    }
    
    func setTracking(enable: Bool, viewController: UIViewController?) {
        AnalyticsService.setTracking(enable: enable,viewController:viewController)
    }
    
    func secondScreen() -> SecondViewController {
        let parameters = dataProvider as SecondViewParametable
        let action = self as Actionable
        return SecondWireframe.prepare(parameters: parameters, action: action)
    }
}
