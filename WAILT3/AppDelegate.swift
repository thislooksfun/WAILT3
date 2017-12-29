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
	let piv = PlayerInfoView()
	let handler = UpdateHandler()
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		StorageHandler.shared.autoPrune()
		
		constructMenu([])
		
		statusItem.view = piv
		statusItem.highlightMode = true
		
		piv.statusItem = statusItem
		piv.setPlayer(.nothingPlaying)
		
		handler.playerInfoView = piv
		handler.start()
	}
	
	func constructMenu(_ sources: [String]) {
		let menu = NSMenu()
		
		for s in sources {
			menu.addItem(withTitle: s, action: nil, keyEquivalent: "")
		}
		menu.addItem(NSMenuItem.separator())
		menu.addItem(withTitle: "Quit WAILT", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
		
		statusItem.menu = menu
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}
