//
//  SecondScreenViewController.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 05/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import UIKit
import StanwoodAnalytics


class SecondScreenViewController: UIViewController {
    let screenName = "secondView"
    
    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customEvent1Button: UIButton!
    @IBOutlet weak var customEvent2Button: UIButton!
    
    var presenter: SecondScreenPresenter!
    
    @IBAction func customEvent1Action(_ sender: Any) {
        let index = 1
        var trackerKeys = TrackerKeys.init()
        trackerKeys.customKeys = [String(describing: index):screenName]
        AnalyticsService.track(trackerKeys: trackerKeys)
    }
    
    @IBAction func customEvent2Action(_ sender: Any) {
        let index = 2
        var trackerKeys = TrackerKeys.init()
        trackerKeys.customKeys = [String(describing: index):screenName]
        
        AnalyticsService.track(trackerKeys: trackerKeys)
    }
    
    @IBAction func switchDidChangeAction(_ sender: Any) {
        guard let trackingSwitch = sender as? UISwitch else { return }
        presenter.switchDidChangeAction(isOn: trackingSwitch.isOn)
    }
    
    @IBAction func crashButtonAction(_ sender: Any) {
        presenter.crashButtonAction()
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
