//
//  SecondViewActions.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 25/07/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol SecondScreenActionable {
    func setTracking(enable: Bool, viewController: UIViewController?)
}

extension Actions: SecondScreenActionable {
    func setTracking(enable: Bool, viewController: UIViewController?) {
        AnalyticsService.setTracking(enable: enable,viewController:viewController)
    }
}
