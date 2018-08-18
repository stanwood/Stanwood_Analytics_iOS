//
//  SecondViewController.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 05/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import UIKit
import StanwoodAnalytics
import Crashlytics

class SecondViewController: UIViewController {
    let screenName = "secondView"

    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customEvent1Button: UIButton!
    @IBOutlet weak var customEvent2Button: UIButton!

    var action: Actionable?
    var parameters: SecondViewParametable?

    @IBAction func customEvent1Action(_: Any) {
        let index = 1
        var trackerKeys = TrackerKeys.init()
        trackerKeys.customKeys = [String(describing: index): screenName]
        AnalyticsService.track(trackerKeys: trackerKeys)
    }

    @IBAction func customEvent2Action(_: Any) {
        let index = 2
        var trackerKeys = TrackerKeys.init()
        trackerKeys.customKeys = [String(describing: index): screenName]

        AnalyticsService.track(trackerKeys: trackerKeys)
    }

    @IBAction func switchDidChangeAction(_ sender: Any) {
        guard let trackingSwitch = sender as? UISwitch else { return }
        action?.setTracking(enable: trackingSwitch.isOn, viewController: self)
    }

    @IBAction func crashButtonAction(_: Any) {
        Crashlytics.sharedInstance().crash()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.trackScreen(name: screenName, className: String(describing: self))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackingSwitch.isOn = AnalyticsService.trackingEnabled()
    }
}
