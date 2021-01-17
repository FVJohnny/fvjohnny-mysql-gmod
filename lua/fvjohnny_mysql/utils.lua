/*


███████╗██╗░░░██╗░░░░░██╗░█████╗░██╗░░██╗███╗░░██╗███╗░░██╗██╗░░░██╗  ███╗░░░███╗██╗░░░██╗░██████╗░██████╗░██╗
██╔════╝██║░░░██║░░░░░██║██╔══██╗██║░░██║████╗░██║████╗░██║╚██╗░██╔╝  ████╗░████║╚██╗░██╔╝██╔════╝██╔═══██╗██║
█████╗░░╚██╗░██╔╝░░░░░██║██║░░██║███████║██╔██╗██║██╔██╗██║░╚████╔╝░  ██╔████╔██║░╚████╔╝░╚█████╗░██║██╗██║██║
██╔══╝░░░╚████╔╝░██╗░░██║██║░░██║██╔══██║██║╚████║██║╚████║░░╚██╔╝░░  ██║╚██╔╝██║░░╚██╔╝░░░╚═══██╗╚██████╔╝██║
██║░░░░░░░╚██╔╝░░╚█████╔╝╚█████╔╝██║░░██║██║░╚███║██║░╚███║░░░██║░░░  ██║░╚═╝░██║░░░██║░░░██████╔╝░╚═██╔═╝░███████╗
╚═╝░░░░░░░░╚═╝░░░░╚════╝░░╚════╝░╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚══╝░░░╚═╝░░░  ╚═╝░░░░░╚═╝░░░╚═╝░░░╚═════╝░░░░╚═╝░░░╚══════╝

░█████╗░░█████╗░░█████╗░███████╗░██████╗░██████╗  ██╗░░░░░░█████╗░██╗░░░██╗███████╗██████╗░
██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝  ██║░░░░░██╔══██╗╚██╗░██╔╝██╔════╝██╔══██╗
███████║██║░░╚═╝██║░░╚═╝█████╗░░╚█████╗░╚█████╗░  ██║░░░░░███████║░╚████╔╝░█████╗░░██████╔╝
██╔══██║██║░░██╗██║░░██╗██╔══╝░░░╚═══██╗░╚═══██╗  ██║░░░░░██╔══██║░░╚██╔╝░░██╔══╝░░██╔══██╗
██║░░██║╚█████╔╝╚█████╔╝███████╗██████╔╝██████╔╝  ███████╗██║░░██║░░░██║░░░███████╗██║░░██║
╚═╝░░╚═╝░╚════╝░░╚════╝░╚══════╝╚═════╝░╚═════╝░  ╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═╝░░╚═╝

    @Author: FVJohnny  http://steamcommunity.com/id/FVJohnny/
*/


if !FVJOHNNY_MYSQL then return end

function FVJOHNNY_MYSQL:Log(messageCode, messageArgs)
    if isDebug and not self.CFG.DEBUG_MODE then return end

    local text = self:Language(messageCode, messageArgs)

    print("\n\n")
    print("[FVJOHNNY_MYSQL] " .. text)
    print("\n\n")
end

function FVJOHNNY_MYSQL:LogDebug(messageCode, messageArgs)
    if isDebug and not self.CFG.DEBUG_MODE then return end

    return self:Log(messageCode, messageArgs)
end

function FVJOHNNY_MYSQL:LogError(messageCode, messageArgs)
    local text = self:Language(messageCode, messageArgs)

    print("\n\n")
    print("[FVJOHNNY_MYSQL] ERROR ERROR ERROR ERROR ERROR ERROR.")
    ErrorNoHalt("[FVJOHNNY_MYSQL] " .. text)
    local trace = debug.Trace()
    if trace then
        print("[FVJOHNNY_MYSQL]  Call Stack:" .. debug.Trace())
    end
    print("\n\n")
end

function FVJOHNNY_MYSQL:Language(messageCode, messageArgs)

    local message = self.CFG.Language[messageCode]
    if not message then return end

    messageArgs = messageArgs or {}

    for needle,text in pairs(messageArgs) do
        message = string.Replace(message, "%"..needle.."%", tostring(text))
    end

    return message
end

function FVJOHNNY_MYSQL:Notify(ply, messageCode, messageArgs)
    if not IsValid(ply) then return end

    local message = self:Language(messageCode, messageArgs)
    DarkRP.notify(ply, 1, 3, message)
    ply:ChatPrint("[FVJOHNNY_MYSQL]: " .. message)
end
