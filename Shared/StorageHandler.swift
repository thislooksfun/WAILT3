//
//  StorageHandler.swift
//  WAILT3
//
//  Created by thislooksfun on 12/25/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Foundation

class StorageHandler {
	
	static let shared = StorageHandler()
	
	private var observers: [([Player]) -> Void] = []
	private(set) var players: [String: Player] = [:]
	
	private var observer: NSKeyValueObservation!
	private var pruneTimer: Timer? = nil
	
	private init() {
		observer = sharedDefaults.observe(\.players, options: [.initial, .new], changeHandler: change)
		
		let dictArr = sharedDefaults.value(forKey: "players") as? [[String: Any]]
		setPlayersFromDictArr(dictArr ?? [])
	}
	
	private var sharedDefaults: UserDefaults {
		//TODO: Make this work:
//		let suite = Bundle.main.infoDictionary!["AppIdentifierPrefix"] as! String
//		return UserDefaults(suiteName: suite)!
		return UserDefaults(suiteName: "Q9K6UK48V2.com.thislooksfun.WAILT3")!
	}
	
	private func change(defaults: UserDefaults, change: NSKeyValueObservedChange<[[String: Any]]?>) {
		guard let dictArr = sharedDefaults.value(forKey: "players") as? [[String: Any]] else {
			return
		}
		setPlayersFromDictArr(dictArr)
		
		let flatPlayers = players.flatMap { $0.value }
		observers.all(flatPlayers)
	}
	
	func setPlayersFromDictArr(_ da: [[String: Any]]) {
		var newPlayers: [String: Player] = [:]
		for dict in da {
			if let p = Player(dict: dict) {
				newPlayers[p.uid] = p
			}
		}
		players = newPlayers
	}
	
	private func save() {
		sharedDefaults.setValue(players.asDictArray, forKey: "players")
	}
	
	func clearPlayers() {
		players = [:]
		save()
	}
	
	func addPlayer(_ p: Player) {
		players[p.uid] = p
		save()
	}
	
	func removePlayer(_ p: Player) {
		players.removeValue(forKey: p.uid)
		save()
	}
	
	func addObserver(_ closure: @escaping ([Player]) -> Void) {
		observers.append(closure)
		let flatPlayers = players.flatMap { $0.value }
		closure(flatPlayers)
	}
	
	func autoPrune() {
		if (pruneTimer == nil) {
			pruneTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in self.prune() })
		}
	}
	
	func prune() {
		let before = players.count
		players = players.filter { (e) in e.value.lastUpdated.timeIntervalToNow < 1 }
		if before != players.count {
			save()  // Only save if something actually changed.
		}
	}
}


extension UserDefaults {
	@objc dynamic var players: [[String: Any]]? {
		return value(forKey: "players") as? [[String: Any]]
	}
}
