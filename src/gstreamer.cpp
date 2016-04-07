/*
 * Twitchler
 *
 * Copyright (C) 2015-2016 Florian Zwoch <fzwoch@gmail.com>
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

#include "gstreamer.h"
#include "app.h"
#include <gst/player/gstplayer-video-overlay-video-renderer.h>

#ifdef __APPLE__
#import <Foundation/Foundation.h>
#endif

GStreamer::GStreamer()
	: m_player(NULL)
{
	g_setenv("LC_ALL", "en_US.UTF-8", TRUE);
#ifdef _WIN32
	g_setenv("GST_PLUGIN_SYSTEM_PATH", "gstreamer-1.0", TRUE);
#endif
#ifdef __APPLE__
	g_setenv("GST_PLUGIN_SYSTEM_PATH", [[[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Contents/Frameworks/gstreamer-1.0"] UTF8String], TRUE);
#endif
	gst_registry_fork_set_enabled(FALSE);
	gst_init(NULL, NULL);
}

GStreamer::~GStreamer()
{
	StopStream();

	gst_deinit();
}

bool GStreamer::StartStream(const char *url, gpointer window_id, int bitrate, gdouble volume)
{
	if (m_player != NULL)
	{
		StopStream();
	}

	m_player = gst_player_new(gst_player_video_overlay_video_renderer_new((gpointer)window_id), NULL);

	gst_player_set_uri(m_player, url);
	gst_player_set_volume(m_player, volume);
	gst_player_play(m_player);

	return true;
}

void GStreamer::StopStream()
{
	if (m_player == NULL)
	{
		return;
	}

	gst_player_stop(m_player);
	gst_object_unref(m_player);
	m_player = NULL;
}

void GStreamer::SetVolume(gdouble volume)
{
	if (m_player == NULL)
	{
		return;
	}

	gst_player_set_volume(m_player, volume);
}
