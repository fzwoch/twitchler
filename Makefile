#
# Twitchler
#
# Copyright (C) 2016-2017 Florian Zwoch <fzwoch@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

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
	/usr/libexec/PlistBuddy -c "Add :CFBundleShortVersionString string \"0.4\"" Twitchler.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c 'Add :NSHumanReadableCopyright string © 2016-2017 Florian Zwoch' Twitchler.app/Contents/Info.plist

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
