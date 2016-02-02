#
# Twitchler
#
# Copyright (C) 2015-2016 Florian Zwoch <fzwoch@gmail.com>
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

!include "MUI2.nsh"

Name "Twitchler"
Outfile "TwitchlerSetup.exe"
InstallDir "$PROGRAMFILES64\Twitchler"

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

Section
	SetOutPath "$INSTDIR"

	File "bin\release\twitchler.exe"
	File "LICENSE"

	File "c:\msys64\mingw64\bin\libstdc++-6.dll"
	File "c:\msys64\mingw64\bin\libgcc_s_seh-1.dll"

	File "c:\msys64\mingw64\bin\wxbase30u_gcc_custom.dll"
	File "c:\msys64\mingw64\bin\wxmsw30u_core_gcc_custom.dll"
	File "c:\msys64\mingw64\bin\liblzma-5.dll"
	File "c:\msys64\mingw64\bin\libtiff-5.dll"
	File "c:\msys64\mingw64\bin\zlib1.dll"

	File "c:\gstreamer\1.0\x86_64\bin\libbz2.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libfaad-2.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libffi-6.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgio-2.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libglib-2.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgmodule-2.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgobject-2.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgraphene-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstadaptivedemux-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstaudio-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstbadbase-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstbadvideo-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstbase-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstcodecparsers-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstgl-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstnet-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstmpegts-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstpbutils-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstreamer-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgsttag-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgsturidownloader-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libgstvideo-1.0-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libiconv-2.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libintl-8.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libjpeg-8.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libnettle-4-7.dll"
	File "c:\gstreamer\1.0\x86_64\bin\liborc-0.4-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\liborc-test-0.4-0.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libpng16-16.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libsoup-2.4-1.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libwinpthread-1.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libxml2-2.dll"
	File "c:\gstreamer\1.0\x86_64\bin\libz.dll"
	
	File "c:\msys64\mingw64\bin\libjson-glib-1.0-0.dll"

	SetShellVarContext "all"

	CreateDirectory "$SMPROGRAMS\Twitchler"
	CreateShortCut  "$SMPROGRAMS\Twitchler\Twitchler.lnk" "$INSTDIR\twitchler.exe"
	CreateShortCut  "$SMPROGRAMS\Twitchler\Uninstall.lnk" "$INSTDIR\uninstall.exe"

	WriteUninstaller "$INSTDIR\uninstall.exe"

	SetOutPath "$INSTDIR\gstreamer-1.0"

	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstaudioconvert.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstaudioparsers.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstaudioresample.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstcoreelements.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstd3dvideosink.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstdashdemux.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstdeinterlace.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstdirectsoundsink.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstfaad.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstfragmented.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstlibav.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstmpegtsdemux.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstopengl.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstplayback.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstsouphttpsrc.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgsttypefindfunctions.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstvideoconvert.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstvideofilter.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstvideoparsersbad.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstvideoscale.dll"
	File "c:\gstreamer\1.0\x86_64\lib\gstreamer-1.0\libgstvolume.dll"
SectionEnd

Section "Uninstall"
	SetShellVarContext "all"

	RMDir /r "$SMPROGRAMS\Twitchler"
	RMDir /r "$INSTDIR"
SectionEnd
