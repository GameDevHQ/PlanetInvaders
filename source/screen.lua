local screen = {}

resources = require("resources")

screen.centerX = display.contentCenterX
screen.centerY = display.contentCenterY

screen.background = nil
screen.planet = nil

local planetY_shift = 60
local background_shift = 130

local function show_title()
    -- display the title of the game on top left corner
    screen.gameTitle = display.newImage(resources.images['gametitle'])
    screen.gameTitle.alpha = 0
    screen.gameTitle:scale(4, 4)
    transition.to(screen.gameTitle, {time=500, alpha=1, xScale=0.8, yScale=0.8})
end

local function init_screen()
    -- load images
    screen.background = display.newImage(resources.images['background'])
    screen.planet = display.newImage(resources.images['planet'])

    -- prepare background image
    screen.background.y = background_shift
    screen.background.alpha = 0

    -- prepare plant image: hide picture behind the display
    screen.planet.x = screen.centerX
    screen.planet.y = display.contentHeight + planetY_shift
    screen.planet.alpha = 0

    -- centralize background images, using animation
    transition.to(screen.background, {time=2000, alpha=1, x=screen.centerX, y=screen.centerY})
    transition.to(screen.planet, {time=2000, alpha=1, y=screen.centerY, onComplete=show_title()})
end

-- call this function when this module imported
init_screen()
return screen