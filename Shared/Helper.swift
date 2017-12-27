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


// MARK: - Operators

infix operator ?= : AssignmentPrecedence
func ?= <T> (lhs: inout T?, rhs: @autoclosure ()->T) {
	if lhs == nil {
		lhs = rhs()
	}
}
