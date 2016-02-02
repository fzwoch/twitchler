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

#ifndef __APP_H__
#define __APP_H__

#include <wx/wx.h>
#include "gui.h"
#include "gstreamer.h"

#define wxGetApp() dynamic_cast<myApp*>(wxTheApp)

class myApp: public wxApp
{
	virtual bool OnInit();
	int FilterEvent(wxEvent &event);
	
	myFrame *m_frame;
	GStreamer m_gstreamer;
	
public:
	void OnGetStreamingUrl(wxCommandEvent &event);
	void OnVolumeSlider(wxScrollEvent &event);
	void OnGStreamerError(GError *err);
	void OnGStreamerEos();
	void OnCloseEvent(wxCloseEvent &event);
};

#endif // __APP_H__
