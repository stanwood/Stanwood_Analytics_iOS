//
//  FirstViewActions.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 25/07/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

protocol FirstScreenActionable {
    func nextButtonAction()
}

extension Actions: FirstScreenActionable {
    func nextButtonAction() {
        coordinator.showNextScreen()
    }
}
