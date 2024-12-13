Bird = Class{}

local GRAVITY = 1

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = ( self.width / 2 )
    self.y = 0

    self.dx = math.random(1,5)

    self.isActive = false  -- Bird is inactive by default , 
    -- if a block is available it will active and deactivate when goes out of the screen , this is very crucial to manage birds with the buddy system i designed.
end

function Bird:colides()
    if (self.x ) + (self.width) >= VIRTUAL_WIDTH then
        return true
    end
    return false
end

function Bird:update(dt)
    self.dx = self.dx + GRAVITY * dt
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        sounds['jump']:play()
        self.dx = -5
    end
    
    self.x = self.x + self.dx
    
end

function Bird:render()
    if self.isActive then
        love.graphics.draw(self.image, self.x, self.y)
    end
end

-- Activate bird in a block
function Bird:start(x, y)
    self.x = math.min(math.random( self.height/2 ,VIRTUAL_WIDTH/2) , x + ( self.width / 2 ))
    self.y = math.min(math.random( self.height/2 ,250) , y + ( self.height / 2 ))
    self.dx = 0
    self.isActive = true
end

-- Deactivate bird (return to buddy system)
function Bird:deactivate()
    self.isActive = false
end