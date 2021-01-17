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

FVJOHNNY_MYSQL.CFG = FVJOHNNY_MYSQL.CFG or {}

// IF TRUE ===> IT WILL PRINT LOGS EVEN FOR SUCCESSFUL QUERIES. IT WILL ALSO PRINT ALL THE RETRIEVED DATA FROM THOSE QUERIES
FVJOHNNY_MYSQL.CFG.DEBUG_MODE = true; 

-------- DBS --------
FVJOHNNY_MYSQL.CFG.DBCredentials = {
    HOGWARTS = { host = "195.154.170.42", database = "s58_johhny", user = "u58_2wGZl82IVa", password = "J21Y3QCTAmdhOeb6t185dPy2", port = 3306, connectOnStartup = true },
}

FVJOHNNY_MYSQL.CFG.Tables = {
    /*
    ANOTHER_EXAMPLE = {
        database = "CHOOSE FROM FVJOHNNY_MYSQL.CFG.DBCredentials"
        table = "my_mysql_table",
        columns = { 
            {name = "id", definition = "INT PRIMARY KEY"},
            {name = "info", definition = "VARCHAR(32)"},
        }
    },
    */
    WANDS_SPELLS = {
        database = "HOGWARTS",
        table = "chronos_wands_spells",
        columns = { 
            {name = "user_steamid", definition = "VARCHAR(32)"},
            {name = "spell", definition = "VARCHAR(32)"},
            {name = "learnable", definition = "BOOLEAN"},
            {name = "", definition = "PRIMARY KEY(user_steamid, spell)"},
        }
    },
}



FVJOHNNY_MYSQL.CFG.Language = {
    ["db_connection"] = "Se ha intentado conectar con la DB: %db_key%",
    ["db_connection_successful"] = "Se ha conectado satisfactoriamente a la DB: %db_key%",
    ["db_connection_error"] = "Ha habido un error al conectar con la DB. \nCredenciales: (%host%, %database%, %user%, %password%, %port%)\nError: %error%",
    ["db_credentials_missing"] = "Se ha intentado conectar una DB no configurada en config.lua: %db_key%",
    
    ["db_query_to_missing_db"] = "Se ha intentado hacer una query a una DB configurada en no config.lua: %db_key%",
    ["db_query_to_disconnected_db"] = "Se ha intentado hacer una query a una DB no conectada. \nDB: %db_key%\n Query: %query%",
    ["db_query_error"] = "Ha habido un error en una query. \nDB: %db_key% \nQuery: %query% \nError: %error%",
    ["db_transaction_error"] = "Ha habido un error en una transaccion. \nDB: %db_key% \nError: %error%",
    ["db_prepared_query_invalid_type"] = "Se ha intentado almacenar un valor de tipo invalido: %type%",

    ["db_delete_where_equals_no_params"] = "Se ha intentado llamar a FVJOHNNY_MYSQL:DeleteWhereEquals con where_data = {}",


    ["db_table_missing_config"] = "ALIAS DE TABLA NO EXISTENTE. TABLE ALIAS: %table_alias%",
    ["db_create_table"] = "Vamos a intentar CREAR una tabla nueva. \nTABLE ALIAS: %table_alias% \nTABLE: %table_name%",
    ["db_delete_table"] = "Vamos a intentar BORRAR la tabla tabla. \nTABLE ALIAS: %table_alias% \nTABLE: %table_name%",

    // debug mode = true
    ["db_query_init"] = "Se ha inicializado una query. \nDB: %db_key%\nPrepared: %is_prepared%\nQuery: %query%",
    ["db_query_success"] = "Se ha realizado una query con exito. \nDB: %db_key%\nQuery: %query%\nData: %data%",
    ["db_query_prepared_value"] = "Se ha preparado el valor de un parametro de query. \nPos: %param_pos%\nValue: %param_value%",

    ["db_transaction_success"] = "Se ha finalizado una transaccion con exito.",
}