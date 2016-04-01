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
#include <gst/video/videooverlay.h>

#ifdef __APPLE__
#import <Foundation/Foundation.h>
#endif

static GstBusSyncReply bus_callback(GstBus *bus, GstMessage *msg, gpointer data)
{
	GError *err = NULL;
	
	switch (GST_MESSAGE_TYPE(msg))
	{
		case GST_MESSAGE_WARNING:
			gst_message_parse_warning(msg, &err, NULL);
			g_warning("%s", err->message);
			g_error_free(err);
			break;
		case GST_MESSAGE_ERROR:
			gst_bus_set_sync_handler(bus, NULL, NULL, NULL);
			gst_message_parse_error(msg, &err, NULL);
			wxTheApp->CallAfter(&myApp::OnGStreamerError, err);
			break;
		case GST_MESSAGE_EOS:
			wxTheApp->CallAfter(&myApp::OnGStreamerEos);
			break;
		default:
			break;
	}
	
	return GST_BUS_DROP;
}

GStreamer::GStreamer()
	: m_pipeline(NULL)
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

bool GStreamer::StartStream(const char *url, guintptr window_id, int bitrate, gdouble volume)
{
	GError *err = NULL;
	GstBus *bus;
	GString *description = g_string_new(NULL);
	
	if (m_pipeline != NULL)
	{
		StopStream();
	}
	
	g_string_printf(description, "playbin uri=\"%s\" connection-speed=%d volume=%f", url, bitrate, volume);
	
	m_pipeline = gst_parse_launch(description->str, &err);
	
	g_string_free(description, TRUE);
	
	if (err)
	{
		g_error_free(err);
		
		if (m_pipeline)
		{
			gst_object_unref(m_pipeline);
			m_pipeline = NULL;
		}
		
		return false;
	}
	
	gst_video_overlay_set_window_handle(GST_VIDEO_OVERLAY(m_pipeline), window_id);
	
	bus = gst_pipeline_get_bus(GST_PIPELINE(m_pipeline));
	gst_bus_set_sync_handler(bus, bus_callback, NULL, NULL);
	gst_object_unref(bus);
	
	gst_element_set_state(m_pipeline, GST_STATE_PLAYING);
	
	return true;
}

void GStreamer::StopStream()
{
	if (m_pipeline == NULL)
	{
		return;
	}
	
	gst_element_set_state(m_pipeline, GST_STATE_NULL);
	
	gst_object_unref(m_pipeline);
	m_pipeline = NULL;
}

void GStreamer::SetVolume(gdouble volume)
{
	if (m_pipeline == NULL)
	{
		return;
	}

	g_object_set(m_pipeline, "volume", volume, NULL);
}
