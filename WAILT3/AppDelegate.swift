//
//  AppDelegate.swift
//  WAILT3
//
//  Created by thislooksfun on 12/24/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	let handler = UpdateHandler()
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		handler.start()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}
