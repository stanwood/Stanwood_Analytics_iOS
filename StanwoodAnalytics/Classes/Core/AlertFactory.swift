//
//  AlertFactory.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Stanwood GmbH (www.stanwood.io)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

/// A Factory class that returns an AlertController
public class AlertFactory {

    /// Returns an AlertViewController with an OK button and displays a message on the view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to present the alert
    ///   - message: The message to display
    ///   - buttonTitle: The button title
    /// - Returns: UIAlertController
    public static func makeAlert(viewController: UIViewController? = nil, message: String, buttonTitle: String) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: buttonTitle, style: .default) { _ in
            viewController?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(ok)
        return alertController
    }
}
