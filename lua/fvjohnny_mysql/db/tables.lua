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


function FVJOHNNY_MYSQL:CreateTable(table_alias, callback)
    local table_data, db = self:LoadTableData(table_alias)
    if not (table_data and db) then return false end

    // Create query string
    local query_string = string.Replace("CREATE TABLE IF NOT EXISTS %table_name% (\n", "%table_name%", table_data.table)
    for i=1, #table_data.columns do
        local column_data = table_data.columns[i]

        local column_string = "%column% %definition%,\n"
        column_string = string.Replace(column_string, "%column%", column_data.name)
        column_string = string.Replace(column_string, "%definition%", column_data.definition)

        query_string = query_string .. column_string
    end
    query_string = string.sub( query_string, 1, #query_string - 2)
    query_string = query_string .. ");"

    // Execute query
    self:Log("db_create_table", {table_alias=table_alias, table_name=table_data.table})
    self:Query(table_data.database, query_string, false, false, callback)
end

function FVJOHNNY_MYSQL:DeleteTable(table_alias, callback)
    local table_data, db = self:LoadTableData(table_alias)
    if not (table_data and db) then return false end

    // Create query string
    local query_string = string.Replace("DROP TABLE %table_name%;", "%table_name%", table_data.table)

    // Log message
    self:Log("db_delete_table", {table_alias=table_alias, table_name=table_data.table})

    // Execute query
    self:Query(table_data.database, query_string, false, false, callback)
end

function FVJOHNNY_MYSQL:LoadTableData(table_alias)
    // Load the config data for our table_alias
    local table_data = self.CFG.Tables[table_alias]
    if not table_data then self:LogError("db_table_missing_config", {table_alias=table_alias}) return false end

     // Get the DB connection assigned to this table
    local db = self:LoadDB(table_data.database)
    if not db then return false end

    return table_data, db
end