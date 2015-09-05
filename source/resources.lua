local resources = {}

local function get_files_from_directory(directory)
    local i = 0
    local t = {}
    local popen = io.popen

    for filename in popen('ls -a "'..directory..'"'):lines() do
        -- append files to the "table of resources"
        if filename ~= "." and filename ~= ".." then
            -- take filename and using it as a table key
            name = string.gmatch(filename, '([a-zA-Z0-9_-]+)')()
            t[name] = directory..filename
        end
    end
    return t
end

resources.audio = get_files_from_directory("../assets/sound/")
resources.images = get_files_from_directory("../assets/images/")
return resources
