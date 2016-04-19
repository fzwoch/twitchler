all:
	mkdir -p Twitchler.app/Contents/MacOS
	mkdir -p Twitchler.app/Contents/Resources
	cp twitchler.icns Twitchler.app/Contents/Resources/twitchler.icns
	swiftc -sdk $(shell xcrun --show-sdk-path --sdk macosx) twitchler.swift -o Twitchler.app/Contents/MacOS/twitchler
	strip -x Twitchler.app/Contents/MacOS/twitchler

	rm -f Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleName string \"Twitchler\"" Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleExecutable string \"twitchler\"" Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string \"zwoch.florian.twitchler\"" Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :NSHighResolutionCapable bool YES" Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c 'Add :CFBundleIconFile string "twitchler.icns"' Twitchler.app/Contents/Info.plist

	/usr/libexec/PlistBuddy -c "Add :NSAppTransportSecurity dict" Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :NSAppTransportSecurity:NSAllowsArbitraryLoads bool YES" Twitchler.app/Contents/Info.plist

	/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes array" Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0 dict" Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLName string Twitch" Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes array" Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes:0 string twitch" Twitchler.app/Contents/Info.plist

	ditto -c -k --keepParent --arch x86_64 Twitchler.app twitchler.zip

clean:
	rm -rf Twitchler.app twitchler.zip
