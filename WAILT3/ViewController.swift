//
//  ViewController.swift
//  WAILT3
//
//  Created by thislooksfun on 12/24/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet var lab: NSTextFieldCell!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		StorageHandler.shared.addObserver { (players) in
			var text = "# of items: \(players.count)"
			
			for p in players {
				text += "\n\(p.value)"
			}
			
			self.lab.title = text
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}
