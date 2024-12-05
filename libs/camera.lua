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

local camera = {}

local running = {}
local function lerp(a, b, t)
    return a + (b - a) * t
end

mane.timer.new(0, function()
    for i = 1, #running, 1 do
        local focus = running[i].focus
        local group = running[i].group
        local moveSpeed = running[i].smoother/100

        local targetX = -focus.x + mane.display.width / 2
        local targetY = -focus.y + mane.display.height / 2

        group.x = lerp(group.x, targetX, moveSpeed)
        group.y = lerp(group.y, targetY, moveSpeed)
    end
end, 0)


local base = {}

function base:destroy()
    self.group:remove()
    for i = #running, 1, -1 do
        if running[i] == self then
            table.remove(running, i)
            break
        end
    end
end

function base:insert(...)
    local objects = {...}
    for i = 1, #objects, 1 do
        objects[i].oldGroup = objects[i].group
        objects[i]:moveToGroup(self.group)
    end
end

function base:remove(group, ...)
    local objects = {...}
    for i = 1, #objects, 1 do
        objects[i].oldGroup = nil
        objects[i]:moveToGroup(group)
    end
end

function base:setGroup(group)
    self.focus:moveToGroup(group)
    self.group = Level
end

camera.create = function (focus, smoother)
    focus = focus or mane.display.game:newRect(0,0,0,0)
    local obj = setmetatable({
        focus = focus,
        smoother = smoother,
        group = mane.display.game:newGroup()
    }, {__index = base})
    focus:moveToGroup(obj.group)

    table.insert(running, obj)
    return obj
end

return camera