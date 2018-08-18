//
//  SecondWireframe.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 24/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import UIKit

struct SecondWireframe {
    static func prepare(parameters: SecondViewParametable, action: Actionable) -> SecondViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        secondViewController.action = action
        secondViewController.parameters = parameters
        return secondViewController
    }
}
