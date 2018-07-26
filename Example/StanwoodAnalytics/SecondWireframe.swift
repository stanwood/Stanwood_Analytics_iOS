//
//  SecondWireframe.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 24/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import UIKit

struct SecondWireframe {
    static func makeViewController() -> SecondScreenViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SecondScreenViewController") as! SecondScreenViewController
    }
    
    static func prepare(viewController: SecondScreenViewController,
                        parameters:SecondScreenParameterable,
                        actions: SecondScreenActionable) {
        let presenter = SecondScreenPresenter(viewController: viewController, actions: actions, parameters: parameters)
        viewController.presenter = presenter
        presenter.viewController = viewController
    }
}

