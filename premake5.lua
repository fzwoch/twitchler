--
-- Twitchler
--
-- Copyright (C) 2015 Florian Zwoch <fzwoch@gmail.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program. If not, see <http://www.gnu.org/licenses/>.
--

solution "Twitchler"
	configurations { "debug", "release" }

	configuration "debug"
		flags "symbols"

	configuration "release"
		optimize "full"

	configuration "windows"
		toolset "msc"
		architecture "x86"
		flags "unicode"

	configuration "macosx"
		toolset "clang"
		architecture "x86_64"

	project "twitchler"
		kind "WindowedApp"
		language "C++"
		files "src/*.cpp"
		includedirs "include"

		configuration "windows"
			defines { "WXUSINGDLL", "wxMSVC_VERSION_AUTO", "_CRT_SECURE_NO_WARNINGS", "WXMAKINGDLL_JSON" }
			includedirs { "C:/wxWidgets/include/msvc", "C:/wxWidgets/include" }
			includedirs { "C:/GStreamer/1.0/x86/include/gstreamer-1.0", "C:/GStreamer/1.0/x86/include/glib-2.0" }
			includedirs { "C:/GStreamer/1.0/x86/lib/gstreamer-1.0/include", "C:/GStreamer/1.0/x86/lib/glib-2.0/include" }
			libdirs { "C:/wxWidgets/lib/vc120_dll", "C:/GStreamer/1.0/x86/lib" }
			links { "gmodule-2.0.lib", "gio-2.0.lib", "gstvideo-1.0.lib", "glib-2.0.lib", "gstreamer-1.0.lib", "gobject-2.0.lib" }

		configuration "macosx"
			buildoptions { "`wx-config --cflags`", "`pkg-config --cflags gstreamer-1.0 gstreamer-video-1.0`" }
			linkoptions { "`wx-config --libs`", "`pkg-config --libs gstreamer-1.0 gstreamer-video-1.0`" }