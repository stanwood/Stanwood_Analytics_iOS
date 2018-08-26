//
//  Actions.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 25/07/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol Actionable {
}

class Actions: Actionable {
    var appController: AppController!
    var coordinator: Coordinator!

    init(appController: AppController) {
        self.appController = appController
    }
}
