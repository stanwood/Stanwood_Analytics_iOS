//
//  Coordinator.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 25/07/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class Coordinator {
    let window: UIWindow
    let dataProvider: DataProvider
    let actions: Actionable
    
    init(window: UIWindow, actions: Actionable, dataProvider: DataProvider) {
        self.window = window
        self.actions = actions
        self.dataProvider = dataProvider
    }
    
    func start() {
        if let navigationController = window.rootViewController as? UINavigationController {
            let viewController = navigationController.viewControllers.first as! ViewController
            FirstScreenWireframe.prepare(viewController: viewController, actions: actions as! FirstScreenActionable)
        }
    }
    
    func showNextScreen() {
        let secondScreenActions = actions as! SecondScreenActionable
        let secondScreenViewController = secondScreen(actions: secondScreenActions)
        let navigationController = window.rootViewController as! UINavigationController
        navigationController.pushViewController(secondScreenViewController, animated: true)
    }
    
    func secondScreen(actions: SecondScreenActionable) -> SecondScreenViewController {
        let parameters = dataProvider as SecondScreenParameterable
        let viewController = SecondWireframe.makeViewController()
        SecondWireframe.prepare(viewController: viewController, parameters: parameters, actions: actions)
        return viewController
    }
}
