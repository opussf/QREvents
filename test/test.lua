#!/usr/bin/env lua

require "wowTest"
test.outFileName = "testOut.xml"
test.coberturaFileName = "../coverage.xml"  -- to enable coverage output

ParseTOC( "../src/QREvents.toc" )

-- addon setup
function test.before()
	-- --Rested.eventFunctions = {}
	-- Rested.filter = nil
	-- Rested.reminders = {}
	-- Rested.lastReminderUpdate = nil
	-- Rested_options = {["showNumBars"] = 6}
	-- Rested_restedState = {}
	-- chatLog = {}
	-- Rested.OnLoad()
	-- Rested.ADDON_LOADED()
	-- Rested.VARIABLES_LOADED()
	-- --Rested.SaveRestedState()
end
function test.after()
end

test.run()
