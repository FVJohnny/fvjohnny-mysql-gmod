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
if !SERVER then return end

require( "mysqloo" )

FVJOHNNY_MYSQL.DBs = FVJOHNNY_MYSQL.DBs or {}
function FVJOHNNY_MYSQL:ConnectDB(db_key)
    self:Log("db_connection", {db_key=db_key})

    local db_credentials = self:GetBDCredentials(db_key)
    if not db_credentials then return false end


    // Connect to the db
    local db = mysqloo.connect( db_credentials.host, db_credentials.user, db_credentials.password, db_credentials.database, db_credentials.port )
    self.DBs[db_key] = db

    // Database Connection Error
    function db:onConnectionFailed( err )
        FVJOHNNY_MYSQL:LogError("db_connection_error", {db_key=db_key, host=db_credentials.host, user=db_credentials.user, password=db_credentials.password, database=db_credentials.database, port=db_credentials.port, error=err})
    end

    // Database Connects succesfully
    function db:onConnected()
        FVJOHNNY_MYSQL:Log("db_connection_successful", {db_key=db_key})
    end

    db:connect()
end

function FVJOHNNY_MYSQL:GetBDCredentials(db_key)
    local db_credentials = self.CFG.DBCredentials[db_key]
    if not db_credentials then self:LogError("db_credentials_missing", {db_key=db_key}) return false end

    return db_credentials
end

function FVJOHNNY_MYSQL:LoadDB(db_key)
    if not self:GetBDCredentials(db_key) then return false end

    // Search for an already open db connection
    local db = self.DBs[db_key]
    if not db then self:LogError("db_query_to_disconnected_db", {db_key=db_key}) return false end

    return db
end