--[[ @author - daser46(s92062870@ousl.lk)
-- using a budddy system to memory allocation of a bird.
]]--

BuddySystem = {}

-- Initialize BuddySystem with total memory size and smallest block size
function BuddySystem:init(totalMemorySize, smallestBlockSize)
    self.smallestBlockSize = smallestBlockSize
    self.totalMemorySize = totalMemorySize
    self.blocks = {} -- empty table to  holds the blocks

    -- Initialize blocks in powers of two as in legacy buddysytems 
    local size = self.smallestBlockSize
    while size <= self.totalMemorySize do
        table.insert(self.blocks, { size = size, free = true, bird = nil })
        size = size * 2  -- Increase size in powers of two
    end
end

-- Find the smallest available block that can fit the requested memory size
function BuddySystem:findBlock(size)
    for _, block in ipairs(self.blocks) do
        if block.size >= size and block.free then
            return block
        end
    end
    return nil 
end

-- Split a block into two buddy blocks
function BuddySystem:splitBlock(block)
    local halfSize = block.size / 2
    if halfSize >= self.smallestBlockSize then
        local buddyBlock = { size = halfSize, free = true, bird = nil }
        table.insert(self.blocks, buddyBlock)
        block.size = halfSize
    end
end

-- Allocate memory for a bird
function BuddySystem:allocate(size)
    local block = self:findBlock(size)
    if block then
        -- Split the block until it's the correct size, this helps to save memory
        while block.size > size do
            self:splitBlock(block)
        end
        block.free = false  -- Block is now allocated
        block.bird = Bird()  -- Allocate bird object in the block
        return block.bird
    else
        return nil  -- No suitable block found
    end
end

-- Free memory (deallocate) and merge buddies if possible
function BuddySystem:free(bird)
    for _, block in ipairs(self.blocks) do
        if block.bird == bird then
            block.bird = nil
            block.free = true
            -- Attempt to merge with buddy if both are free
            self:mergeBuddies(block)
            break
        end
    end
end

-- Merge buddy blocks if both are free
function BuddySystem:mergeBuddies(block)
    local buddySize = block.size * 2
    for _, otherBlock in ipairs(self.blocks) do
        if otherBlock.size == buddySize and otherBlock.free then
            block.size = buddySize  -- Merge with buddy
            otherBlock.free = false
            break
        end
    end
end
