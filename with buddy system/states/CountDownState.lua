CountDownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 0.75

function CountDownState:init()
    self.count = 3
    self.timer = 0
end

function CountDownState:update(dt)
    self.timer = self.timer + dt
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountDownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.print(self.count,VIRTUAL_WIDTH/2,VIRTUAL_HEIGHT/2-28)
end