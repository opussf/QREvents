QREVENTS_SLUG, QREvents = ...

QREvents_events = {}
QREvents_timediffs = {}

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
	QREvents_Frame:RegisterEvent("PLAYER_LOGIN")
end
function QREvents.PLAYER_LOGIN()
	QREvents.realm = GetNormalizedRealmName()

	local serverTT = C_DateAndTime.GetCurrentCalendarTime()  -- 'wonky' time table
	serverTT.day = serverTT.monthDay
	serverTT.wday = serverTT.weekday
	serverTT.min = serverTT.minute

	local serverTS = time( serverTT )
	local myTS = time()

	-- print( "ServerTime: "..date("%x %X", serverTS) )
	-- print( "Local Time: "..date("%x %X", myTS) )

	realmDiff = myTS - serverTS
	realmDiff = (math.floor(math.abs(realmDiff/3600)+0.49) * 3600) * (realmDiff < 0 and -1 or 1)  -- the realm time seems to lag a bit.  Bump it back up to whole hours

	QREvents_timediffs[QREvents.realm] = realmDiff
	for ts, _ in pairs( QREvents_events ) do
		if ts ~= "now" and ts+(1 * 86400) < time() then
			QREvents_events[ts] = nil
		end
	end
end

function QREvents.CALENDAR_OPEN_EVENT(self, thing)
	-- QREvents.Print( "CALENDAR_OPEN_EVENT( "..thing.." )" )
	local info = C_Calendar.GetEventInfo()
	if info then
		local vcalTF = "%Y%m%dT%H%M%S"
		local now = date( vcalTF )
		-- Sigh...   Fix the 'fake' time table to a real lua time table
		info.time.day = info.time.monthDay
		info.time.wday = info.time.weekday
		info.time.min = info.time.minute

		eventTS = time(info.time)
		-- print( "EventTime: "..date("%x %X", time(info.time)) )

		local eventRealm = string.match( info.creator, "-(.*)" )
		eventRealm = eventRealm or QREvents.realm

		-- print( "EventRealm: "..eventRealm )

		if not QREvents_timediffs[eventRealm] then
			print("Warning: please manually adjust time of event.")
			print("Log into a character on "..eventRealm.." to regester the realm time.")
		end
		local eventStart = time(info.time) + ( QREvents_timediffs[eventRealm] or 0 )

		local start = date( vcalTF, eventStart )
		-- print( "StartTime: "..date("%x %X", eventStart) )

		local vcal = {}
		table.insert( vcal, "BEGIN:VCALENDAR" )
		table.insert( vcal, "VERSION:2.0" )
		table.insert( vcal, "BEGIN:VEVENT" )
		table.insert( vcal, "DTSTAMP:"..now )
		table.insert( vcal, "DTSTART:"..start )
		table.insert( vcal, "DTEND:"..start )
		table.insert( vcal, "TITLE:"..info.title )
		table.insert( vcal, "SUMMARY:"..info.description )
		table.insert( vcal, "LOCATION:"..info.communityName.."-"..eventRealm )
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
		QREvents.Print( info.title.." has been saved, and can be used to create a QRCode." )
	end

end

function QREvents.CALENDAR_ACTION_PENDING(self, b )
	QREvents.Print( "CALENDAR_ACTION_PENDING( "..(b and "True" or "False").." )" )
end
