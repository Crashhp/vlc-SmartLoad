function descriptor()
    return {
        title = "Smart Playlist Extender";
        description = "Extends the playlist by files in last item's directory";
        version = "0.1.1";
        author = "thebamby";
        capabilities = {}
    }
end

function activate()
    local playlistItems = vlc.playlist.get("normal", false).children
    local currentItem = playlistItems[#playlistItems]
    local fileExtension = GetFileExtension(currentItem.name)
    local folderPath = string.gsub(string.match(currentItem.path, ".*[\\\\/]"), "file:///", "")
    local folderPath = string.gsub(folderPath, "%%20", " ")
    local folderPath = string.gsub(folderPath, "%%5B", "[")
    local folderPath = string.gsub(folderPath, "%%5D", "]")

    --vlc.msg.info(currentItem.path) 
    --vlc.msg.info(folderPath)

    local files = vlc.io.readdir(folderPath)

    table.sort(files)

    for _, item in ipairs(files) do
        if (EndsWith(item, fileExtension)) then
            if (currentItem.name < item) then
                vlc.playlist.enqueue({{path = "file:///" .. folderPath .. item; name = item}})
            end
        end
    end

    vlc.deactivate()
end

function GetFileExtension(url)
    return url:match("^.+(%..+)$")
end

function EndsWith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

function deactivate()
end

function meta_changed()
end

function close()
    vlc.deactivate()
end