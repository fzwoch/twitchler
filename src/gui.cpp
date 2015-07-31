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

#include "gui.h"
#include "app.h"

myFrame::myFrame()
	: wxFrame(NULL, wxID_ANY, "Twitchler")
{
	m_panel = new wxPanel(this);
	
	m_video = new wxPanel(m_panel, wxID_ANY, wxDefaultPosition, wxSize(960, 540), wxTAB_TRAVERSAL, "video");
	m_control = new wxPanel(m_panel);
	
	m_control->SetBackgroundColour(m_panel->GetBackgroundColour());
	m_panel->SetBackgroundColour(wxColour(*wxBLACK));
	m_video->SetBackgroundColour(wxColour(*wxBLACK));
	
	m_url = new wxTextCtrl(m_control, wxID_ANY, wxEmptyString, wxDefaultPosition, wxDefaultSize, wxTE_PROCESS_ENTER);
	m_start = new wxButton(m_control, wxID_ANY, "Start");
	m_volume = new wxSlider(m_control, wxID_ANY, 1000, 0, 1000, wxDefaultPosition, wxSize(180, -1));
	
	m_url->SetHint("Twitch channel name you want to view");
	
	Bind(wxEVT_CLOSE_WINDOW, &myApp::OnCloseEvent, wxGetApp());
	m_video->Bind(wxEVT_LEFT_DCLICK, &myFrame::OnToggleFullScreen, this);
	m_start->Bind(wxEVT_BUTTON, &myApp::OnGetStreamingUrl, wxGetApp(), wxID_ANY, wxID_ANY, new wxVariant(this));
	m_url->Bind(wxEVT_TEXT_ENTER, &myApp::OnGetStreamingUrl, wxGetApp(), wxID_ANY, wxID_ANY, new wxVariant(this));
	m_volume->Bind(wxEVT_SCROLL_THUMBTRACK, &myApp::OnVolumeSlider, wxGetApp(), wxID_ANY, wxID_ANY, new wxVariant(this));
	
	wxBoxSizer *control_sizer = new wxBoxSizer(wxHORIZONTAL);
	
	control_sizer->Add(m_url, 1, wxALL, 15);
	control_sizer->Add(m_start, 0, wxTOP | wxBOTTOM, 15);
	control_sizer->Add(m_volume, 0, wxALL | wxEXPAND, 15);
	
	m_control->SetSizer(control_sizer);
	m_control->Fit();
	
	wxBoxSizer *sizer = new wxBoxSizer(wxVERTICAL);
	
	sizer->Add(m_video, 1, wxSHAPED | wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL);
	sizer->Add(m_control, 0, wxEXPAND);
	
	m_panel->SetSizer(sizer);
	m_panel->Fit();
	
	Fit();
}

myFrame::~myFrame()
{
}

wxString myFrame::GetChannelName()
{
	return m_url->GetValue();
}

int myFrame::GetVolume()
{
	return m_volume->GetValue();
}

void myFrame::OnToggleFullScreen(wxEvent &event)
{
	if (IsFullScreen())
	{
		m_control->Show();
	}
	else
	{
		m_control->Hide();
	}
	
	ShowFullScreen(!IsFullScreen());
}
