/*
 * Twitchler
 *
 * Copyright (C) 2015 Florian Zwoch <fzwoch@gmail.com>
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

#ifdef MIN
#undef MIN
#endif

#ifdef MAX
#undef MAX
#endif

#include <wx/curl/http.h>

#include <wx/protocol/http.h>
#include <wx/jsonreader.h>

#ifdef __WXGTK__
#include <gtk/gtk.h>
#include <gdk/gdkx.h>
#endif

bool myApp::OnInit()
{
	m_frame = new myFrame();
	
	m_frame->Show();
	
	srand(time(NULL));
	
	wxCurlBase::Init();
	
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
	wxCurlHTTP http_info;
	wxCurlHTTP http;
	char *buffer;
	wxJSONReader parser;
	wxJSONValue json;
	wxString random;
	wxString token;
	
	http_info.SetOpt(CURLOPT_TIMEOUT, 5);
	http.SetOpt(CURLOPT_TIMEOUT, 5);
	
	wxString channel = m_frame->GetChannelName();
	
	if (channel.IsEmpty())
	{
		wxLogMessage("Please enter a channel name");
		return;
	}
	
	http_info.Get(buffer, "https://api.twitch.tv/kraken/streams/" + channel);
	
	if (http_info.GetResponseCode() != 200)
	{
		wxLogError("Could not retrieve stream information for channel '" + channel + "'");
		return;
	}
	
	if (parser.Parse(wxString(buffer), &json) > 0)
	{
		free(buffer);
		
		wxLogError("Could not parse JSON stream information for channel '" + channel + "'");
		return;
	}
	
	free(buffer);
	
	if (json["stream"].IsNull())
	{
		wxLogMessage("Channel '" + channel + "' is offline");
		return;
	}
	
	http.Get(buffer, "http://api.twitch.tv/api/channels/" + channel + "/access_token");
	
	if (http.GetResponseCode() != 200)
	{
		wxLogError("Could not get access token for channel '" + channel + "'");
		return;
	}
	
	if (parser.Parse(wxString(buffer), &json) > 0)
	{
		free(buffer);
		
		wxLogError("Could not parse JSON access token for channel '" + channel + "'");
		return;
	}
	
	free(buffer);
	
	random = wxString::Format("%d", rand() % 999999);
	token = json["token"].AsString();
	
	token.Replace(":", "%3a");
	token.Replace(",", "%2c");
	token.Replace("\"", "%22");
	token.Replace("{", "%7b");
	token.Replace("}", "%7d");
	
#ifdef __WXGTK__
	guintptr window_id = GDK_WINDOW_XID(gtk_widget_get_window(myFrame::FindWindowByName("video")->GetHandle()));
#else
	guintptr window_id = (guintptr)myFrame::FindWindowByName("video")->GetHandle();
#endif
	
	bool res = m_gstreamer.StartStream("http://usher.twitch.tv/api/channel/hls/" + channel + ".m3u8?player=twitchweb&token=" + token + "&sig=" + json["sig"].AsString() + "&allow_audio_only=true&allow_source=true&type=any&p=" + random, window_id, m_frame->GetBitrate(), m_frame->GetVolume() / 1000.0);
	
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
