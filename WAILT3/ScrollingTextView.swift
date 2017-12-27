////
//  ScrollingTextView.swift
//  WAILT3
//
//  Created by thislooksfun on 12/26/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Cocoa

class ScrollingTextView: NSView {
	
	override func draw(_ dirtyRect: NSRect) {
		NSColor.red.setFill()
		dirtyRect.fill()
		self.frame.size.width += 0.1
	}
	
}
