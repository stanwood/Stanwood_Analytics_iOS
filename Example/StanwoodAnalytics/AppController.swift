//
//  AppController.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 20/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import UIKit
import Firebase

protocol Actionable {
    func setTracking(enable: Bool, viewController: UIViewController?)
}

class AppController: Actionable {

    private let appData = AppData()
    var dataProvider: DataProvider!

    init() {
        dataProvider = DataProvider(with: appData)
        guard let firebaseConfigFile = Bundle.main.path(forResource: Configuration.Static.Analytics.firebaseConfigFileName, ofType: "plist") else {
            configure()
            return
        }

        guard let firebaseOptions = FirebaseOptions(contentsOfFile: firebaseConfigFile) else {
            configure()
            return
        }

        FirebaseApp.configure(options: firebaseOptions)
        configure()
    }

    func configure() {
        AnalyticsService.configure()
    }

    func setTracking(enable: Bool, viewController: UIViewController?) {
        AnalyticsService.setTracking(enable: enable, viewController: viewController)
    }

    func secondScreen() -> SecondViewController {
        let parameters = dataProvider as SecondViewParametable
        let action = self as Actionable
        return SecondWireframe.prepare(parameters: parameters, action: action)
    }
}
