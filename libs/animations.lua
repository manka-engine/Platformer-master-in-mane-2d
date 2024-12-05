--[[
MIT License

Copyright (c) 2024 Max-Dil

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local animations = {}

local base = {}

function base:play(listener)
    listener = listener or function () end
    if self.timer then
        base:stop()
    end
    local object = self.object
    local time = self.time
    local rep = self.rep
    local start = self.start
    local count = self.count

    local origStart = self.start
    local _rep = (count + 1) * rep
    local currentRepeat = 0

    local nameTimer = self.nameTimer

    self.timer = mane.timer.new(0, function ()
        if not object then
            base:stop()
            return true
        end

        object.layerindex = start
        start = start + 1

        if start > origStart + count then
            start = origStart
            currentRepeat = currentRepeat + 1
        end
        self.timer:setTime(time)
        if currentRepeat >= rep then
            self.timer = nil
            listener()
        end
    end, _rep, nameTimer)
end

function base:stop(delay)
    local function stop()
        self.timer:cancel()
        self.timer = nil
    end
    if delay then
        mane.timer.new(delay, stop)
    else
        stop()
    end
end

animations.create = function (objectLayerImage, name, options) -- sprites, time, rep, start, count
    local obj = setmetatable({
        time = options.time or 1000,
        rep = options.rep or 1,
        object = objectLayerImage,
        start = options.start or 1,
        count = options.count or #(options.sprites or {}) - 1,
        nameTimer = options.timerName or nil
    }, {__index = base})

    objectLayerImage.__animations__ = objectLayerImage.__animations__ or {}
    objectLayerImage.__animations__[name] = obj
    return obj
end

return animations