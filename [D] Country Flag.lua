local json = require("lib/json") or print('json lib not found')
local time = system.time() + 5
local currentIndex = 1
local players = player.get_hosts_queue()
local previousPlayer = nil
local checkPlayer = nil

function OnFrame()
    if time < system.time() then
        if currentIndex <= #players then
            local ply = players[currentIndex]
            local ply_ip = player.get_resolved_ip_string(ply)
            if ply_ip == player.get_resolved_ip_string(1) then
                ply_ip = player.get_resolved_ip_string(ply)
            end

            if ply_ip == "0.0.0.0" or ply_ip == "" then
                currentIndex = currentIndex + 1
            elseif ply == previousPlayer then
                currentIndex = currentIndex + 1
            else
                previousPlayer = ply
                print("~ Fetching information for: "..player.get_name(ply).." | IP: "..ply_ip)
                http.get("http://ip-api.com/json/"..ply_ip, function(code, headers, content)
                    if code == 200 then

                        local data = json.decode(content)

                        local country = data["country"]
                        local countryCode = data["countryCode"]
                        local regionName = data["regionName"]
                        local city = data["city"]
                        local isp = data["isp"]

                        if country == "Poland" then
                            utils.notify("Polando Detectorio", player.get_name(ply).." is from Poland!", 2, 3)
                                print(player.get_name(ply).." is from Poland!")
                                print("------------------------------------")
                                print(country.." | "..countryCode.." | "..city.." | "..regionName.." | "..isp.." | "..ply_ip.."\n")
                        elseif country == "Russia" then
                            utils.notify("Anti-KGB", player.get_name(ply).." is from Russia! Kicking...", 2, 3)
                                print(player.get_name(ply).." is from Russia!")
                                print("------------------------------------")
                                print(country.." | "..countryCode.." | "..city.." | "..regionName.." | "..isp.." | "..ply_ip.."\n")
                                print("Kicking attempt...")
                            player.kick_brute(ply)
                        else
                            print(player.get_name(ply).." is from "..country)
                        end
                        local flagId = player.flags.create(
                            function(checkPlayer)
                                return checkPlayer == ply
                            end,
                            "["..countryCode.."]",
                            country,
                            255,
                            255,
                            255
                        )
                    else
                        print("~ Failed to fetch IP information for: "..ply_ip.." code "..code)
                        print(" ")
                    end
                    currentIndex = currentIndex + 1
                end)
            end
        end
        time = system.time() + 5
    end
end
