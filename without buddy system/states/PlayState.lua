PlayState = Class{__includes = BaseState}

--[[ @author - daser46(s92062870@ousl.lk)
-- play state which has the main logics of managing birds.
]]--

function PlayState:init()
    self.birds = {}  -- Table to store all the bird instances
    self.timer = 0
    self.score = 0
    self.level = 0
    self.paused = false

    -- Create 250 bird instances and add them to the birds table
    for i = 1, 10000 do
        local bird = Bird(i)
        table.insert(self.birds, bird)
    end
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        sounds['pause']:play()
        self.paused = not self.paused
        scrolling = not scrolling
    end
    
    if self.paused then
        sounds['music']:stop()
    else
        sounds['music']:play()
        self.timer = self.timer + dt

        -- Update each bird
        for _, bird in ipairs(self.birds) do
            bird:update(dt)
        end

        -- Check collisions for each bird
        for _, bird in ipairs(self.birds) do
            if bird:colides() then
                sounds['hurt']:play()
            end
        end

        -- Check if any bird goes out of bounds (or hits the ground)
        for _, bird in ipairs(self.birds) do
            if bird.y > VIRTUAL_HEIGHT - 15 then
                sounds['hurt']:play()
                sounds['explosion']:play()
                -- gStateMachine:change('score', {score = self.score})
            end
        end
    end
end

function PlayState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.setFont(mediumFont)

    if self.paused then
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Paused (press Enter to continue)', 0, 8, VIRTUAL_WIDTH, 'center')
        -- love.graphics.draw(pause, VIRTUAL_WIDTH / 2 - 10, VIRTUAL_HEIGHT / 2 - 10)
    end

    -- Render each bird
    for _, bird in ipairs(self.birds) do
        bird:render()
    end
end
