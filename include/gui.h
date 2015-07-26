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

#ifndef __GUI_H__
#define __GUI_H__

#include <wx/wx.h>

class myFrame: public wxFrame
{
	wxPanel *m_panel;
	wxPanel *m_video;
	wxPanel *m_control;
	wxTextCtrl *m_url;
	wxButton *m_start;
	wxSlider *m_volume;
	
public:
	myFrame();
	virtual ~myFrame();
	
	wxString GetChannelName();
	int GetVolume();
	void OnToggleFullScreen();
};

#endif // __GUI_H__