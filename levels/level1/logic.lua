Level = Group:newGroup()
local platformPath = 'images/8-Tile-Sets/Variations/4.png'

local platform0 = Level:newImage(platformPath, mane.display.centerX, mane.display.centerY+100, 2, 2)
World:addBody(platform0, 'static', {shape='rect', width = 130, height=30})

local platform1 = Level:newImage(platformPath, mane.display.centerX+200, mane.display.centerY, 2, 2)
World:addBody(platform1, 'static', {shape='rect', width = 130, height=30})

local platform2 = Level:newImage(platformPath, mane.display.centerX-100, mane.display.centerY, 2, 2)
World:addBody(platform2, 'static', {shape='rect', width = 130, height=30})

local platform3 = Level:newImage(platformPath, mane.display.centerX-400, mane.display.centerY, 2, 2)
World:addBody(platform3, 'static', {shape='rect', width = 130, height=30})

local platform4 = Level:newImage(platformPath, mane.display.centerX-700, mane.display.centerY+100, 2, 2)
World:addBody(platform4, 'static', {shape='rect', width = 130, height=30})

local platform5 = Level:newImage(platformPath, mane.display.centerX-1100, mane.display.centerY+100, 2, 2)
World:addBody(platform5, 'static', {shape='rect', width = 130, height=30})
if 'platform 5' then
platform5.move = 'left'
platform5.collision = false
platform5:addEvent('update', function (e)
    local dt = e.dt
    if platform5.move == 'left' then
        platform5:translate(-60*dt, 0)
        if platform5.collision then
            Player:translate(-60*dt, 0)
        end
    else
        platform5:translate(60*dt, 0)
        if platform5.collision then
            Player:translate(60*dt, 0)
        end
    end
end)
platform5:addEvent('collision', function (e)
    if e.target == Player and e.other == platform5 then
        if e.phase == 'began' then
            platform5.collision = true
        else
            platform5.collision = false
        end
    end
end)
mane.timer.new(2000, function (dt)
    if platform5.move == 'left' then
        platform5.move = 'right'
    else
        platform5.move = 'left'
    end
end, 0, 'level1')
end


local platform6 = Level:newImage(platformPath, mane.display.centerX-1600, mane.display.centerY, 4, 4)
World:addBody(platform6, 'static', {shape='rect', width = 260, height=60})

local platform7 = Level:newImage(platformPath, mane.display.centerX-1000, mane.display.centerY-100, 2, 2)
World:addBody(platform7, 'static', {shape='rect', width = 130, height=30})
if 'platform 7' then
platform7.move = 'left'
platform7.collision = false
platform7:addEvent('update', function (e)
    local dt = e.dt
    if platform7.move == 'left' then
        platform7:translate(-60*dt, 0)
        if platform7.collision then
            Player:translate(-60*dt, 0)
        end
    else
        platform7:translate(60*dt, 0)
        if platform7.collision then
            Player:translate(60*dt, 0)
        end
    end
end)
platform7:addEvent('collision', function (e)
    if e.target == Player and e.other == platform7 then
        if e.phase == 'began' then
            platform7.collision = true
        else
            platform7.collision = false
        end
    end
end)
mane.timer.new(3000, function (dt)
    if platform7.move == 'left' then
        platform7.move = 'right'
    else
        platform7.move = 'left'
    end
end, 0, 'level1')
end

local platform8 = Level:newImage(platformPath, mane.display.centerX-800, mane.display.centerY-200, 4, 4)
World:addBody(platform8, 'static', {shape='rect', width = 260, height=60})

local windowsPath = 'images/7-Objects/12-Other Objects/Windows.png'
local windows = Level:newImage(windowsPath, mane.display.centerX-700, mane.display.centerY-350, 1, 1)
World:addBody(windows, 'static', {shape='rect', width = 60, height=60})
windows.fixture:setSensor(true)

local lightPath = 'images/7-Objects/8-Window Light/1.png'
local windowsLight = Level:newImage(lightPath, mane.display.centerX-725, mane.display.centerY-375, 1, 1)
windowsLight:translate(windowsLight.image:getWidth()/2, windowsLight.image:getHeight()/2)
--mane.display.renderMode = 'hybrid'

local bombPath = 'images/7-Objects/1-BOMB/1-Bomb Off/1.png'

local BombAnimation = {}
table.insert(BombAnimation, bombPath)
for i = 1, 10, 1 do
    table.insert(BombAnimation, 'images/7-Objects/1-BOMB/2-Bomb On/'..i..'.png')
end
for i = 1, 9, 1 do
    table.insert(BombAnimation, 'images/7-Objects/1-BOMB/3-Explotion/'..i..'.png')
end
BombAnimation = mane.graphics.newArrayImage(BombAnimation)

local bombCreate = function (x, y)
    local bomb = Level:newLayerImage(BombAnimation, 1, x, y)
    World:addBody(bomb, 'dynamic', {shape='circle', radius = 10, offsetY = -20})

    bomb.animation = Animations.create(bomb, 'on', {
        sprites = BombAnimation,
        time = 30,
        rep = 1,
        start = 2,
        count = 10,
        timerName = 'level1'
    })

    bomb.animationExplosion = Animations.create(bomb, 'explosion', {
        sprites = BombAnimation,
        time = 30,
        rep = 1,
        start = 12,
        count = 9,
        timerName = 'level1'
    })

    mane.timer.new(1000, function ()
        bomb.animation:play(function ()
            bomb.animationExplosion:play(function ()
                if love.distance(bomb.x, bomb.y, Player.x, Player.y) < 70 then
                    Player.x, Player.y = mane.display.centerX, mane.display.centerY
                end
                bomb:remove()
                bomb = nil
            end)
        end)
    end, 1, 'level1')
end

mane.timer.new(2000, function ()
    bombCreate(platform4.x, platform4.y - 250)
    bombCreate(platform6.x, platform6.y - 400)
end, 0, 'level1')

LevelCamera = Camera.create(Player, 10)
LevelCamera:setGroup(Level)

windows:addEvent('update', function (e)
    if love.distance(windows.x, windows.y, Player.x, Player.y) <= 30 then
        mane.timer.cancelAll('level1')

        Player:moveToGroup(mane.display.game)

        LevelCamera:destroy()
        LevelCamera = nil
        Level = nil

        print('new level')

        Player.x, Player.y = mane.display.centerX, mane.display.centerY
        require('levels.level2.logic')
        return true
    end
    if Player.y > mane.display.centerY + 1000 then
        Player.x, Player.y = mane.display.centerX, mane.display.centerY
    end
end)
