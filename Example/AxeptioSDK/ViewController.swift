//
//  ViewController.swift
//  Test
//
//  Created by Cyril Anger on 02/03/2021.
//  Copyright © 2021 Axeptio. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AxeptioSDK

// Demo
private let clientId = "637f77ebb38394b040ab643e"
private let configurationVersion = "test-en"
//private let configurationVersion = "test-fr"

class ViewController: UIViewController {
	private var dismissHandler: (() -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		Axeptio.shared.initialize(clientId: clientId, version: configurationVersion) { [weak self] error in
			if #available(iOS 14, *) {
				ATTrackingManager.requestTrackingAuthorization() { status in
					DispatchQueue.main.async() {
						switch status {
						case .denied: Axeptio.shared.setUserConsentToDisagreeWithAll()
						default: self?.showCookiesController()
						}
					}
				}
			} else {
				self?.showCookiesController()
			}
		}
	}
	
	@IBAction private func clearUserConsents(_ sender: Any? = nil) {
		Axeptio.shared.clearUserConsents()
	}
	
	@IBAction private func showCookiesController(_ sender: Any? = nil) {
		self.dismissHandler?()
		self.dismissHandler = Axeptio.shared.showConsentController(onlyFirstTime: sender == nil, in: self) { error in
			for vendor in Axeptio.shared.getVendors() {
				if let result = Axeptio.shared.getUserConsent(forVendor: vendor) {
					print("\(vendor) consent is \(result)")
				} else {
					print("\(vendor) consent is not set")
				}
			}
		}
	}
}
