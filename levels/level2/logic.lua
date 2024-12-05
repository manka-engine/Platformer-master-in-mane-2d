Level = Group:newGroup()

local platformPath = 'images/8-Tile-Sets/Variations/4.png'
local platform0 = Level:newImage(platformPath, mane.display.centerX, mane.display.centerY+100, 2, 2)
World:addBody(platform0, 'static', {shape='rect', width = 130, height=30})

local platform1 = Level:newImage(platformPath, mane.display.centerX+200, mane.display.centerY, 2, 2)
World:addBody(platform1, 'static', {shape='rect', width = 130, height=30})

LevelCamera = Camera.create(Player, 10)
LevelCamera:setGroup(Level)