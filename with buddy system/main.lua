push = require 'Push' -- third party free library to manage resolution without droping quality
Class = require 'class' -- class library to support OOP
require 'Bird'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/CountDownState'

require 'BuddySystem'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514


params = {
    vsync = true,
    fullscreen = false,
    resizable = true
}
-- set scrolling true , this is for pause and play 
scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')
    love.window.setTitle('Fifty Bird')

    -- fonts

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- audio files

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['pause'] = love.audio.newSource('pause.wav', 'static'),
        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('marios_way.mp3', 'static'),
    }
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- setup screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, params)
    math.randomseed(os.time())

    gStateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['countdown'] = function() return CountDownState() end,
      

    }

    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end 

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end


function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT
    end
    gStateMachine:update(dt)

    --reseting keyboard and mouse inputs
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
  
end

-- rendering the objects
function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end
