--natives
util.require_natives("1640181023")

--client resolution/aspect ratio
local res_x, res_y = directx.get_client_size()
local ASPECT_RATIO <const> = res_x/res_y

--set position
local gui_x = 0
local gui_y = 0

--set colours
local colour =
{
    title_bar = {r = 1, g = 0, b = 1, a = 1},
    background = {r = 0, g = 0, b = 0, a = 77/255},
    health_bar = {r = 114/255, g = 204/255, b = 114/255, a = 150/255},
    armour_bar = {r = 70/255, g = 136/255, b = 171/255, a = 150/255},
    blip = {r = 1, g = 1, b = 1, a = 1},
    name = {r = 1, g = 1, b = 1, a = 1},
    label = {r = 1, g = 1, b = 1, a = 1},
    info = {r = 1, g = 1, b = 1, a = 1},
    border = {r = 1, g = 0, b = 1, a = 1}
}

--settings element sizing & spacing
local name_h = 0.022
local padding = 0.008
local spacing = 0.003
local gui_w = 0.16

--settings text sizing & spacing
local name_size = 0.52
local text_size = 0.41
local line_spacing = 0.0032

--settings border
local border_width = 0

--settings blur
local blur_strength = 4
local blur = {}
for i = 1, 8 do blur[i] = directx.blurrect_new() end

--map textures
local textures =
{
    map = directx.create_texture(filesystem.resources_dir() .. "Map.png"),
    blip = directx.create_texture(filesystem.resources_dir() .. "Blip.png")
}

--render window toggle
local render_window = false
local infoverlay = menu.attach_before(menu.ref_by_path("Players>Settings>Tags"), menu.list(menu.shadow_root(), SCRIPT_NAME.." Settings", {}, "", 
function()
    render_window = true 
end, 
function()
    render_window = false
end))

--settings
menu.action(menu.my_root(), "Players > Settings > "..SCRIPT_NAME.." Settings", {}, "Shortcut to the settings for the overlay.", function(on_click)
    menu.trigger_command(infoverlay)
end)

--set position
menu.divider(infoverlay, "Position")
menu.slider_float(infoverlay, "X:", {"overlayx"}, "Horizontal position of the info overlay.", 0, 1000, 0, 1, function(s)
    gui_x = s/1000
end)
menu.slider_float(infoverlay, "Y:", {"overlayy"}, "Vertical position of the info overlay.", 0, 1000, 0, 1, function(s)
    gui_y = s/1000
end)

--appearance divider
menu.divider(infoverlay, "Appearance")

--set colours
local colours = menu.list(infoverlay, "Overlay colours", {}, "")

menu.divider(colours, "Elements")

menu.colour(colours, "Title Bar Colour", {"overlaytitle_bar"}, "Colour of the title bar.", colour.title_bar, true, function(on_change)
    colour.title_bar = on_change
end)
menu.colour(colours, "Background Colour", {"overlaybg"}, "Colour of the background.", colour.background, true, function(on_change)
    colour.background = on_change
end)
menu.colour(colours, "Health Bar Colour", {"overlayhealth_bar"}, "Colour of the health bar.", colour.health_bar, true, function(on_change)
    colour.health_bar = on_change
end)
menu.colour(colours, "Armour Bar Colour", {"overlayarmour_bar"}, "Colour of the armour bar.", colour.armour_bar, true, function(on_change)
    colour.armour_bar = on_change
end)
menu.colour(colours, "Blip Colour", {"overlayblip"}, "Colour of the map blip.", colour.blip, true, function(on_change)
    colour.blip = on_change
end)

menu.divider(colours, "Text")
menu.colour(colours, "Name Colour", {"overlayname"}, "Colour of the player name text.", colour.name, true, function(on_change)
    colour.name = on_change
end)
menu.colour(colours, "Label Colour", {"overlaylabel"}, "Colour of the label text.", colour.label, true, function(on_change)
    colour.label = on_change
end)
menu.colour(colours, "Info Colour", {"overlayinfo"}, "Colour of the info text.", colour.info, true, function(on_change)
    colour.info = on_change
end)

--set element sizing & spacing
local element_dim = menu.list(infoverlay, "Element Sizing & Spacing", {}, "")

menu.divider(element_dim, "Element Sizing & Spacing")

menu.slider(element_dim, "Title Bar Height", {}, "Height of the title bar.", 0, 100, 22, 1, function(on_change)
    name_h = on_change/1000
end)
menu.slider(element_dim, "Overlay Width", {}, "Width of the text window minus the padding.", 0, 50, 16, 1, function(on_change)
    gui_w = on_change/100
end)
menu.slider(element_dim, "Padding", {}, "Padding around the info text.", 0, 30, 8, 1, function(on_change)
    padding = on_change/1000
end)
menu.slider(element_dim, "Spacing", {}, "Spacing of the different elements.", 0, 20, 3, 1, function(on_change)
    spacing = on_change/1000
end)

--set text sizing & spacing
local text_dim = menu.list(infoverlay, "Text Sizing & Spacing", {}, "")

menu.divider(text_dim, "Text Sizing & Spacing")

menu.slider_float(text_dim, "Name", {}, "Size of the player name text.", 0, 100, 52, 1, function(on_change)
    name_size = on_change/100
end)
menu.slider_float(text_dim, "Info Text", {}, "Size of the info text.", 0, 100, 41, 1, function(on_change)
    text_size = on_change/100
end)
menu.slider(text_dim, "Line Spacing", {}, "Spacing inbetween lines of info text.", 0, 100, 32, 1, function(on_change)
    line_spacing = on_change/10000
end)

--set border
local border = menu.list(infoverlay, "Border", {}, "")

menu.divider(border, "Border Settings")

menu.slider(border, "Width", {}, "Width of the border rendered around the elements.", 0, 20, 0, 1, function(on_change)
    border_width = on_change/1000
end)
local border_c_slider = menu.colour(border, "Colour", {"overlayborder"}, "Colour of the rendered border.", colour.border, true, function(on_change)
    colour.border = on_change
end)
menu.rainbow(border_c_slider)

--set blur
menu.slider(infoverlay, "Background Blur", {}, "Amount of blur applied to background.", 0, 255, 4, 1, function(on_change)
    blur_strength = on_change
end)

--restart script
menu.action(infoverlay, "Restart Script", {}, "", function()
    util.restart_script()
end)

--draw functions
local function drawRect(x, y, w, h, colour)
    directx.draw_rect(x, y, w, h, 
    {r = colour.r * colour.a, g = colour.g * colour.a, b = colour.b * colour.a, a = colour.a})
end

local function drawBorder(x, y, width, height)
    local border_x = border_width/ASPECT_RATIO
    drawRect(x - border_x, y, width + border_x * 2, -border_width, colour.border) --top
    drawRect(x, y, -border_x, height, colour.border) --left
    drawRect(x + width, y, border_x, height, colour.border) --right
    drawRect(x - border_x, y + height, width + border_x * 2, border_width, colour.border) --bottom
end

--rounding function
local function roundNum(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

--weapon function (from lance)
local all_weapons = {}
local temp_weapons = util.get_weapons()
for a, b in pairs(temp_weapons) do
    all_weapons[#all_weapons + 1] = {hash = b["hash"], label_key = b["label_key"]}
end
local function hashToWeapon(hash) 
    for k, v in pairs(all_weapons) do 
        if v.hash == hash then 
            return util.get_label_text(v.label_key)
        end
    end
    return "Unarmed"
end

--boolean function
local function boolText(bool)
    if bool then return "Yes" else return "No" end
end

--check function
local function checkValue(pInfo)
    if pInfo == "" or pInfo == 0 or pInfo == nil or pInfo == "NULL" then return "None" else return pInfo end 
end

--format money
local function formatMoney(money)
    local order = math.ceil(string.len(tostring(money))/3 - 1)
    if order == 0 then return money end
    return roundNum(money/(1000^order), 1)..({"K", "M", "B"})[order]
end

while true do
    if true then
        local focused = players.get_focused()
        if ((focused[1] ~= nil and focused[2] == nil) or render_window) and menu.is_open() then

            --general info grabbing locals
            local pid = focused[1]
            if render_window then pid = players.user() end
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local my_pos, player_pos = players.get_position(players.user()), players.get_position(pid)
            
            --general element drawing locals
            local spacing_x = spacing/ASPECT_RATIO
            local padding_x = padding/ASPECT_RATIO
            local player_list_y = gui_y + name_h + spacing
            local total_w = gui_w + padding_x * 4

            -------------
            -- CONTENT --
            -------------

            local heading = ENTITY.GET_ENTITY_HEADING(ped)

            local regions = 
            {
                {
                    width = total_w/2,
                    content =
                    {
                        {"Rank", players.get_rank(pid)},
                        {"K/D", roundNum(players.get_kd(pid), 2)},
                        {"Wallet", "$"..formatMoney(players.get_wallet(pid))},
                        {"Bank", "$"..formatMoney(players.get_bank(pid))}
                    }
                },
                {
                    width = total_w/2,
                    content =
                    {
                        {"Language", ({"English","French","German","Italian","Spanish","Brazilian","Polish","Russian","Korean","Chinese (T)","Japanese","Mexican","Chinese (S)"})[players.get_language(pid) + 1]},
                        {"Controller", boolText(players.is_using_controller(pid))},
                        {"Ping", math.floor(NETWORK._NETWORK_GET_AVERAGE_LATENCY_FOR_PLAYER(pid) + 0.5).." ms"},
                        {"Host Queue", "#"..players.get_host_queue_position(pid)},
                    }
                },
                {
                    width = total_w + spacing_x,
                    content =
                    {
                        {"Model", util.reverse_joaat(ENTITY.GET_ENTITY_MODEL(ped))},
                        {"Zone", util.get_label_text(ZONE.GET_NAME_OF_ZONE(player_pos.x, player_pos.y, player_pos.z))},
                        {"Weapon", hashToWeapon(WEAPON.GET_SELECTED_PED_WEAPON(ped))},
                        {"Vehicle", checkValue(util.get_label_text(players.get_vehicle_model(pid)))}
                    }
                },
                {
                    width = total_w/2,
                    content =
                    {
                        {"Distance", math.floor(MISC.GET_DISTANCE_BETWEEN_COORDS(player_pos.x, player_pos.y, player_pos.z, my_pos.x, my_pos.y, my_pos.z)).." m"},
                        {"Speed", math.floor(ENTITY.GET_ENTITY_SPEED(ped) * 3.6).." km/h"},
                        {"Going", ({"North","West","South","East","North"})[math.ceil((heading + 45)/90)]..", "..math.ceil(heading).."°"}
                    }
                },
                {
                    width = total_w/2,
                    content =
                    {
                        {"Organization", ({"None","CEO","MC"})[players.get_org_type(pid) + 2]},
                        {"Wanted", PLAYER.GET_PLAYER_WANTED_LEVEL(pid).."/5"},
                        {"Cutscene", boolText(NETWORK.IS_PLAYER_IN_CUTSCENE(pid))}
                    }
                },
                {
                    width = total_w + spacing_x,
                    content =
                    {
                        {"Tags", checkValue(players.get_tags_string(pid))}
                    }
                }
            }

            ---------------------
            -- DRAWING CONTENT --
            ---------------------

            local font_w, font_h = directx.get_text_size("abcdefg", text_size)
            local offset_x = 0
            local offset_y = 0
            
            for k, region in ipairs(regions) do
                local blur_instance = 1
                local count = 0
                for _ in region.content do count = count + 1 end
                local dict_h = count * (font_h + line_spacing) - line_spacing + padding * 2

                drawBorder(gui_x + offset_x, player_list_y + offset_y, region.width, dict_h)
                directx.blurrect_draw(blur[blur_instance], gui_x + offset_x, player_list_y + offset_y, region.width, dict_h, blur_strength)
                drawRect(gui_x + offset_x, player_list_y + offset_y, region.width, dict_h, colour.background)

                local line_count = 0
                for _, v in ipairs(region.content) do
                    directx.draw_text(
                    gui_x + offset_x + padding_x - 0.001, 
                    player_list_y + offset_y + padding + line_count * (font_h + line_spacing), 
                    v[1]..": ",
                    ALIGN_TOP_LEFT, 
                    text_size, 
                    colour.label
                    )
                    directx.draw_text(
                    gui_x + offset_x + region.width - padding_x - 0.001, 
                    player_list_y + offset_y + padding + line_count * (font_h + line_spacing), 
                    v[2], 
                    ALIGN_TOP_RIGHT, 
                    text_size, 
                    colour.info
                    )
                    line_count += 1
                end

                offset_x += region.width + spacing_x
                if offset_x >= total_w then
                    offset_y += dict_h + spacing
                    offset_x = 0
                end
                blur_instance += 1
            end

            --[[
                REST LOCALS 
            --]]

            local gui_h = offset_y - spacing
            local bar_w = gui_h/50
            local map_x = gui_x + total_w + spacing_x * 2
            local map_w = gui_h/(898/590)/ASPECT_RATIO + 0.001
            local map_w_total = map_w + padding_x * 3 + bar_w

            --[[ NAME BAR ]]

            drawBorder(gui_x, gui_y, total_w + spacing_x, name_h)

            directx.blurrect_draw(blur[6], gui_x, gui_y, total_w, name_h, blur_strength)

            drawRect(gui_x, gui_y, total_w + spacing_x, name_h, colour.title_bar)

            directx.draw_text(gui_x + total_w/2, gui_y + name_h/2, players.get_name(pid), ALIGN_CENTRE, name_size, colour.name)

            ---------------
            -- EMPTY BAR --
            ---------------

            drawBorder(map_x, gui_y, map_w_total, name_h)

            directx.blurrect_draw(blur[7], map_x, gui_y, map_w_total, name_h, blur_strength)

            drawRect(map_x, gui_y, map_w_total, name_h, colour.title_bar)

            ---------
            -- MAP --
            ---------

            --border, blur, background
            drawBorder(map_x, player_list_y, map_w_total, gui_h)

            directx.blurrect_draw(blur[8], map_x, player_list_y, map_w_total, gui_h, blur_strength)

            drawRect(map_x, player_list_y, map_w_total, gui_h, colour.background)

            --map
            directx.draw_texture(textures.map, map_w/2, 0, 0, 0, map_x + padding_x * 2 + bar_w, player_list_y, 0, 1, 1, 1, 0.75)

            --blip
            directx.draw_texture(textures.blip, 0.004, 0, 0.5, 0.5, map_x + padding_x * 2 + bar_w + ((player_pos.x + 4000)/8500) * map_w, player_list_y + (1 - (player_pos.y + 4000)/12000) * gui_h, (360 - heading)/360, colour.blip)

            -------------------------
            -- HEALTH & ARMOUR BAR --
            -------------------------

            --armour bar
            local armour_perc = PED.GET_PED_ARMOUR(ped)/PLAYER.GET_PLAYER_MAX_ARMOUR(pid)
            local armour_bar_bg = {r = colour.armour_bar.r/2, g = colour.armour_bar.g/2, b = colour.armour_bar.b/2, a = colour.armour_bar.a}

            drawRect(map_x + padding_x, player_list_y + gui_h/2 - padding/2, bar_w, -((gui_h - padding * 3)/2 * armour_perc), colour.armour_bar) --foreground
            drawRect(map_x + padding_x, player_list_y + padding, bar_w, (gui_h - padding * 3)/2 * (1 - armour_perc), armour_bar_bg) --background

            --health bar
            local health_min = ENTITY.GET_ENTITY_HEALTH(ped) - 100
            if health_min < 0 then health_min = 0 end

            local health_perc = health_min/(ENTITY.GET_ENTITY_MAX_HEALTH(ped) - 100)
            local health_bar_bg = {r = colour.health_bar.r/2, g = colour.health_bar.g/2, b = colour.health_bar.b/2, a = colour.health_bar.a}

            drawRect(map_x + padding_x, player_list_y + gui_h - padding, bar_w, -((gui_h - padding * 3)/2 * health_perc), colour.health_bar) --foreground
            drawRect(map_x + padding_x, player_list_y + gui_h/2 + padding/2, bar_w, (gui_h - padding * 3)/2 * (1 - health_perc), health_bar_bg) --background
        end
    end
    util.yield()
end