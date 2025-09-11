local raw_link = "https://raw.githubusercontent.com/uosq/lbox-changelog-show/refs/heads/main/changelog_table.lua"

--- get the most 3 recent logs
local amount = 3

local changelog = load(http.Get(raw_link))()
assert(type(changelog) == "table", "Changelog is not a table!")

for i = 1, #changelog do
    local title = changelog[i][1]
    print(title)
    for j = 2, #changelog[i] do
        print(changelog[i][j])
    end

    print("---")
end

local font = draw.CreateFont("Arial", 12, 500)

callbacks.Register("Draw", function ()
    draw.SetFont(font)

    local sw, sh = draw.GetScreenSize()
    local y = nil

    for i = 1, amount do
        local title = changelog[i][1]
        local titlex
        local tw, th = draw.GetTextSize(title)
        titlex = ((sw * 0.5) - (tw * 0.5))//1
        if y == nil then
            y = ((sh * 0.5) - 200)//1
        end

        draw.Color(255, 255, 255, 255)
        draw.Text(titlex, y, title)
        y = y + th + 10

        for j = 2, #changelog[i] do
            tw, th = draw.GetTextSize(changelog[i][j])
            local x = ((sw*0.5) - (tw*0.5))//1

            draw.Color(0, 0, 0, 255)
            draw.FilledRect(x - 10, y - 10, x + (tw)//1 + 10, y + (th)//1 + 10)

            draw.Color(255, 255, 255, 255)

            draw.Text(x, y, changelog[i][j])
            y = y + th + 10
        end
    end
end)