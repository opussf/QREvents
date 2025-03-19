QREVENTS_SLUG, QREvents = ...

QREvents_events = {}

function QREvents.Print( msg, showName)
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	-- if (showName == nil) or (showName) then
		-- msg = COLOR_PURPLE..GOLDRATE_MSG_ADDONNAME.."> "..COLOR_END..msg
	-- end
	DEFAULT_CHAT_FRAME:AddMessage( msg )
end

function QREvents.OnLoad()
	QREvents_Frame:RegisterEvent("CALENDAR_OPEN_EVENT")
	-- QREvents_Frame:RegisterEvent("CALENDAR_ACTION_PENDING")
end

function QREvents.CALENDAR_OPEN_EVENT(self, thing)
	-- QREvents.Print( "CALENDAR_OPEN_EVENT( "..thing.." )" )
	local info = C_Calendar.GetEventInfo()
	-- QREvents.Print( info.title )
	-- QREvents.Print( info.eventType )
	local vcalTF = "%Y%m%dT%H%M%S"
	local now = date( vcalTF )
	-- Sigh...   Fix the 'fake' time table to a real lua time table
	info.time.day = info.time.monthDay
	info.time.wday = info.time.weekday
	info.time.min = info.time.minute

	local start = date( vcalTF, time(info.time) )

	local vcal = {}
	table.insert( vcal, "BEGIN:VCALENDAR" )
	table.insert( vcal, "VERSION:2.0" )
	table.insert( vcal, "BEGIN:VEVENT" )
	table.insert( vcal, "DTSTAMP:"..now )
	table.insert( vcal, "DTSTART:"..start )
	table.insert( vcal, "DTEND:"..start )
	table.insert( vcal, "TITLE:"..info.title )
	table.insert( vcal, "SUMMARY:"..info.description )
	table.insert( vcal, "LOCATION:Wow-realm" )
	table.insert( vcal, "BEGIN:VALARM" )
	table.insert( vcal, "TRIGGER:-P7D" )
	table.insert( vcal, "ACTION:DISPLAY" )
	table.insert( vcal, "END:VALARM" )
	table.insert( vcal, "BEGIN:VALARM" )
	table.insert( vcal, "TRIGGER:-P1D" )
	table.insert( vcal, "ACTION:DISPLAY" )
	table.insert( vcal, "END:VALARM" )
	table.insert( vcal, "END:VEVENT" )
	table.insert( vcal, "END:VCALENDAR" )

	local tsnow = time()

	QREvents_events["now"] = table.concat( vcal, "\n" )
	QREvents_events[tsnow] = QREvents_events["now"]

end

function QREvents.CALENDAR_ACTION_PENDING(self, b )
	QREvents.Print( "CALENDAR_ACTION_PENDING( "..(b and "True" or "False").." )" )
end
