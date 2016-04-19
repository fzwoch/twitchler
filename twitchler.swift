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
			let playlist: String = "http://usher.twitch.tv/api/channel/hls/" + "rocketbeanstv" + ".m3u8?player=twitchweb&token=" + (token["token"] as! String) + "&sig=" + (token["sig"] as! String) + "&allow_audio_only=true&allow_source=true&type=any&p=0"
			let quicktime = SBApplication(bundleIdentifier: "com.apple.QuickTimePlayerX")!;
			quicktime.activate()
			(quicktime as QuickTimePlayerX).openURL!(playlist.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
		} catch {
		}
	}
}

let app = NSApplication.sharedApplication()
let delegate = AppDelegate()

app.setActivationPolicy(.Regular)
app.activateIgnoringOtherApps(true)
app.delegate = delegate
app.run()
