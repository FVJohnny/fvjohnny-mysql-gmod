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


function FVJOHNNY_MYSQL:CreateTable(db_key, table_key, callback)
    local db = self:LoadDB(db_key)
    if not db then return false end

    local table_data = self:LoadTableData(db_key, table_key)
    if not table_data then return false end

    // Create query string
    local query_string = string.Replace("CREATE TABLE IF NOT EXISTS %table_name% (\n", "%table_name%", table_key)
    for i=1, #table_data do
        local column_data = table_data[i]

        local column_string = string.Replace("%column% %definition%,\n", "%column%", column_data.column)
        column_string = string.Replace(column_string, "%definition%", column_data.definition)

        query_string = query_string .. column_string
    end
    query_string = string.sub( query_string, 1, #query_string - 2)
    query_string = query_string .. ");"

    // Execute query
    self:Log("db_table_created", {table_key=table_key})
    self:Query(db_key, query_string, false, false, callback)
end

function FVJOHNNY_MYSQL:DeleteTable(db_key, table_key, callback)
    local db = self:LoadDB(db_key)
    if not db then return false end

    local table_data = self:LoadTableData(db_key, table_key)
    if not table_data then return false end

    // Create query string
    local query_string = string.Replace("DROP TABLE %table_name%;", "%table_name%", table_key)

    // Execute query
    self:Log("db_table_deleted", {table_key=table_key})
    self:Query(db_key, query_string, false, false, callback)
end

function FVJOHNNY_MYSQL:LoadTableData(db_key, table_key)
    local table_data = self.CFG.Tables[db_key]
    if not table_data then self:LogError("db_table_missing_config", {db_key=db_key, table_key=table_key}) return false end

    table_data = table_data[table_key]
    if not table_data then self:LogError("db_table_missing_config", {db_key=db_key, table_key=table_key}) return false end

    return table_data
end