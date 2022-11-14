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


class ViewController: UIViewController {
    
    let yourClientId = "6058635aa6a92469bed037b0"
    let yourVersion = "ga_fb"

    //let yourClientId = "your client id"
    //let yourVersion = "your version"

	private var dismissHandler: (() -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
		Axeptio.shared.initialize(clientId: yourClientId, version: yourVersion) { [weak self] error in
			if #available(iOS 14, *) {
				ATTrackingManager.requestTrackingAuthorization { status in
					switch status {
					case .authorized:
						self?.showCookiesController()
						
					case .denied:
						Axeptio.shared.setUserConsentToDisagreeWithAll()
					case .notDetermined:
						self?.showCookiesController()
					case .restricted:
						self?.showCookiesController()
					@unknown default:
						self?.showCookiesController()
					}
				}
			} else {
				// Fallback on earlier versions
				self?.showCookiesController()
			}
		}
	}
	
	@IBAction private func clearUserConsents(_ sender: Any? = nil) {
		Axeptio.shared.clearUserConsents()
	}
	
	@IBAction private func showCookiesController(_ sender: Any? = nil) {
		DispatchQueue.main.async {
			self.dismissHandler?()
			self.dismissHandler = Axeptio.shared.showConsentController(onlyFirstTime: sender == nil, in: self) { error in
				Axeptio.shared.getVendors().forEach { vendor in
					let result = Axeptio.shared.getUserConsent(forVendor: vendor)
                    print("\(vendor) consent is \(String(describing: result))")
				}
			}
		}
	}
}
