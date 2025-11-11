--- made by navet

local changelog_link = "https://raw.githubusercontent.com/uosq/lbox-changelog-show/refs/heads/main/changelog_table.lua"
local beta_changelog_link = "https://raw.githubusercontent.com/uosq/lbox-changelog-show/refs/heads/main/beta_changelog_table.lua"
local lua_link       = "https://raw.githubusercontent.com/uosq/lbox-changelog-show/refs/heads/main/lua_table.lua"

-- amount of most recent logs to show
local amount = 2

local changelog      = load(http.Get(changelog_link))() --- stable changelog
local beta_changelog = load(http.Get(beta_changelog_link))() --- beta changelog
local lua_changelog  = load(http.Get(lua_link))() --- lua changelog
assert(type(changelog)      == "table", "Stable changelog is not a table!")
assert(type(beta_changelog) == "table", "Beta changelog is not a table!")
assert(type(lua_changelog)  == "table", "Lua changelog is not a table!")

-- ui state
local activeTab = "stable" -- or "beta" or "lua"

local font = draw.CreateFont("Arial", 12, 1000, FONTFLAG_GAUSSIANBLUR | FONTFLAG_ANTIALIAS)

-- padding around text inside window
local padding_x, padding_y = 15, 15
-- spacing between entries
local spacing = 8

local function TextShadow(x, y, text)
    draw.Color(46, 52, 64, 255)
    draw.Text(x + 1, y + 1, text)
    draw.Color(236, 239, 244, 255)
    draw.Text(x, y, text)
end

callbacks.Register("Draw", "changelog_window", function ()
    draw.SetFont(font)

    local sw, sh = draw.GetScreenSize()

    -- select the appropriate changelog based on active tab
    local logs
    if activeTab == "stable" then
        logs = changelog
    elseif activeTab == "beta" then
        logs = beta_changelog
    else
        logs = lua_changelog
    end

    -- measure text total needed for window size
    local content_width, content_height = 0, 0
    for i = 1, amount do
        local title = logs[i][1]
        local tw, th = draw.GetTextSize(title)
        content_width = math.max(content_width, tw)
        content_height = content_height + th + spacing

        for j = 2, #logs[i] do
            tw, th = draw.GetTextSize(logs[i][j])
            content_width = math.max(content_width, tw)
            content_height = content_height + th + spacing
        end
        content_height = content_height + spacing
    end

    -- final window dimensions
    local win_w = content_width + padding_x * 2
    local win_h = content_height + padding_y * 2
    local win_x = (sw - win_w) // 2
    local win_y = (sh - win_h) // 2

    -- background window
    draw.Color(30, 30, 30, 253)
    draw.FilledRect(win_x, win_y, win_x + win_w, win_y + win_h)

    -- borders
    draw.Color(136, 192, 208, 255)
    draw.FilledRect(win_x, win_y - 21, win_x + win_w, win_y + 2) -- top
    draw.FilledRect(win_x, win_y + win_h - 2, win_x + win_w, win_y + win_h) -- bottom
    draw.FilledRect(win_x, win_y, win_x + 2, win_y + win_h) -- left
    draw.FilledRect(win_x + win_w - 2, win_y, win_x + win_w, win_y + win_h) -- right

    -- tabs
    local tabs = {"stable", "beta", "lua"}
    local tab_w, tab_h = 80, 20
    local tab_x = win_x + 5
    local tab_y = win_y - 19

    local mx, my = table.unpack(input.GetMousePos())
    for _, tab in ipairs(tabs) do
        local isActive = (activeTab == tab)
        draw.Color(136, 192, 208, 255)
        draw.FilledRect(tab_x, tab_y, tab_x + tab_w, tab_y + tab_h)

        local tw, th = draw.GetTextSize(tab)
        local tx = tab_x + (tab_w - tw)//2
        local ty = tab_y + (tab_h - th)//2
        draw.Color(236, 239, 244, 255)
        if (isActive) then
            TextShadow(tx, ty, string.format("( %s )", tab))
        else
            TextShadow(tx, ty, tab)
        end

        -- handle click
        if mx >= tab_x and mx <= tab_x + tab_w and my >= tab_y and my <= tab_y + tab_h then
            if input.IsButtonPressed(E_ButtonCode.MOUSE_LEFT) then
                activeTab = tab
            end
        end

        tab_x = tab_x + tab_w + 5
    end

    -- close button
    local btnw, btnh = 15, 15
    local btnx, btny = win_x + win_w - btnw - 5, win_y - 21 + ((21 - btnh)//2)

    draw.Color(191, 97, 106, 255)
    draw.FilledRect(btnx, btny, btnx + btnw, btny + btnh)

    local tw, th = draw.GetTextSize("x")
    draw.Color(255, 255, 255, 255)
    draw.Text(btnx + (btnw//2) - (tw//2), btny + (btnh//2) - (th//2), "x")

    if (mx >= btnx and mx <= btnx + btnw and my >= btny and my <= btny + btnh) then
        if (input.IsButtonDown(E_ButtonCode.MOUSE_LEFT)) then
            callbacks.Unregister("Draw", "changelog_window")
        end
    end

    -- draw log content
    local y = win_y + padding_y
    for i = 1, amount do
        local title = logs[i][1]
        tw, th = draw.GetTextSize(title)
        local tx = win_x + (win_w - tw)//2
        draw.Color(235, 203, 139, 255)
        draw.Text(tx, y, title)
        y = y + th + spacing

        for j = 2, #logs[i] do
            local text = logs[i][j]
            tw, th = draw.GetTextSize(text)
            tx = win_x + (win_w - tw)//2
            draw.Color(255, 255, 255, 255)
            draw.Text(tx, y, text)
            y = y + th + spacing
        end

        y = y + spacing
    end
end)