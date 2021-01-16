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
		var request = URLRequest(url: URL(string: "https://gql.twitch.tv/gql")!)
		request.httpMethod = "POST";
		request.addValue("kimne78kx3ncx6brgo4mv6wki5h1ko", forHTTPHeaderField: "Client-ID")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type");
		let json = "{\"operationName\": \"PlaybackAccessToken\",\"extensions\": {\"persistedQuery\": {\"version\": 1,\"sha256Hash\": \"0828119ded1c13477966434e15800ff57ddacf13ba1911c129dc2200705b0712\"}},\"variables\": {\"isLive\": true,\"login\": \"" + url!.host! + "\",\"isVod\": false,\"vodID\": \"\",\"playerType\": \"embed\"}}";
		let task = URLSession.shared.uploadTask(with: request, from: Data(json.utf8)) { data, response, error in
			struct X : Decodable {
				struct XX : Decodable {
					struct XXX : Decodable {
						let signature:String
						let value:String
					}
					let streamPlaybackAccessToken:XXX
				}
				let data:XX
			}
			let json = try! JSONDecoder().decode(X.self, from: data!)
			let playlist: String = "http://usher.twitch.tv/api/channel/hls/" + url!.host! + ".m3u8?player=twitchweb&token=" + (json.data.streamPlaybackAccessToken.value) + "&sig=" + (json.data.streamPlaybackAccessToken.signature) + "&allow_audio_only=true&allow_source=true&type=any&p=" + String(arc4random_uniform(99999999))
			let quicktime: QuickTimePlayerX = SBApplication(bundleIdentifier: "com.apple.QuickTimePlayerX")!;
			let app: SBApplication = quicktime as! SBApplication
			app.activate()
			quicktime.openURL!(playlist.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
		}
		task.resume();
	}
}

let app = NSApplication.shared
let delegate = AppDelegate()

app.delegate = delegate
app.run()
