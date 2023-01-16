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

let axeptioId = "624d5e22e4776e1f019014e2"
let axeptioVersionFr = "axeptio-prod-fr"
let axeptioVersionEn = "axeptio-prod-en"

let demoId: String = "637f77ebb38394b040ab643e"
let demoVersionEn: String = "test-en"
let demoVersionfr: String = "test-fr"

let basicId = "6058635aa6a92469bed037b0"
let basicVersion = "ga_fb"

class ViewController: UIViewController {
    
    var yourClientId = demoId
    var yourVersion = demoVersionEn

    //var yourClientId = "your client id"
    //var yourVersion = "your version"

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
			self.dismissHandler = Axeptio.shared.showConsentController(onlyFirstTime: false, in: self) { error in
				Axeptio.shared.getVendors().forEach { vendor in
					let result = Axeptio.shared.getUserConsent(forVendor: vendor)
                    print("\(vendor) consent is \(String(describing: result))")
				}
			}
		}
	}
    
    @IBAction func swapIdentifiers(_ sender: Any) {
        
        if (yourClientId == axeptioId) {
            yourClientId = demoId
            yourVersion = demoVersionEn
        } else {
            yourClientId = axeptioId
            yourVersion = axeptioVersionFr
        }

        Axeptio.shared.rerere(clientId: yourClientId, version: yourVersion) { [weak self] error in
            if (error == nil) {
                self?.showCookiesController()
            }
        }
    }
}
