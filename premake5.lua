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

	filter "system:macosx"
		toolset "clang"

	project "twitchler"
		kind "WindowedApp"
		language "C++"
		files { "src/*.cpp", "include/*.h" }
		includedirs "include"

		filter "system:macosx"
			buildoptions { "`wx-config --cflags`", "`PKG_CONFIG_DIR=/Library/Frameworks/GStreamer.framework/Libraries/pkgconfig/ pkg-config --cflags gstreamer-1.0 gstreamer-video-1.0 libsoup-2.4 json-glib-1.0`", "-x objective-c++" }
			linkoptions { "`wx-config --libs`", "`PKG_CONFIG_DIR=/Library/Frameworks/GStreamer.framework/Libraries/pkgconfig/ pkg-config --libs gstreamer-1.0 gstreamer-video-1.0 libsoup-2.4 json-glib-1.0`", "-headerpad_max_install_names" }

		filter "system:linux"
			buildoptions { "`wx-config --cflags`", "`pkg-config --cflags gstreamer-1.0 gstreamer-video-1.0 libsoup-2.4 json-glib-1.0 gtk+-2.0`" }
			linkoptions { "`wx-config --libs`", "`pkg-config --libs gstreamer-1.0 gstreamer-video-1.0 libsoup-2.4 json-glib-1.0 gtk+-2.0`" }

		filter "system:windows"
			files "*.rc"
			resincludedirs "/mingw64/include/wx-3.0"
			buildoptions { "`wx-config --cflags`", "`PKG_CONFIG_PATH=/c/gstreamer/1.0/x86_64/lib/pkgconfig pkg-config --cflags gstreamer-1.0 gstreamer-video-1.0 libsoup-2.4 json-glib-1.0`" }
			linkoptions { "`wx-config --libs`", "`PKG_CONFIG_PATH=/c/gstreamer/1.0/x86_64/lib/pkgconfig pkg-config --libs gstreamer-1.0 gstreamer-video-1.0 libsoup-2.4 json-glib-1.0`", "-static-libgcc", "-static-libstdc++" }
