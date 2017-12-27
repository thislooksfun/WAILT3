////
//  UpdateHandler.swift
//  WAILT3
//
//  Created by thislooksfun on 12/27/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Foundation

class UpdateHandler {
	
	var scrollingTextView: ScrollingTextView?
	
	func start() {
		StorageHandler.shared.addObserver(onChange(_:))
	}
	
	func onChange(_ players: [String: Player]) {
		guard let stv = scrollingTextView else { return }
		
		if players.count == 0 {
			stv.setText("Nothing playing")
		} else if players.count == 1 {
			stv.setText(players.first!.value.title)
		} else {
			stv.setText("\(players.count) sources")
		}
	}
}
