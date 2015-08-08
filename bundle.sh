#!/bin/sh

set -e

rm -rf Twitchler.app

mkdir -p Twitchler.app/Contents/MacOS
cp bin/release/twitchler Twitchler.app/Contents/MacOS/.

mkdir -p Twitchler.app/Contents/Frameworks/gstreamer-1.0

TMP=`gst-inspect-1.0 coreelements | grep Filename | awk '{print $2}'`
PLUGINS_DIR=`dirname $TMP`
DST_DIR=Twitchler.app/Contents/Frameworks/gstreamer-1.0

cp $PLUGINS_DIR/libgstapplemedia.so $DST_DIR/.
cp $PLUGINS_DIR/libgstaudioconvert.so $DST_DIR/.
cp $PLUGINS_DIR/libgstaudioparsers.so $DST_DIR/.
cp $PLUGINS_DIR/libgstaudioresample.so $DST_DIR/.
cp $PLUGINS_DIR/libgstcoreelements.so $DST_DIR/.
cp $PLUGINS_DIR/libgstdashdemux.so $DST_DIR/.
cp $PLUGINS_DIR/libgstdeinterlace.so $DST_DIR/.
cp $PLUGINS_DIR/libgstfaad.so $DST_DIR/.
cp $PLUGINS_DIR/libgstfragmented.so $DST_DIR/.
cp $PLUGINS_DIR/libgstlibav.so $DST_DIR/.
cp $PLUGINS_DIR/libgstmpegtsdemux.so $DST_DIR/.
cp $PLUGINS_DIR/libgstopengl.so $DST_DIR/.
cp $PLUGINS_DIR/libgstosxvideosink.so $DST_DIR/.
cp $PLUGINS_DIR/libgstplayback.so $DST_DIR/.
cp $PLUGINS_DIR/libgstsouphttpsrc.so $DST_DIR/.
cp $PLUGINS_DIR/libgsttypefindfunctions.so $DST_DIR/.
cp $PLUGINS_DIR/libgstvideoconvert.so $DST_DIR/.
cp $PLUGINS_DIR/libgstvideofilter.so $DST_DIR/.
cp $PLUGINS_DIR/libgstvideoparsersbad.so $DST_DIR/.
cp $PLUGINS_DIR/libgstvideoscale.so $DST_DIR/.
cp $PLUGINS_DIR/libgstvolume.so $DST_DIR/.

chmod 644 $DST_DIR/*

mkdir -p Twitchler.app/Contents/Resources
cp twitchler.icns Twitchler.app/Contents/Resources/.

/usr/libexec/PlistBuddy -c "Add :CFBundleName string \"Twitchler\"" Twitchler.app/Contents/Info.plist > /dev/null
/usr/libexec/PlistBuddy -c "Add :CFBundleExecutable string \"twitchler\"" Twitchler.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string \"zwoch.florian.twitchler\"" Twitchler.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c 'Add :CFBundleIconFile string "twitchler.icns"' Twitchler.app/Contents/Info.plist

sh fixbundle.sh Twitchler.app `find Twitchler.app/Contents/Frameworks/gstreamer-1.0/ -iname \*.so`
ditto -c -k --keepParent --arch x86_64 Twitchler.app twitchler.zip
