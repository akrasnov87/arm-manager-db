CREATE OR REPLACE FUNCTION core.sf_table_change_update(_c_table_name text, _f_user integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _c_table_name - имя таблицы
* @params {integer} _f_user - иднтификатор пользователя
*
* @returns {integer} - 0 результат выполнения
*
* @example
* [{ "action": "sf_table_change_update", "method": "Query", "data": [{ "params": [_c_table_name, _f_user] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	INSERT INTO core.sd_table_change (c_table_name, n_change, f_user) 
	VALUES (_c_table_name, (SELECT EXTRACT(EPOCH FROM now())), _f_user)
	ON CONFLICT (c_table_name, f_user) DO UPDATE 
	  SET c_table_name = _c_table_name, 
		  n_change = (SELECT EXTRACT(EPOCH FROM now())),
		  f_user = _f_user;
		  
	RETURN 0;
END
$$;

ALTER FUNCTION core.sf_table_change_update(_c_table_name text, _f_user integer) OWNER TO postgres;
