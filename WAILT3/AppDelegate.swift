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
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	let stv = ScrollingTextView()
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		StorageHandler.shared.autoPrune()
		
		statusItem.view = stv
		stv.setText("short", animated: false)
		stv.setText("Second thing is long", animated: true)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}
