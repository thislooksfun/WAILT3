//
//  Player.swift
//  WAILT3
//
//  Created by thislooksfun on 12/25/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Foundation

struct Player: CustomDebugStringConvertible {
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
		
		self.uid = uid
		self.title = title
		self.currentTime = currentTime
		self.duration = duration
		
		let lu = dict["lastUpdated"] as? Date
		self.lastUpdated = lu ?? Date()
	}
	
	var asDict: [String: Any] {
		return ["uid": uid, "title": title, "currentTime": currentTime, "duration": duration, "lastUpdated": lastUpdated]
	}
	
	var debugDescription: String {
		return "\(title) (\(currentTime)/\(duration))"
	}
}

extension Dictionary where Key == String, Value == Player {
	var asDictArray: [[String: Any]] {
		return self.map { (e) in e.value.asDict }
	}
}

