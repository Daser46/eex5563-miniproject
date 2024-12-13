--[[ @author - daser46(s92062870@ousl.lk)
-- play state which has the main logics of managing birds.
]]--

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.buddySystem = BuddySystem -- intialization of buddy system
    self.buddySystem:init(1024, 4)  -- Total memory size 1024 and smallest block size 4, can adjust as we want
    self.birds = {}  -- Table to store all the bird instances
    self.timer = 0
    self.score = 0
    self.level = 0
    self.paused = false

    -- Initially allocate birds to the system
    for i = 1, 10000 do
        local bird = self.buddySystem:allocate(4)  -- Requesting a block for a bird
        if bird then
            bird:start(bird.height + i, VIRTUAL_HEIGHT / 2)
            table.insert(self.birds, bird)
        end
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

        -- Update and check each bird for collisions
        for _, bird in ipairs(self.birds) do
            bird:update(dt)

            if bird:colides() then
                sounds['hurt']:play()
                self.buddySystem:free(bird)  -- Deallocate bird and merge buddy blocks
            end
        end

        -- Deactivate birds if they are out of screen
        for _, bird in ipairs(self.birds) do
            if bird.x > VIRTUAL_WIDTH then
                bird:deactivate()
                self.buddySystem:free(bird)  -- Return the block to the buddy system
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

    -- Render all active birds
    for _, bird in ipairs(self.birds) do
        bird:render()
    end
end
