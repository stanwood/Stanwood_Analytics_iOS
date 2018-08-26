//
//  FirstScreenPresenter.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 25/07/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import StanwoodAnalytics
import UserNotifications

class FirstScreenPresenter {
    var actions: FirstScreenActionable!

    unowned var viewController: ViewController

    init(viewController: ViewController, actions: FirstScreenActionable) {
        self.actions = actions
        self.viewController = viewController
    }

    func nextButtonAction() {
        actions.nextButtonAction()
        trackNextButtonAction()
    }

    func trackNextButtonAction() {
        let params = TrackingParameters(eventName: "NextButtonAction",
                                        itemId: "101",
                                        name: "Example",
                                        description: nil,
                                        category: "Abstract",
                                        contentType: "info-1234567890")

        AnalyticsService.track(trackingParameters: params)
    }
}
