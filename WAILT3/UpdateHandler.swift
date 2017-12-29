////
//  UpdateHandler.swift
//  WAILT3
//
//  Created by thislooksfun on 12/27/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Cocoa

class UpdateHandler {
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	let playerInfoView = PlayerInfoView()
	
	func start() {
		StorageHandler.shared.addObserver(onChange(_:))
		
		StorageHandler.shared.autoPrune()
		
		constructMenu([])
		
		statusItem.view = playerInfoView
		statusItem.highlightMode = true
		
		playerInfoView.statusItem = statusItem
		playerInfoView.setPlayer(.nothingPlaying)
	}
	
	func onChange(_ players: [Player]) {
		if players.count == 0 {
			playerInfoView.setPlayer(.nothingPlaying)
		} else if players.count == 1 {
			playerInfoView.setPlayer(players.first!)
		} else {
			playerInfoView.setPlayer(.multipleSources(players.count))
		}
		
		constructMenu(players)
	}
	
	func constructMenu(_ sources: [Player]) {
		let menu = NSMenu()
		
		for s in sources {
			//TODO: Limit length of title?
			menu.addItem(withTitle: s.title, action: nil, keyEquivalent: "")
		}
		menu.addItem(NSMenuItem.separator())
		menu.addItem(withTitle: "Quit WAILT", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
		
		statusItem.menu = menu
	}
}
