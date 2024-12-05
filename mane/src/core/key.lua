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

local m = {}
m.running = {}

function m.new(obj, listener)
    if #obj.events.key <= 0 then
        table.insert(m.running, obj)
    end
    table.insert(obj.events.key, listener)
end

function m.remove(obj, listener)
    for i = #obj.events.key, 1, -1 do
        if obj.events.key[i] == listener then
            table.remove(obj.events.key, i)
            break
        end
    end
    for i = m.running, 1, -1 do
        if m.running[i] == obj then
            table.remove(m.running, i)
            break
        end
    end
end


m.keypressed = function (key, scancode, isrepeat)
    for i = #m.running, 1, -1 do
        local obj = m.running[i]
        for i2 = 1, #obj.events.key, 1 do
            obj.events.key[i2](
                {
                    phase = "began",
                    key = key,
                    scancode = scancode,
                    isrepeat = isrepeat,
                    target = obj
                }
            )
        end
    end
end

m.keyreleased = function (key)
    for i = #m.running, 1, -1 do
        local obj = m.running[i]
        for i2 = 1, #obj.events.key, 1 do
            obj.events.key[i2](
                {
                    phase = "ended",
                    key = key,
                    target = obj
                }
            )
        end
    end
end

mane.core.key = m