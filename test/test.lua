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
function test.test_dynamicAlarms_greaterThan1Week()
    local eventTime = time() + ( 8 * 86400 )
    a1, a2 = QREvents.DetermineAlarms(eventTime)
    assertEquals( "-P7D", a1 )
    assertEquals( "-P1D", a2 )
end
function test.test_dynamicAlarms_7to3Days()
   local eventTime = time() + ( 4 * 86400 )
    a1, a2 = QREvents.DetermineAlarms(eventTime)
    assertEquals( "-P1D", a1 )
    assertEquals( "-PT12H", a2 )
end
function test.test_dynamicAlarms_lessThan1Day()
    local eventTime = time() + 86000
    a1, a2 = QREvents.DetermineAlarms(eventTime)
    assertEquals( "-PT12H", a1 )
    assertEquals( "-PT6H", a2 )
end
function test.test_dynamicAlarms_15Min()
    local eventTime = time() + 905
    alarms = {QREvents.DetermineAlarms(eventTime)}
    assertEquals( "-PT15M", alarms[1] )
    assertIsNil( alarms[2] )
end


test.run()
