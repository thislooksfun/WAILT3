//
//  SafariExtensionHandler.swift
//  WAILT3
//
//  Created by thislooksfun on 12/24/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
	
	override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
//		page.getPropertiesWithCompletionHandler { properties in /* code */ }
		
		guard let ui = userInfo else { return }
		
		guard let p = Player(dict: ui) else {
			print("Invalid userInfo for \(messageName) -- \(userInfo?.debugDescription ?? "nil"))")
			return
		}
		
		print("\(Date().timeIntervalSince1970) -- \(messageName) -- \(p)")
		StorageHandler.shared.addPlayer(p)
	}
}
