--- made by navet

local raw_link = "https://raw.githubusercontent.com/uosq/lbox-changelog-show/refs/heads/main/changelog_table.lua"

-- amount of most recent logs to show
local amount = 3

local changelog = load(http.Get(raw_link))()
assert(type(changelog) == "table", "Changelog is not a table!")

local font = draw.CreateFont("TF2 BUILD", 12, 500)

-- padding around text inside window
local padding_x, padding_y = 15, 15
-- spacing between entries
local spacing = 8

callbacks.Register("Draw", "changelog", function ()
    draw.SetFont(font)

    local sw, sh = draw.GetScreenSize()

    -- measure text total needed for window size
    local content_width, content_height = 0, 0
    for i = 1, amount do
        local title = changelog[i][1]
        local tw, th = draw.GetTextSize(title)
        content_width = math.max(content_width, tw)
        content_height = content_height + th + spacing

        for j = 2, #changelog[i] do
            tw, th = draw.GetTextSize(changelog[i][j])
            content_width = math.max(content_width, tw)
            content_height = content_height + th + spacing
        end
        content_height = content_height + spacing -- extra gap between logs
    end

    -- final window dimensions
    local win_w = content_width + padding_x * 2
    local win_h = content_height + padding_y * 2
    local win_x = (sw - win_w) // 2
    local win_y = (sh - win_h) // 2

    -- background window
    draw.Color(30, 30, 30, 253)
    draw.FilledRect(win_x, win_y, win_x + win_w, win_y + win_h)

    -- border
    draw.Color(136, 192, 208, 255)
    draw.FilledRect(win_x, win_y - 21, win_x + win_w, win_y + 2) -- top
    draw.FilledRect(win_x, win_y + win_h - 2, win_x + win_w, win_y + win_h) -- bottom
    draw.FilledRect(win_x, win_y, win_x + 2, win_y + win_h) -- left
    draw.FilledRect(win_x + win_w - 2, win_y, win_x + win_w, win_y + win_h) -- right

    --- changelog text
    draw.Color(46, 52, 64, 255)
    local header = "changelog"
    local hw, hh = draw.GetTextSize(header)
    local hx = win_x + (win_w - hw)//2
    local hy = win_y - 20 + ((20 - hh)//2)
    draw.Text(hx, hy, header)

    -- draw text
    local y = win_y + padding_y
    for i = 1, amount do
        -- title
        local title = changelog[i][1]
        local tw, th = draw.GetTextSize(title)
        local tx = win_x + (win_w - tw)//2
        draw.Color(235, 203, 139, 255) -- yellowish for titles
        draw.Text(tx, y, title)
        y = y + th + spacing

        -- entries
        for j = 2, #changelog[i] do
            local text = changelog[i][j]
            tw, th = draw.GetTextSize(text)
            tx = win_x + (win_w - tw)//2

            draw.Color(255, 255, 255, 255)
            draw.Text(tx, y, text)

            y = y + th + spacing
        end

        y = y + spacing -- extra space between logs
    end

    local btnw, btnh = 15, 15
    local btnx, btny = win_x + win_w - btnw - 5, win_y - 21 + ((21 - btnh)//2)

    draw.Color(191, 97, 106, 255)
    draw.FilledRect(btnx, btny, btnx + btnw, btny + btnh)

    local tw, th = draw.GetTextSize("x")
    draw.Color(255, 255, 255, 255)
    draw.Text(btnx + (btnw//2) - (tw//2), btny + (btnh//2) - (th//2), "x")

    local m = input.GetMousePos()
    local mx, my = m[1], m[2]

    if (mx >= btnx and mx <= btnx + btnw and my >= btny and my <= btny + btnh) then
        if (input.IsButtonDown(E_ButtonCode.MOUSE_LEFT)) then
            callbacks.Unregister("Draw", "changelog")
        end
    end
end)
