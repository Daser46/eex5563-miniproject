Bird = Class{}

local GRAVITY = 1

function Bird:init(y)
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = ( self.width / 2 )
    self.y = math.min(math.random( self.height/2 ,250) , y + ( self.height / 2 ))

    self.dx = math.random(1,5)
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
    love.graphics.draw(self.image, self.x, self.y)
end