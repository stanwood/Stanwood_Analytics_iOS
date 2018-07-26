//
//  AppController.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 20/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import UIKit
import Firebase
import StanwoodAnalytics

class AppController {
    private let appData = AppData()
    var dataProvider: DataProvider!
    var window: UIWindow?
    var coordinator: Coordinator?
    var actions: Actions?
    
    init(window: UIWindow) {
        self.window = window
        dataProvider = DataProvider(with: appData)
        
        guard let firebaseConfigFile = Bundle.main.path(forResource: Configuration.Static.Analytics.firebaseConfigFileName, ofType: "plist") else {
            return
        }
        
        guard let firebaseOptions = FirebaseOptions(contentsOfFile: firebaseConfigFile) else {
            return
        }
        
        FirebaseApp.configure(options: firebaseOptions)
    }
    
    func configure() {
        actions = Actions(appController: self)
        coordinator = Coordinator(window: window!, actions: actions!, dataProvider: dataProvider)
        coordinator?.start()
        actions?.coordinator = coordinator
        AnalyticsService.configure()
        observeDebuggerNotifications()
    }
    
    func observeDebuggerNotifications() {
        let notificationName = AnalyticsService.notificationName()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didReceiveNotification),
                                       name: Notification.Name(rawValue: notificationName),
                                       object: nil)
    }
    
    @objc func didReceiveNotification(notification: Notification) {
        let payload = notification.userInfo
        let message = payload![StanwoodAnalytics.Keys.eventName] as! String
        let rootViewController = window?.rootViewController
        let alertController = makeAlert(message: message, buttonTitle: "OK")
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func makeAlert(viewController: UIViewController? = nil, message: String, buttonTitle: String) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: buttonTitle, style: .default) { _ in
            viewController?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(ok)
        return alertController
    }
}
