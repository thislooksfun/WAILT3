//
//  ScrollingTextView.swift
//  WAILT3
//
//  Created by thislooksfun on 12/26/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Cocoa

class ScrollingTextView: NSView, NSMenuDelegate {
	
	// MARK: - Settings -
	
	var textColor: NSColor = .black
	
	var lastScrollEnd = Date()
	
	var timeBetweenScrolls: TimeInterval = 3
	var gapWidth: CGFloat = 10
	var marginWidth: CGFloat = 5
	
	var maxWidth: CGFloat = 100
	
	
	// MARK: - Private Variables -
	
	private var mainText = ""
	private var secondText = ""
	private var nextText: String?
	
	private var mainTextOffset: CGFloat = 0
	private var targetWidth: CGFloat = 0
	
	private var scrolling = false
	private var resizing = false
	
	private let font = NSFont.systemFont(ofSize: 14)
	
	
	// MARK: - Computed Properties -
	
	private var effectiveMaxWidth: CGFloat {
		return maxWidth - marginWidth*2
	}
	private var willScroll: Bool {
		return width(of: mainText) > effectiveMaxWidth
	}
	private var secondTextOffset: CGFloat {
		return mainTextOffset + gapWidth + width(of: mainText)
	}
	
	
	// MARK: - Set Text -
	
	func setText(_ s: String, animated: Bool = true) {
		if animated {
			nextText = s
			startTimer()
		} else {
			mainText = s
			mainTextOffset = marginWidth
			scrolling = false
			
			if willScroll {
				startTimer()
			} else {
				stopTimer()
			}
		}
		
		self.sizeToFit(s, animated: animated)
		self.needsDisplay = true
	}
	
	
	// MARK: - Timer -
	private var timer: Timer?
	
	func startTimer() {
		timer ?= Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true, block: onTimer(_:))
	}
	func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	func onTimer(_ t: Timer) {
		guard willScroll || nextText != nil else {
			mainTextOffset = marginWidth
			return
		}
		
		if scrolling {
			mainTextOffset -= 0.5
			if resizing {
				let sizeStep: CGFloat = 1
				if targetWidth > self.frame.size.width {
					self.frame.size.width += sizeStep
					mainTextOffset += sizeStep
				} else {
					self.frame.size.width -= sizeStep
					mainTextOffset -= sizeStep
				}
				
				if abs(targetWidth - self.frame.size.width) <= sizeStep {
					self.frame.size.width = targetWidth
					resizing = false
				}
			}
			if secondTextOffset <= marginWidth {
				// Scrolling finished
				lastScrollEnd = Date()
				mainTextOffset = marginWidth
				mainText = secondText
				nextText = nil
				scrolling = false
			}
			
			self.needsDisplay = true
		} else {
			if lastScrollEnd.timeIntervalToNow > timeBetweenScrolls || nextText != nil {
				secondText = nextText ?? mainText
				scrolling = true
				resizing = targetWidth != self.frame.size.width
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
	
	func sizeToFit(_ text: String, animated: Bool) {
		targetWidth = min(effectiveMaxWidth, width(of: text)) + marginWidth*2
		if !animated {
			self.frame.size.width = targetWidth
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
		
		draw(string: mainText, withOffset: mainTextOffset)
		if scrolling {
			draw(string: secondText, withOffset: secondTextOffset)
		}
	}
	
	func draw(string s: String, withOffset os: CGFloat) {
		let point = NSPoint(x: os, y: 3)  // magic 3 ; TODO: make dynamic?
		
		let tc = menuIsShowing ? NSColor.selectedMenuItemTextColor : NSColor.textColor
		NSString(string: s).draw(at: point, withAttributes: [.font: font, .foregroundColor: tc])
	}
}
