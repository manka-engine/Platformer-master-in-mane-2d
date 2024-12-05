local idle = {'images/5-Enemy-Captain/1-Idle/1.png'}
for i = 2, 32, 1 do
    table.insert(idle, 'images/5-Enemy-Captain/1-Idle/'..i..'.png')
end
local idle = mane.graphics.newArrayImage(idle)

Player = Group:newLayerImage( idle, 1, mane.display.centerX, mane.display.centerY)
World:addBody(Player, 'dynamic', {shape='rect', width=40, height = 68, offsetX = 5})

Player:setFixedRotation(true)

Player.Idle = Animations.create(Player, 'idle', {
    sprites = idle,
    time = 50,
    rep = 1
})

local run = {'images/5-Enemy-Captain/2-Run/1.png'}
for i = 2, 14, 1 do
    table.insert(run, 'images/5-Enemy-Captain/2-Run/'..i..'.png')
end
local run = mane.graphics.newArrayImage(run)
Player.Run = Animations.create(Player, 'run', {
    sprites = run,
    time = 30,
    rep = 1
})


local left, right = false, false
Player:addEvent('update', function (e)
    local dt = e.dt
    if left then
        Player:translate(-300*dt, 0)
        Player.xScale = -1
        Player.bodyOptions.offsetX = -5
    end
    if right then
        Player:translate(300*dt, 0)
        Player.xScale = 1
        Player.bodyOptions.offsetX = 5
    end
    if left or right then
        if not Player.Run.timer then
            if Player.Idle.timer then
                Player.Idle:stop()
            end
            Player.Run:play()
        end
    else
        if not Player.Idle.timer then
            if Player.Run.timer then
                Player.Run:stop()
            end
            Player.Idle:play()
        end
    end
end)

Player:addEvent('key', function (e)
    if e.phase == 'began' then
        if e.key == 'left' then
            left = true
        elseif e.key == 'right' then
            right = true
        elseif e.key == 'up' then
            local vx, vy = Player:getLinearVelocity()
            if vy > -3 and vy < 3 then
                Player:setLinearVelocity(0, -400)
            end
        elseif e.key == 'y' then
            Player:setLinearVelocity(0, -400)
        end
    else
        if e.key == 'left' then
            left = false
        elseif e.key == 'right' then
            right = false
        end
    end
end)