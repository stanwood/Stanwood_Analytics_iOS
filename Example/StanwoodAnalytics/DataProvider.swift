//
//  DataProvider.swift
//  StanwoodAnalytics_Example
//
//  Created by Ronan on 24/04/2018.
//  Copyright © 2018 Stanwood GmbH. All rights reserved.
//

import Foundation

protocol SecondScreenParameterable {

}

class DataProvider: SecondScreenParameterable {
    let appData: AppData!

    init(with appData: AppData) {
        self.appData = appData
    }
}
