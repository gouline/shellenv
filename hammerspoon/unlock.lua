local log = hs.logger.new("", "info")

function watchUnlock()
    log.f("Watching unlock events")
    -- https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html
    hs.caffeinate.watcher.new(function(event)
        local eventName = hs.caffeinate.watcher[event]
        if event == hs.caffeinate.watcher.screensDidUnlock then
            hs.execute("~/.unlock", true)
        end
    end):start()
end
