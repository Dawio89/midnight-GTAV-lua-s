local json = require("lib/json") or print('json lib not found')
local time = system.time() + 5
local currentIndex = 1
local players = player.get_hosts_queue()

function OnFrame()
    if time < system.time() then
        if currentIndex <= #players then
            local ply = players[currentIndex]
            local ply_ip = player.get_resolved_ip_string(ply)

            if ply_ip == "0.0.0.0" then
                currentIndex = currentIndex + 1 
            else
                http.get("http://ip-api.com/json/"..ply_ip, function(code, headers, content)
                    if code == 200 then

                        data = json.decode(content)

                        country = data.country
                        country_flag = data.countryCode
                        city = data.city

                            ply.flags.create(true, country_flag, country, 255, 0, 0)
                            print(player.get_name(ply).." is from "..country.." ("..city..") and has been assigned a "..country_flag.." flag")
                    else
                        print("Failed to fetch IP information for: "..ply_ip.." code "..code)
                    end
                    currentIndex = currentIndex + 1
                end)
            end
        end
        time = system.time() + 5
    end
end
