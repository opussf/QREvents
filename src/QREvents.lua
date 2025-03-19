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
	QREvents_Frame:RegisterEvent("CALENDAR_ACTION_PENDING")
end


