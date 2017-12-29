//
//  Helper.swift
//  WAILT3
//
//  Created by thislooksfun on 12/25/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Foundation

// MARK: - Extensions

extension Array {
	func all<T>(_ t: T) where Element == ((T) -> Void) {
		for f in self { f(t) }
	}
}

extension Date {
	var timeIntervalToNow: TimeInterval {
		return -timeIntervalSinceNow
	}
}

extension TimeInterval {
	var asTimeStr: String {
		if isNaN {
			return "NaN"
		}
		
		let hours = Int(self / (60 * 60))
		let minutes = Int((self / 60).truncatingRemainder(dividingBy: 60))
		let seconds = Int(self.truncatingRemainder(dividingBy: 60))
		
		if hours > 0 {
			return String(format: "%i:%02i:%02i", hours, minutes, seconds)
		}
		return String(format: "%i:%02i", minutes, seconds)
	}
}

// MARK: - Operators

infix operator ?= : AssignmentPrecedence
func ?= <T> (lhs: inout T?, rhs: @autoclosure ()->T) {
	if lhs == nil {
		lhs = rhs()
	}
}
