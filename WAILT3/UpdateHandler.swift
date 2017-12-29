////
//  UpdateHandler.swift
//  WAILT3
//
//  Created by thislooksfun on 12/27/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Foundation

class UpdateHandler {
	
	var playerInfoView: PlayerInfoView?
	
	func start() {
		StorageHandler.shared.addObserver(onChange(_:))
	}
	
	func onChange(_ players: [Player]) {
		guard let piv = playerInfoView else { return }
		
		if players.count == 0 {
			piv.setPlayer(.nothingPlaying)
		} else if players.count == 1 {
			piv.setPlayer(players.first!)
		} else {
			piv.setPlayer(.multipleSources(players.count))
		}
	}
}
