//
//  ViewController.swift
//  StanwoodAnalytics
//
//  Created by ronanoc@icloud.com on 12/29/2017.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import UIKit
import StanwoodAnalytics
import UserNotifications

class ViewController: UIViewController {
    
    var analyticsService: AnalyticsService!
    var appController: AppController!
    
    let screenName = "mainScreen"
    
    @IBOutlet weak var userIdentifierTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var usereMailTextField: UITextField!
    @IBOutlet weak var customEvent1: UIButton!
    @IBOutlet weak var customEvent2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Analytics Demo"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.trackScreen(name: "mainView", className: String(describing: self))
    }
    
    @IBAction func trackEventButtonAction() {
        let params = TrackingParameters(eventName: "ButtonAction",
                                        itemId: "123",
                                        name: "Example",
                                        description: nil,
                                        category: "Abstract",
                                        contentType: "info-1234567890")
        
        AnalyticsService.track(trackingParameters: params)
    }
    
    @IBAction func trackErrorButtonAction() {
        let error = NSError(domain: "Error",
                            code: 0,
                            userInfo: [StanwoodAnalytics.Keys.localizedDescription:"Button Error"])
        
        AnalyticsService.track(error: error)
    }
    
    @IBAction func trackUserButtonAction() {
        let userName = userIdentifierTextField.text
        let email = usereMailTextField.text
        let identifier = userIdentifierTextField.text
        AnalyticsService.track(userName: userName, email: email, identifier: identifier)
    }
    
    @IBAction func clearUserButtonAction() {
        AnalyticsService.trackScreen(name: screenName, className: String(describing: self))
    }
    
    @IBAction func customEvent1Action() {
        var trackerKeys = TrackerKeys.init()
        trackerKeys.customKeys = ["1":screenName]
        AnalyticsService.track(trackerKeys: trackerKeys)
    }
    
    @IBAction func customEvent2Action() {
        var trackerKeys = TrackerKeys.init()
        trackerKeys.customKeys = ["2":screenName]
        AnalyticsService.track(trackerKeys: trackerKeys)
    }
    
    @IBAction func nextButtonAction() {
        showNextScreen()
        trackNextButtonAction()
        print("next button action pressed.")
    }
    
    func showNextScreen() {
        let secondViewController = appController.secondScreen()
        let navigationController = self.navigationController
        navigationController?.pushViewController(secondViewController, animated: true)
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

