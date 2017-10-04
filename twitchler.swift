/*
 * Twitchler
 *
 * Copyright (C) 2016-2017 Florian Zwoch <fzwoch@gmail.com>
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
	@objc optional func openURL(_ url: String) -> Void
}

extension SBApplication : QuickTimePlayerX {}

class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationWillFinishLaunching(_ notification: Notification) {
		let manager = NSAppleEventManager.shared()
		manager.setEventHandler(self, andSelector: #selector(handleGetURLEvent(_:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))

		app.mainMenu = NSMenu()
		app.mainMenu!.addItem(withTitle: "Application", action: nil, keyEquivalent: "")

		let menu = NSMenu()
		menu.title = "Twitchler"
		menu.addItem(withTitle: "About Twitchler", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
		menu.addItem(NSMenuItem.separator())
		menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

		app.mainMenu!.item(withTitle: "Application")!.submenu = menu
	}

	@objc func handleGetURLEvent(_ event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) -> Void {
		let url = URL(string: event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!.lowercased())
		var request = URLRequest(url: URL(string: "https://api.twitch.tv/api/channels/" + url!.host! + "/access_token")!)
		request.addValue("7ikopbkspr7556owm9krqmalvr2w0i4", forHTTPHeaderField: "Client-ID")
		var response: URLResponse?
		let data = try! NSURLConnection.sendSynchronousRequest(request, returning: &response)
		let token = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [String:Any]
		let playlist: String = "http://usher.twitch.tv/api/channel/hls/" + url!.host! + ".m3u8?player=twitchweb&token=" + (token["token"]  as! String) + "&sig=" + (token["sig"] as! String) + "&allow_audio_only=true&allow_source=true&type=any&p=" + String(arc4random_uniform(99999999))
		let quicktime: QuickTimePlayerX = SBApplication(bundleIdentifier: "com.apple.QuickTimePlayerX")!;
		let app: SBApplication = quicktime as! SBApplication
		app.activate()
		quicktime.openURL!(playlist.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
	}
}

let app = NSApplication.shared
let delegate = AppDelegate()

app.delegate = delegate
app.run()
