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


function FVJOHNNY_MYSQL:Query(db_key, query_string, isPrepared, delayExecution, callback)
    local db = self:LoadDB(db_key)
    if not db then return false end

    self:LogDebug("db_query_init", {db_key=db_key, is_prepared=isPrepared, query=query_string})
    // Create query
    local query = isPrepared and db:prepare(query_string) or db:query(query_string)

    // Query executes succesfully
    function query:onSuccess(data)
        FVJOHNNY_MYSQL:LogDebug("db_query_success", {db_key=db_key, query=query_string, data=util.TableToJSON(data)})

        callback(data)
    end

    // Query fails.
    function query:onError(err)
        FVJOHNNY_MYSQL:LogError("db_query_error", {db_key=db_key, query=query_string, error=err})

        callback(NULL, err)
    end

    if not delayExecution then query:start() end
    return query
end

function FVJOHNNY_MYSQL:PreparedQuery(db_key, query_string, query_data, callback)
    local preparedQuery = self:Query(db_key, query_string, true, true, callback)

    local i = 1
    for k,v in pairs(query_data) do
        self:PrepareQueryValue(preparedQuery, i, v)
        i = i + 1
    end

    preparedQuery:start()
end

function FVJOHNNY_MYSQL:Transaction(db_key, query_array, callback)
    local db = self:LoadDB(db_key)
    if not db then return false end

    // Start a transaction
    local transaction = db:createTransaction()
    
    // Add all the queries in query_array
    for _, query_string in pairs(query_array) do
        local query = self:Query(db_key, query_string, false, true, function() end)
        transaction:addQuery(query)
    end

    // Query executes succesfully
    function transaction:onSuccess()
        FVJOHNNY_MYSQL:Log("db_transaction_success", NULL, true)
        callback()
    end

    // Query fails.
    function transaction:onError(err)
        FVJOHNNY_MYSQL:LogError("db_transaction_error", {db_key=db_key, error=err})
        callback(NULL, err)
    end

    transaction:start()
end

function FVJOHNNY_MYSQL:Insert(table_alias, insert_data, callback)
    local table_data, db = self:LoadTableData(table_alias)
    if not (table_data and db) then return false end

    // Build the query string
    local query_string = string.Replace("INSERT INTO %table_name% (%column_names%) VALUES (%column_values%)", "%table_name%", table_data.table)
    local column_names, column_values = "", ""

    for column,value in pairs(insert_data) do
        column_names = column_names .. string.Replace("`%column_name%`, ", "%column_name%", column)
        column_values = column_values .. "?, "
    end
    column_names = string.sub( column_names, 1, #column_names - 2)
    column_values = string.sub( column_values, 1, #column_values - 2)
    query_string = string.Replace(query_string, "%column_names%", column_names)
    query_string = string.Replace(query_string, "%column_values%", column_values)

    return self:PreparedQuery(table_data.database, query_string, insert_data, callback)
end

function FVJOHNNY_MYSQL:Replace(table_alias, insert_data, callback)
    local table_data, db = self:LoadTableData(table_alias)
    if not (table_data and db) then return false end

    // Build the query string
    local query_string = string.Replace("REPLACE INTO %table_name% (%column_names%) VALUES (%column_values%)", "%table_name%", table_data.table)
    local column_names, column_values = "", ""

    for column,value in pairs(insert_data) do
        column_names = column_names .. string.Replace("`%column_name%`, ", "%column_name%", column)
        column_values = column_values .. "?, "
    end
    column_names = string.sub( column_names, 1, #column_names - 2)
    column_values = string.sub( column_values, 1, #column_values - 2)
    query_string = string.Replace(query_string, "%column_names%", column_names)
    query_string = string.Replace(query_string, "%column_values%", column_values)


    return self:PreparedQuery(table_data.database, query_string, insert_data, callback)
end

function FVJOHNNY_MYSQL:DeleteWhereEquals(table_alias, where_data, callback)
    local table_data, db = self:LoadTableData(table_alias)
    if not (table_data and db) then return false end
    
    // We probably wanna avoid disasters in this case...
    if #table.GetKeys(where_data) == 0 then self:LogError("db_delete_where_equals_no_params") return false end

    // Build the query string
    local query_string = string.Replace("DELETE FROM %table_name% WHERE (%where_query%)", "%table_name%", table_data.table)
    local where_query = ""

    for column,value in pairs(where_data) do
        where_query = where_query .. "`%column%` = ? AND "
        where_query = string.Replace(where_query, "%column%", column)
    end
    where_query = string.sub( where_query, 1, #where_query - 5)
    query_string = string.Replace(query_string, "%where_query%", where_query)

    return self:PreparedQuery(table_data.database, query_string, where_data, callback)
end

function FVJOHNNY_MYSQL:SelectWhereEquals(table_alias, select_data, callback)
    local table_data, db = self:LoadTableData(table_alias)
    if not (table_data and db) then return false end

    // Build the query string
    local query_string = string.Replace("SELECT * FROM %table_name% WHERE (%select_query%)", "%table_name%", table_data.table)
    local select_query = ""

    for column,value in pairs(select_data) do
        select_query = select_query .. "`%column%` = ? AND "
        select_query = string.Replace(select_query, "%column%", column)
    end
    select_query = string.sub( select_query, 1, #select_query - 5)
    query_string = string.Replace(query_string, "%select_query%", select_query)

    return self:PreparedQuery(table_data.database, query_string, select_data, callback)
end

function FVJOHNNY_MYSQL:PrepareQueryValue(query, param_pos, param_value)
    self:LogDebug("db_query_prepared_value", {param_pos=param_pos, param_value=param_value})

    local param_type = type(param_value)

    if param_type == "string" then query:setString(param_pos, param_value)
    elseif param_type == "number" then query:setNumber(param_pos, param_value)
    elseif param_type == "boolean" then query:setBoolean(param_pos, param_value)
    elseif param_type == "nil" then query:setNull(param_pos, param_value)
    else
        self:LogError("db_prepared_query_invalid_type", {type=param_type})
        return false
    end

    return true
end