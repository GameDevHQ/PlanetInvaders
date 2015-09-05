local sound = {}

resources = require("resources")

local function init_sound()
    -- link sounds to the current module and use it later
    sound.kill = audio.loadSound(resources.audio['boing'])
    sound.blast = audio.loadSound(resources.audio['blast'])
    sound.lose = audio.loadSound(resources.audio['wahwahwah'])
end

function sound.play_sound(sound)
    audio.play(sound)
end

-- call this function when module imported
init_sound()
return sound