-- ~/.hammerspoon/hs_locker.lua
-- local locker = require('hs_locker')
-- locker.init()

local log = hs.logger.new("", "info")

function init()
    -- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html
    hs.caffeinate.watcher.new(function(event)
        local eventName = hs.caffeinate.watcher[event]
        if event == hs.caffeinate.watcher.screensDidUnlock then
            os.execute("~/.unlock")
        elseif event == hs.caffeinate.watcher.screenDidLock then
            os.execute("~/.lock")
        end
    end):start()
end
