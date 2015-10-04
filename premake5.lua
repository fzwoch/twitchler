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

	filter "configurations:debug"
		flags "symbols"

	filter "configurations:release"
		defines "NDEBUG"
		optimize "full"

	filter "system:windows"
		toolset "msc"
		architecture "x86"
		flags "unicode"

	filter "system:macosx"
		toolset "clang"
		architecture "x86_64"

	project "twitchler"
		kind "WindowedApp"
		language "C++"
		files { "src/**.cpp", "include/**.h" }
		includedirs "include"

		local wx_config_cflags
		local wx_config_libs
		local pkg_config_cflags
		local pkg_config_libs

		if (os.get() == "macosx") then
			wx_config_cflags = os.outputof("wx-config --cflags")
			wx_config_libs = os.outputof("wx-config --libs")

			pkg_config_cflags = os.outputof("pkg-config --cflags gstreamer-1.0 gstreamer-video-1.0 libsoup-2.4 json-glib-1.0")
			pkg_config_libs = os.outputof("pkg-config --libs gstreamer-1.0 gstreamer-video-1.0 libsoup-2.4 json-glib-1.0")
		end

		if (os.get() == "linux") then
			wx_config_cflags = os.outputof("wx-config --cflags")
			wx_config_libs = os.outputof("wx-config --libs")

			pkg_config_cflags = os.outputof("pkg-config --cflags gstreamer-1.0 gstreamer-video-1.0 libsoup-2.4 json-glib-1.0 gtk+-2.0")
			pkg_config_libs = os.outputof("pkg-config --libs gstreamer-1.0 gstreamer-video-1.0 libsoup-2.4 json-glib-1.0 gtk+-2.0")
		end

		filter "system:windows"
			files "*.rc"
			defines { "WXUSINGDLL", "wxMSVC_VERSION_AUTO", "_CRT_SECURE_NO_WARNINGS", "WXMAKINGDLL_JSON", "WXMAKINGDLL_WXCURL" }
			includedirs { "C:/wxWidgets/include/msvc", "C:/wxWidgets/include" }
			includedirs { "C:/GStreamer/1.0/x86/include/gstreamer-1.0", "C:/GStreamer/1.0/x86/include/glib-2.0" }
			includedirs { "C:/GStreamer/1.0/x86/lib/gstreamer-1.0/include", "C:/GStreamer/1.0/x86/lib/glib-2.0/include" }
			includedirs { "C:/curl/include" }
			libdirs { "C:/wxWidgets/lib/vc120_dll", "C:/GStreamer/1.0/x86/lib", "C:/curl/lib" }
			links { "gmodule-2.0.lib", "gio-2.0.lib", "gstvideo-1.0.lib", "glib-2.0.lib", "gstreamer-1.0.lib", "gobject-2.0.lib" }
			links { "libcurldll.lib" }

		filter "system:macosx"
			buildoptions { (wx_config_cflags), (pkg_config_cflags), "-x objective-c++" }
			linkoptions { (wx_config_libs), (pkg_config_libs), "-headerpad_max_install_names" }

		filter "system:linux"
			buildoptions { (wx_config_cflags), (pkg_config_cflags) }
			linkoptions { (wx_config_libs), (pkg_config_libs) }
