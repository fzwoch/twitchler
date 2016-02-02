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

#include "app.h"

#include <libsoup/soup.h>
#include <json-glib/json-glib.h>

#ifdef __WXGTK__
	#include <gtk/gtk.h>
	#include <gdk/gdkx.h>
#endif

bool myApp::OnInit()
{
	m_frame = new myFrame();
	
	m_frame->Show();
	
	return true;
}

int myApp::FilterEvent(wxEvent &event)
{
	if (event.GetEventType() == wxEVT_KEY_DOWN && ((wxKeyEvent&)event).GetKeyCode() == WXK_ESCAPE)
	{
		if (m_frame->IsFullScreen())
		{
			m_frame->OnToggleFullScreen(event);
		}
		
		return true;
	}
	
	return -1;
}

void myApp::OnGetStreamingUrl(wxCommandEvent &event)
{
	SoupSession *http;
	SoupMessage *http_msg;
	JsonParser *parser;
	JsonReader *reader;
	char *random;
	char *token;
	const char *sig;
	
	wxString channel = m_frame->GetChannelName().Lower();
	
	if (channel.IsEmpty())
	{
		wxLogMessage("Please enter a channel name");
		return;
	}
	
	http = soup_session_new_with_options(SOUP_SESSION_TIMEOUT, 5, NULL);
	http_msg = soup_message_new("GET", "http://api.twitch.tv/api/channels/" + channel + "/access_token");
	
	if (soup_session_send_message(http, http_msg) != 200)
	{
		g_object_unref(http);
		g_object_unref(http_msg);
		
		wxLogError("Could not get access token for channel '" + channel + "'");
		return;
	}
	
	parser = json_parser_new();
	
	json_parser_load_from_data(parser, http_msg->response_body->data, -1, NULL);
	reader = json_reader_new(json_parser_get_root(parser));
	
	json_reader_read_member(reader, "token");
	token = g_uri_escape_string(json_reader_get_string_value(reader), NULL, TRUE);
	json_reader_end_member(reader);
	
	json_reader_read_member(reader, "sig");
	sig = json_reader_get_string_value(reader);
	json_reader_end_member(reader);

	random = g_strdup_printf("%d", g_random_int_range(1, 99999999));

#ifdef __WXGTK__
	guintptr window_id = GDK_WINDOW_XID(gtk_widget_get_window(myFrame::FindWindowByName("video")->GetHandle()));
#else
	guintptr window_id = (guintptr)myFrame::FindWindowByName("video")->GetHandle();
#endif
	
	bool res = m_gstreamer.StartStream("http://usher.twitch.tv/api/channel/hls/" + channel + ".m3u8?player=twitchweb&token=" + token + "&sig=" + sig + "&allow_audio_only=true&allow_source=true&type=any&p=" + random, window_id, m_frame->GetBitrate(), m_frame->GetVolume() / 1000.0);
	
	g_object_unref(http);
	g_object_unref(http_msg);
	
	g_free(token);
	g_free(random);
	
	g_object_unref(reader);
	g_object_unref(parser);
	
	if (res == false)
	{
		wxLogError("Could not start stream for channel '" + channel + "'");
		return;
	}
}

void myApp::OnVolumeSlider(wxScrollEvent &event)
{
	m_gstreamer.SetVolume(event.GetPosition() / 1000.0);
}

void myApp::OnGStreamerError(GError *err)
{
	m_gstreamer.StopStream();
	
	wxLogError(wxString(err->message));
	
	g_error_free(err);
}

void myApp::OnGStreamerEos()
{
	m_gstreamer.StopStream();
	
	wxLogMessage("Stream went offline");
}

void myApp::OnCloseEvent(wxCloseEvent &event)
{
	m_gstreamer.StopStream();
	
	m_frame->Destroy();
}

int main(int argc, char *argv[])
{
	wxDISABLE_DEBUG_SUPPORT();

	myApp *app = new myApp();
	wxApp::SetInstance(app);
	wxEntry(argc, argv);
	
	return 0;
}
