/*
 * Twitchler
 *
 * Copyright (C) 2016 Florian Zwoch <fzwoch@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import Cocoa
import ScriptingBridge

@objc protocol QuickTimePlayerX {
	optional func openURL(url: String) -> Void
}

extension SBApplication : QuickTimePlayerX {}

class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationWillFinishLaunching(notification: NSNotification) {
		let manager = NSAppleEventManager.sharedAppleEventManager()
		manager.setEventHandler(self, andSelector: #selector(handleGetURLEvent(_:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
	}

	func handleGetURLEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) -> Void {
		let url = NSURL(string: event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))!.stringValue!)
		let data = NSData(contentsOfURL: NSURL(string: "http://api.twitch.tv/api/channels/" + url!.host! + "/access_token")!)

		do {
			let token = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
			let playlist: String = "http://usher.twitch.tv/api/channel/hls/" + url!.host! + ".m3u8?player=twitchweb&token=" + (token["token"] as! String) + "&sig=" + (token["sig"] as! String) + "&allow_audio_only=true&allow_source=true&type=any&p=0"
			let quicktime: QuickTimePlayerX = SBApplication(bundleIdentifier: "com.apple.QuickTimePlayerX")!;
			quicktime.openURL!(playlist.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
		} catch {
		}
	}
}

let app = NSApplication.sharedApplication()
let delegate = AppDelegate()

app.delegate = delegate
app.run()
