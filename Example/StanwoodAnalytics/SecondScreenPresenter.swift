//
//  SecondScreenPresenter.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 25/07/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Crashlytics

class SecondScreenPresenter {
    var actions: SecondScreenActionable!
    unowned var viewController: SecondScreenViewController
    var parameters: SecondScreenParameterable!
    
    init(viewController: SecondScreenViewController, actions: SecondScreenActionable, parameters: SecondScreenParameterable) {
        self.viewController = viewController
        self.actions = actions
        self.parameters = parameters
    }
    
    func switchDidChangeAction(isOn: Bool) {
        actions?.setTracking(enable: isOn, viewController: viewController)
    }
    
    func crashButtonAction() {
        Crashlytics.sharedInstance().crash()
    }
}
