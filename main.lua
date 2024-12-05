require('mane')

function mane.load()
    love.graphics.setDefaultFilter( 'nearest', 'nearest', 1 )
    Camera = require('libs.camera')
    Animations = require('libs.animations')

    Group = mane.display.game

    World = mane.physics.newWorld(0, 500)

    require('src.player')
    require('levels.level1.logic')

    World.update = true
end