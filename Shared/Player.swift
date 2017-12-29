//
//  Player.swift
//  WAILT3
//
//  Created by thislooksfun on 12/25/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Foundation

struct Player: CustomDebugStringConvertible, Equatable {
	// If any more special UIDs are added, make sure to update `hidesTime` if needed
	private static let blankUID = "_b_"
	private static let nothingPlayingUID = "_np_"
	private static let multipleSourcesUID = "_ms_"
	
	static let blank = Player(uid: blankUID, title: "")
	static let nothingPlaying = Player(uid: nothingPlayingUID, title: "Nothing Playing")
	static func multipleSources(_ i: Int) -> Player {
		return Player(uid: multipleSourcesUID, title: "\(i) Sources")
	}
	
	
	let uid: String
	let title: String
	let currentTime: TimeInterval
	let duration: TimeInterval
	let lastUpdated: Date
	
	init?(dict: [String: Any]) {
		guard let uid = dict["uid"] as? String,
			let title = dict["title"] as? String,
			let currentTime = dict["currentTime"] as? TimeInterval,
			let duration = dict["duration"] as? TimeInterval
			else {
				return nil
		}
		let lu = dict["lastUpdated"] as? Date
		self.init(uid: uid, title: title, currentTime: currentTime, duration: duration, lastUpdated: lu)
	}
	
	private init(uid: String, title: String, currentTime: TimeInterval = .nan, duration: TimeInterval = .nan, lastUpdated: Date? = nil) {
		self.uid = uid
		self.title = title
		self.currentTime = currentTime
		self.duration = duration
		
		self.lastUpdated = lastUpdated ?? Date()
	}
	
	var asDict: [String: Any] {
		return ["uid": uid, "title": title, "currentTime": currentTime, "duration": duration, "lastUpdated": lastUpdated]
	}
	
	var debugDescription: String {
		return "\(title) (\(currentTime)/\(duration))"
	}
	
	var hidesTime: Bool {
		return uid == Player.blankUID
			|| uid == Player.nothingPlayingUID
			|| uid == Player.multipleSourcesUID
	}
	
	var progressString: String {
		return "\(currentTime.asTimeStr)/\(duration.asTimeStr)"
	}
	
	static func == (lhs: Player, rhs: Player) -> Bool {
		return lhs.uid == rhs.uid
	}
}

extension Dictionary where Key == String, Value == Player {
	var asDictArray: [[String: Any]] {
		return self.map { (e) in e.value.asDict }
	}
}

