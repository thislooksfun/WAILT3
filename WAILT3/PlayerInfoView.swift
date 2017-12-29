//
//  ScrollingTextView.swift
//  WAILT3
//
//  Created by thislooksfun on 12/26/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Cocoa

class PlayerInfoView: NSView, NSMenuDelegate {
	
	// MARK: - Settings -
	
	var timeBetweenScrolls: TimeInterval = 3
	var gapWidth: CGFloat = 20
	var marginWidth: CGFloat = 5
	
	var maxWidth: CGFloat = 300 {
		didSet { sizeToFit() }
	}
	
	
	// MARK: - Private Variables -
	
	private var player = Player.blank
	private var mainTextOffset: CGFloat = 0
	private var scrolling = false
	private var lastScrollEnd = Date()
	private let font = NSFont.systemFont(ofSize: 14)
	
	
	// MARK: - Computed Properties -
	
	private var effectiveMaxWidth: CGFloat {
		return maxWidth - marginWidth*2
	}
	private var willScroll: Bool {
		return width(of: player) > effectiveMaxWidth
	}
	private var secondTextOffset: CGFloat {
		return mainTextOffset + gapWidth + width(of: player.title)
	}
	
	
	// MARK: - Set Player -
	
	func setPlayer(_ p: Player) {
		print("setPlayer(\(p))")
		
		let titleChanged = p.title != player.title
		
		if p == player {
			if p.lastUpdated > player.lastUpdated {
				player = p
			}
		} else {
			player = p
		}
		
		if titleChanged {
			mainTextOffset = marginWidth
			scrolling = false
			lastScrollEnd = Date()
		}
		
		sizeToFit()
		self.needsDisplay = true
	}
	
	
	// MARK: - Timer -
	private var timer: Timer?
	
	func startTimer() {
		guard timer == nil else { return }
		timer = Timer(timeInterval: 1/60, repeats: true, block: onTimer(_:))
		RunLoop.main.add(timer!, forMode: .commonModes)
	}
	func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	func onTimer(_ t: Timer) {
		guard willScroll else {
			mainTextOffset = marginWidth
			return
		}
		
		if scrolling {
			mainTextOffset -= 0.5
			if secondTextOffset <= marginWidth {
				// Scrolling finished
				lastScrollEnd = Date()
				mainTextOffset = marginWidth
				scrolling = false
			}
			
			self.needsDisplay = true
		} else {
			if lastScrollEnd.timeIntervalToNow > timeBetweenScrolls {
				scrolling = true
				self.needsDisplay = true
			}
		}
	}
	
	
	// MARK: - Sizing -
	
	private func height(of s: String) -> CGFloat {
		return NSString(string: s).size(withAttributes: [.font: font]).height
	}
	private func width(of s: String) -> CGFloat {
		return NSString(string: s).size(withAttributes: [.font: font]).width
	}
	private func width(of p: Player) -> CGFloat {
		if p.hidesTime { return width(of: p.title) }
		return width(of: p.title) + marginWidth + width(of: p.progressString)
	}
	
	func sizeToFit() {
		self.frame.size.width = min(effectiveMaxWidth, width(of: player)) + marginWidth*2
		
		if willScroll {
			startTimer()
		} else {
			stopTimer()
		}
	}
	
	
	// MARK: - NSMenuDelegate -
	
	private var menuIsShowing = false
	var statusItem: NSStatusItem?
	
	func menuWillOpen(_ menu: NSMenu) {
		menuIsShowing = true
		self.needsDisplay = true
	}
	func menuDidClose(_ menu: NSMenu) {
		menuIsShowing = false
		self.needsDisplay = true
	}
	
	
	// MARK: - Click Handling -
	
	override func mouseDown(with event: NSEvent) {
		guard let st = statusItem else { return }
		guard let m = st.menu else { return }
		m.delegate = self
		st.popUpMenu(m)
		self.needsDisplay = true
	}
	override func rightMouseDown(with event: NSEvent) {
		mouseDown(with: event)
	}
	
	
	// MARK: - Rendering -
	
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		
		if menuIsShowing {
			NSColor.selectedMenuItemColor.setFill()
			dirtyRect.fill()
		}
		
		if player.hidesTime {
			drawTitle(in: dirtyRect, withTimeWidth: 0)
		} else {
			let timeWidth = drawTime(in: dirtyRect)
			drawTitle(in: dirtyRect, withTimeWidth: timeWidth)
		}
	}
	
	
	// Returns the bounds taken up by the time string
	func drawTime(in r: NSRect) -> CGFloat {
		let timeString = player.progressString
		
		// Calculate bounds for time
		let timeWidth = width(of: timeString) + marginWidth*2
		let origin = NSPoint(x: r.origin.x + r.width - timeWidth, y: r.origin.y)
		let size = NSSize(width: timeWidth, height: r.height)
		let timeRect = NSRect(origin: origin, size: size)
		
		// Draw
		draw(string: timeString, withOffset: marginWidth, inRect: timeRect)
		
		return timeWidth
	}
	
	
	func drawTitle(in r: NSRect, withTimeWidth tw: CGFloat) {
		// Calculate bounds for title
		let origin = r.origin
		let size = NSSize(width: r.width - tw, height: r.height)
		let titleRect = NSRect(origin: origin, size: size)
		
		// Draw title
		draw(string: player.title, withOffset: mainTextOffset, inRect: titleRect)
		if scrolling {
			draw(string: player.title, withOffset: secondTextOffset, inRect: titleRect)
		}
	}
	
	
	func draw(string s: String, withOffset os: CGFloat, inRect r: NSRect) {
		let point = NSPoint(x: os + r.origin.x, y: 3)  // magic 3 ; TODO: make dynamic?
		
		NSGraphicsContext.current?.saveGraphicsState()
		defer { NSGraphicsContext.current?.restoreGraphicsState() }
		
		r.clip()
		
		let tc = menuIsShowing ? NSColor.selectedMenuItemTextColor : NSColor.textColor
		NSString(string: s).draw(at: point, withAttributes: [.font: font, .foregroundColor: tc])
	}
}
