SET TIMEZONE TO 'UTC';

SET check_function_bodies = false;

START TRANSACTION;

SET search_path = pg_catalog;

CREATE SCHEMA core;

ALTER SCHEMA core OWNER TO mobnius;

REVOKE ALL ON SCHEMA public FROM PUBLIC;

REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO mobnius;
GRANT ALL ON SCHEMA public TO PUBLIC;

CREATE EXTENSION pg_stat_statements SCHEMA public;

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';

CREATE EXTENSION plv8 SCHEMA pg_catalog;

COMMENT ON EXTENSION plv8 IS 'PL/JavaScript (v8) trusted procedural language';

CREATE EXTENSION "uuid-ossp" SCHEMA public;

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';

CREATE SEQUENCE core.auto_id_cd_settings
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.auto_id_cd_settings OWNER TO mobnius;

CREATE SEQUENCE core.auto_id_cs_setting_types
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.auto_id_cs_setting_types OWNER TO mobnius;

CREATE SEQUENCE core.auto_id_pd_accesses
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.auto_id_pd_accesses OWNER TO mobnius;

CREATE SEQUENCE core.auto_id_pd_roles
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.auto_id_pd_roles OWNER TO mobnius;

CREATE SEQUENCE core.auto_id_pd_userinroles
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.auto_id_pd_userinroles OWNER TO mobnius;

CREATE SEQUENCE core.auto_id_pd_users
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.auto_id_pd_users OWNER TO mobnius;

-- DEPCY: This SEQUENCE is a dependency of COLUMN: core.sd_table_change.id

CREATE SEQUENCE core.sd_table_change_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.sd_table_change_id_seq OWNER TO mobnius;

CREATE TABLE core.sd_table_change (
	c_table_name text NOT NULL,
	n_change double precision NOT NULL,
	f_user integer,
	id bigint DEFAULT nextval('core.sd_table_change_id_seq'::regclass) NOT NULL
);

ALTER TABLE core.sd_table_change OWNER TO mobnius;

COMMENT ON TABLE core.sd_table_change IS 'Изменение состояния таблицы';

COMMENT ON COLUMN core.sd_table_change.c_table_name IS 'Имя таблицы';

COMMENT ON COLUMN core.sd_table_change.n_change IS 'Версия изменения';

-- DEPCY: This SEQUENCE is a dependency of COLUMN: core.sd_table_change_ref.id

CREATE SEQUENCE core.sd_table_change_ref_id_seq
	AS smallint
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.sd_table_change_ref_id_seq OWNER TO mobnius;

CREATE TABLE core.sd_table_change_ref (
	id smallint DEFAULT nextval('core.sd_table_change_ref_id_seq'::regclass) NOT NULL,
	c_table_name text NOT NULL,
	c_table_name_ref text NOT NULL
);

ALTER TABLE core.sd_table_change_ref OWNER TO mobnius;

COMMENT ON TABLE core.sd_table_change_ref IS 'Зависимость таблиц состояний';

COMMENT ON COLUMN core.sd_table_change_ref.c_table_name IS 'Таблица';

COMMENT ON COLUMN core.sd_table_change_ref.c_table_name_ref IS 'Зависимая таблица';

CREATE TABLE core.cd_action_log (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	c_table_name text,
	c_operation text,
	jb_old_value jsonb,
	jb_new_value jsonb,
	c_user text,
	d_date timestamp with time zone
);

ALTER TABLE core.cd_action_log OWNER TO mobnius;

COMMENT ON TABLE core.cd_action_log IS 'Логирование действий пользователей с данными. Полная информация';

COMMENT ON COLUMN core.cd_action_log.c_table_name IS 'Имя таблицы в которой произошли изменения';

COMMENT ON COLUMN core.cd_action_log.c_operation IS 'Тип операции, INSERT, UPDATE, DELETE';

COMMENT ON COLUMN core.cd_action_log.jb_old_value IS 'Предыдущие данные';

COMMENT ON COLUMN core.cd_action_log.jb_new_value IS 'Новые данные';

COMMENT ON COLUMN core.cd_action_log.c_user IS 'Учетная запись';

COMMENT ON COLUMN core.cd_action_log.d_date IS 'Дата события';

CREATE TABLE core.cd_action_log_user (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	integer_id bigint,
	uuid_id uuid,
	c_action text NOT NULL,
	c_method text,
	d_date timestamp with time zone DEFAULT now() NOT NULL,
	f_user integer DEFAULT '-1'::integer NOT NULL,
	jb_data jsonb NOT NULL
);

ALTER TABLE core.cd_action_log_user OWNER TO mobnius;

COMMENT ON TABLE core.cd_action_log_user IS 'Логирование запросов пользователя';

COMMENT ON COLUMN core.cd_action_log_user.integer_id IS 'Идентификатор';

COMMENT ON COLUMN core.cd_action_log_user.uuid_id IS 'Идентификатор';

COMMENT ON COLUMN core.cd_action_log_user.c_action IS 'Имя таблицы';

COMMENT ON COLUMN core.cd_action_log_user.c_method IS 'Метод';

COMMENT ON COLUMN core.cd_action_log_user.f_user IS 'Пользователь';

CREATE TABLE core.cd_results (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	fn_user_point uuid NOT NULL,
	fn_point uuid NOT NULL,
	fn_type integer NOT NULL,
	fn_user integer NOT NULL,
	fn_route uuid NOT NULL,
	d_date timestamp with time zone NOT NULL,
	c_notice text,
	b_warning boolean DEFAULT false NOT NULL,
	jb_data jsonb,
	dx_created timestamp with time zone DEFAULT now(),
	b_disabled boolean NOT NULL,
	jb_answers jsonb
);

ALTER TABLE core.cd_results OWNER TO mobnius;

COMMENT ON TABLE core.cd_results IS 'Результат выполнения';

COMMENT ON COLUMN core.cd_results.id IS 'Идентификатор';

COMMENT ON COLUMN core.cd_results.fn_user_point IS 'Пользовательская точка';

COMMENT ON COLUMN core.cd_results.fn_point IS 'Точка маршрута';

COMMENT ON COLUMN core.cd_results.fn_type IS 'Тип результат';

COMMENT ON COLUMN core.cd_results.fn_user IS 'Пользователь';

COMMENT ON COLUMN core.cd_results.fn_route IS 'Маршрут';

COMMENT ON COLUMN core.cd_results.d_date IS 'Дата создания';

COMMENT ON COLUMN core.cd_results.c_notice IS 'Примечание';

COMMENT ON COLUMN core.cd_results.b_warning IS 'Предупреждение Дост./Недост.';

COMMENT ON COLUMN core.cd_results.jb_data IS 'JSON данные';

COMMENT ON COLUMN core.cd_results.dx_created IS 'Дата создания в БД';

COMMENT ON COLUMN core.cd_results.jb_answers IS 'Ответы на вопросы';

CREATE TABLE core.cd_settings (
	id integer DEFAULT nextval('core.auto_id_cd_settings'::regclass) NOT NULL,
	c_key text NOT NULL,
	c_value text,
	f_type integer NOT NULL,
	c_label text,
	c_summary text,
	f_user integer,
	sn_delete boolean DEFAULT false NOT NULL,
	f_role integer
);

ALTER TABLE core.cd_settings OWNER TO mobnius;

COMMENT ON TABLE core.cd_settings IS 'Настройки';

COMMENT ON COLUMN core.cd_settings.id IS 'Идентификатор';

COMMENT ON COLUMN core.cd_settings.c_key IS 'Ключ';

COMMENT ON COLUMN core.cd_settings.c_value IS 'Значение';

COMMENT ON COLUMN core.cd_settings.f_type IS 'Тип';

COMMENT ON COLUMN core.cd_settings.c_label IS 'Заголовок';

COMMENT ON COLUMN core.cd_settings.c_summary IS 'Краткое описание';

COMMENT ON COLUMN core.cd_settings.f_user IS 'Пользователь';

COMMENT ON COLUMN core.cd_settings.sn_delete IS 'Удален';

CREATE TABLE core.cd_sys_log (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	n_level_msg integer DEFAULT 0,
	d_timestamp timestamp with time zone,
	c_descr text
);

ALTER TABLE core.cd_sys_log OWNER TO mobnius;

COMMENT ON TABLE core.cd_sys_log IS ' Логирование job';

COMMENT ON COLUMN core.cd_sys_log.n_level_msg IS '0 - сообщение
1 - предупрежденние
2 - ошибка';

CREATE TABLE core.cs_setting_types (
	id integer DEFAULT nextval('core.auto_id_cs_setting_types'::regclass) NOT NULL,
	n_code integer,
	c_name text NOT NULL,
	c_short_name text,
	c_const text NOT NULL,
	n_order integer DEFAULT 0,
	b_default boolean DEFAULT false NOT NULL,
	b_disabled boolean DEFAULT false NOT NULL
);

ALTER TABLE core.cs_setting_types OWNER TO mobnius;

COMMENT ON TABLE core.cs_setting_types IS 'Тип настройки';

COMMENT ON COLUMN core.cs_setting_types.id IS 'Идентификатор';

COMMENT ON COLUMN core.cs_setting_types.n_code IS 'Код';

COMMENT ON COLUMN core.cs_setting_types.c_name IS 'Наименование';

COMMENT ON COLUMN core.cs_setting_types.c_short_name IS 'Краткое наименование';

COMMENT ON COLUMN core.cs_setting_types.c_const IS 'Константа';

COMMENT ON COLUMN core.cs_setting_types.n_order IS 'Сортировка';

COMMENT ON COLUMN core.cs_setting_types.b_default IS 'По умолчанию';

COMMENT ON COLUMN core.cs_setting_types.b_disabled IS 'Отключено';

CREATE TABLE core.pd_accesses (
	id integer DEFAULT nextval('core.auto_id_pd_accesses'::regclass) NOT NULL,
	f_user integer,
	f_role integer,
	c_name text,
	c_criteria text,
	c_path text,
	c_function text,
	c_columns text,
	b_deletable boolean DEFAULT false NOT NULL,
	b_creatable boolean DEFAULT false NOT NULL,
	b_editable boolean DEFAULT false NOT NULL,
	b_full_control boolean DEFAULT false NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL
);

ALTER TABLE core.pd_accesses OWNER TO mobnius;

REVOKE ALL ON TABLE core.pd_accesses FROM mobnius;
GRANT SELECT ON TABLE core.pd_accesses TO mobnius WITH GRANT OPTION;

COMMENT ON TABLE core.pd_accesses IS 'Права доступа';

COMMENT ON COLUMN core.pd_accesses.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_accesses.f_user IS 'Пользователь';

COMMENT ON COLUMN core.pd_accesses.f_role IS 'Роль';

COMMENT ON COLUMN core.pd_accesses.c_name IS 'Табл./Предст./Функц.';

COMMENT ON COLUMN core.pd_accesses.c_criteria IS 'Серверный фильтр';

COMMENT ON COLUMN core.pd_accesses.c_path IS 'Путь в файловой системе';

COMMENT ON COLUMN core.pd_accesses.c_function IS 'Функция RPC или её часть';

COMMENT ON COLUMN core.pd_accesses.c_columns IS 'Запрещенные колонки';

COMMENT ON COLUMN core.pd_accesses.b_deletable IS 'Разрешено удалени';

COMMENT ON COLUMN core.pd_accesses.b_creatable IS 'Разрешено создание';

COMMENT ON COLUMN core.pd_accesses.b_editable IS 'Разрешено редактирование';

COMMENT ON COLUMN core.pd_accesses.b_full_control IS 'Дополнительный доступ';

COMMENT ON COLUMN core.pd_accesses.sn_delete IS 'Удален';

CREATE TABLE core.pd_roles (
	id integer DEFAULT nextval('core.auto_id_pd_roles'::regclass) NOT NULL,
	c_name text NOT NULL,
	c_description text,
	n_weight integer NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL
);

ALTER TABLE core.pd_roles OWNER TO mobnius;

COMMENT ON TABLE core.pd_roles IS 'Роли';

COMMENT ON COLUMN core.pd_roles.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_roles.c_name IS 'Наименование';

COMMENT ON COLUMN core.pd_roles.c_description IS 'Описание роли';

COMMENT ON COLUMN core.pd_roles.n_weight IS 'Приоритет';

COMMENT ON COLUMN core.pd_roles.sn_delete IS 'Удален';

CREATE TABLE core.pd_userinroles (
	id integer DEFAULT nextval('core.auto_id_pd_userinroles'::regclass) NOT NULL,
	f_user integer NOT NULL,
	f_role integer NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL
);

ALTER TABLE core.pd_userinroles OWNER TO mobnius;

COMMENT ON TABLE core.pd_userinroles IS 'Пользователи в ролях';

COMMENT ON COLUMN core.pd_userinroles.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_userinroles.f_user IS 'Пользователь';

COMMENT ON COLUMN core.pd_userinroles.f_role IS 'Роль';

COMMENT ON COLUMN core.pd_userinroles.sn_delete IS 'Удален';

CREATE TABLE core.pd_users (
	id integer DEFAULT nextval('core.auto_id_pd_users'::regclass) NOT NULL,
	f_parent integer,
	c_login text NOT NULL,
	c_password text,
	fn_file uuid,
	s_salt text,
	s_hash text,
	c_first_name text,
	c_description text,
	b_disabled boolean DEFAULT false NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL,
	c_version text,
	n_version bigint,
	c_phone text,
	c_email text
);

ALTER TABLE core.pd_users OWNER TO mobnius;

COMMENT ON TABLE core.pd_users IS 'Пользователи';

COMMENT ON COLUMN core.pd_users.id IS 'Идентификатор';

COMMENT ON COLUMN core.pd_users.f_parent IS 'Родитель';

COMMENT ON COLUMN core.pd_users.c_login IS 'Логин';

COMMENT ON COLUMN core.pd_users.c_password IS 'Пароль';

COMMENT ON COLUMN core.pd_users.fn_file IS 'Иконка';

COMMENT ON COLUMN core.pd_users.s_salt IS 'Salt';

COMMENT ON COLUMN core.pd_users.s_hash IS 'Hash';

COMMENT ON COLUMN core.pd_users.c_first_name IS 'Имя';

COMMENT ON COLUMN core.pd_users.c_description IS 'Описание';

COMMENT ON COLUMN core.pd_users.b_disabled IS 'Отключен';

COMMENT ON COLUMN core.pd_users.sn_delete IS 'Удален';

COMMENT ON COLUMN core.pd_users.c_version IS 'Версия мобильного приложения';

COMMENT ON COLUMN core.pd_users.n_version IS 'Версия мобильного приложения - Число';

COMMENT ON COLUMN core.pd_users.c_phone IS 'Телефон';

COMMENT ON COLUMN core.pd_users.c_email IS 'Эл. почта';

CREATE OR REPLACE FUNCTION core.cft_log_action() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'UPDATE') THEN
		INSERT INTO core.cd_action_log(c_table_name, c_operation, jb_old_value, jb_new_value, c_user, d_date)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), USER, clock_timestamp());
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
		INSERT INTO core.cd_action_log(c_table_name, c_operation, jb_old_value, c_user, d_date)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), USER, clock_timestamp());
        RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
		INSERT INTO core.cd_action_log(c_table_name, c_operation, jb_new_value, c_user, d_date)
		VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW), USER, clock_timestamp());
	    RETURN NEW;
    ELSE
        RETURN OLD;
	END IF;

EXCEPTION
	WHEN OTHERS
    THEN
		INSERT INTO core.cd_sys_log(d_timestamp, c_descr)
		VALUES(clock_timestamp(), 'Непредвиденная ошибка логирования');
    RETURN OLD;
END;
$$;

ALTER FUNCTION core.cft_log_action() OWNER TO mobnius;

COMMENT ON FUNCTION core.cft_log_action() IS 'Триггер. Процедура логирования действия пользователя';

CREATE OR REPLACE FUNCTION core.cft_table_state_change_version() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	_users json;
BEGIN
	if TG_TABLE_NAME = 'pd_users' then
		select concat('[{"f_user":', NEW.id::text, '}]')::json into _users;
	else 
		if TG_TABLE_NAME = 'cd_points' then
			select (select json_agg(t) from (select f_user from core.cd_userinroutes as uir where uir.f_route = (case when TG_OP = 'DELETE' then OLD.f_route else NEW.f_route end)) as t) into _users;
		else
			if TG_TABLE_NAME = 'cd_routes' then
				select (select json_agg(t) from (select f_user from core.cd_userinroutes as uir where uir.f_route = (case when TG_OP = 'DELETE' then OLD.id else NEW.id end)) as t) into _users;
			else
				if TG_TABLE_NAME = 'cd_route_history' then
					select (select json_agg(t) from (select f_user from core.cd_userinroutes as uir where uir.f_route = (case when TG_OP = 'DELETE' then OLD.fn_route else NEW.fn_route end)) as t) into _users;
				else	
					if TG_OP = 'DELETE' and to_jsonb(OLD) ? 'fn_user' then
						select concat('[{"f_user":', OLD.fn_user::text ,'}]')::json into _users;
					else
						if TG_OP != 'DELETE' and to_jsonb(NEW) ? 'fn_user' then
							select concat('[{"f_user":', NEW.fn_user::text ,'}]')::json into _users;
						else
							select '[{"f_user":null}]'::json into _users;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
			
	perform core.sf_table_change_update(t.c_table_name_ref, (u.value#>>'{f_user}')::integer)
	from json_array_elements(_users) as u
	left join (select TG_TABLE_NAME as c_table_name_ref
				UNION
				select c_table_name_ref
				from core.sd_table_change_ref
				where c_table_name = TG_TABLE_NAME) as t on 1=1;

    RETURN null;
END
$$;

ALTER FUNCTION core.cft_table_state_change_version() OWNER TO mobnius;

COMMENT ON FUNCTION core.cft_table_state_change_version() IS 'Триггер. Обновление справочной версии';

-- DEPCY: This VIEW is a dependency of FUNCTION: core.pf_accesses(integer)

CREATE VIEW core.sv_users AS
	SELECT u.id,
    u.f_parent,
    u.c_login,
    u.c_first_name,
    u.c_first_name AS c_user_name,
    u.c_password,
    u.s_salt,
    u.s_hash,
    concat('.', ( SELECT string_agg(t.c_name, '.'::text) AS string_agg
           FROM ( SELECT r.c_name
                   FROM (core.pd_userinroles uir
                     JOIN core.pd_roles r ON ((uir.f_role = r.id)))
                  WHERE (uir.f_user = u.id)
                  ORDER BY r.n_weight DESC) t), '.') AS c_claims,
    u.b_disabled,
    u.c_version,
    u.n_version
   FROM core.pd_users u
  WHERE (u.sn_delete = false);

ALTER VIEW core.sv_users OWNER TO mobnius;

COMMENT ON VIEW core.sv_users IS 'Системный список пользователей';

CREATE OR REPLACE FUNCTION core.pf_accesses(n_user_id integer) RETURNS TABLE(table_name text, record_criteria text, catalog_path text, rpc_function text, column_name text, is_editable boolean, is_deletable boolean, is_creatable boolean, is_fullcontrol boolean, access integer)
    LANGUAGE plpgsql
    AS $$
/**
* @params {integer} n_user_id - иден. пользователя
*/
BEGIN
	RETURN QUERY select * from (select 
        a.c_name,
        a.c_criteria,
        a.c_path,
        a.c_function,
        a.c_columns,
        a.b_editable, 
        a.b_deletable, 
        a.b_creatable, 
        a.b_full_control, 
        core.sf_accesses(r.c_name, u.id, u.c_claims, a.f_user) as access 
    from core.pd_accesses as a
    left join core.sv_users as u on n_user_id = u.id
    left join core.pd_roles as r on a.f_role = r.id
    where a.sn_delete = false) as t 
	where t.access > 0;
END; 
$$;

ALTER FUNCTION core.pf_accesses(n_user_id integer) OWNER TO mobnius;

COMMENT ON FUNCTION core.pf_accesses(n_user_id integer) IS 'Системная функция. Получение прав доступа для пользователя. Используется NodeJS';

CREATE OR REPLACE FUNCTION core.pf_update_user_roles(_user_id integer, _claims json) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
* @params {integer} _user_id - идент. пользователя
* @params {json} _claims - роли в виде строки '["manager", "inspector"]'
*
* @returns {integer} идент. пользователя
*/
BEGIN
	delete from core.pd_userinroles
	where f_user = _user_id;

	insert into core.pd_userinroles(f_user, f_role, sn_delete)
	SELECT _user_id, (select id from core.pd_roles where t.value = c_name), false 
	FROM json_array_elements_text(_claims) as t;
	
	RETURN _user_id;
END
$$;

ALTER FUNCTION core.pf_update_user_roles(_user_id integer, _claims json) OWNER TO mobnius;

COMMENT ON FUNCTION core.pf_update_user_roles(_user_id integer, _claims json) IS 'Обновление ролей у пользователя';

CREATE OR REPLACE FUNCTION core.sf_accesses(c_role_name text, n_currentuser integer, c_claims text, n_user_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} c_role_name - имя роли в безопасности
* @params {integer} n_currentuser - идент. пользователя в безопасности
* @params {text} c_claims - список ролей
* @params {integer} n_user_id - иден. пользователя
* 
* @returns
* 0 - доступ запрещен
*/
BEGIN
    IF c_role_name is null and n_user_id is null then
		RETURN 1;
	ELSEIF (c_role_name is not null and c_claims is not null and POSITION(CONCAT('.', c_role_name, '.') IN c_claims) > 0) then
		RETURN 2;
	ELSEIF (c_role_name is not null and c_claims is not null and POSITION(CONCAT('.', c_role_name, '.') IN c_claims) > 0) then  
		RETURN 3;
	ELSEIF (c_role_name is null and n_currentuser = n_user_id) then
        RETURN 4;
    ELSEIF (c_role_name = 'anonymous' or n_user_id = -1) then
		RETURN 5;
	else
		RETURN 0;
	end if;
 END
$$;

ALTER FUNCTION core.sf_accesses(c_role_name text, n_currentuser integer, c_claims text, n_user_id integer) OWNER TO mobnius;

COMMENT ON FUNCTION core.sf_accesses(c_role_name text, n_currentuser integer, c_claims text, n_user_id integer) IS 'Системная функция для обработки прав. Для внешнего использования не применять';

CREATE OR REPLACE FUNCTION core.sf_build_version(status integer) RETURNS text
    LANGUAGE plv8 IMMUTABLE STRICT
    AS $$
/**
 * @params {integer} status - версия сборки от 0 до 3
 * @returns {text} версия
 */
var birthday = '2021-01-17';
	var newVersion = '1.' + Math.floor(Math.abs(new Date().getTime() - new Date(birthday).getTime()) / (1000 * 3600 * 24)) + '.' + status + '.'
											  + ((new Date().getHours() * 60) + new Date().getMinutes());
	return newVersion;
$$;

ALTER FUNCTION core.sf_build_version(status integer) OWNER TO mobnius;

COMMENT ON FUNCTION core.sf_build_version(status integer) IS 'Генерация версии БД';

CREATE OR REPLACE FUNCTION core.sf_create_user(_login text, _password text, _claims text, _f_subdivision integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
 * @params {text} _login - логин
 * @params {text} _password - пароль
 * @params {text} _claims - роли,  в формате JSON, например ["admin", "master"]
 * @params {integer} _f_subdivision - округ
 * 
 * @returns {integer} - иден. пользователя
 */
DECLARE
	_userId integer;
BEGIN
	insert into core.pd_users(c_login, c_password, f_subdivision)
	values (_login, _password, _f_subdivision) RETURNING id INTO _userId;
	
	perform dbo.pf_update_user_roles(_userId, _claims);
	
	RETURN _userId;
END
$$;

ALTER FUNCTION core.sf_create_user(_login text, _password text, _claims text, _f_subdivision integer) OWNER TO mobnius;

COMMENT ON FUNCTION core.sf_create_user(_login text, _password text, _claims text, _f_subdivision integer) IS 'Создание пользователя с определенными ролями';

CREATE OR REPLACE FUNCTION core.sf_del_user(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from core.pd_userinroles
	where f_user = _id;

	delete from core.pd_users
	where id = _id;

	RETURN _id;
END
$$;

ALTER FUNCTION core.sf_del_user(_id integer) OWNER TO mobnius;

COMMENT ON FUNCTION core.sf_del_user(_id integer) IS 'Удаление пользователя';

CREATE OR REPLACE FUNCTION core.sf_get_version() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
/**
* @returns {text} версия базы данных
*/
DECLARE
	_ver text;
BEGIN
	SELECT c_value INTO _ver FROM core.cd_settings WHERE lower(c_key) = lower('DB_VERSION');
	RETURN _ver;
END
$$;

ALTER FUNCTION core.sf_get_version() OWNER TO mobnius;

COMMENT ON FUNCTION core.sf_get_version() IS 'Версия БД';

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

CREATE OR REPLACE FUNCTION core.sf_update_version() RETURNS text
    LANGUAGE plpgsql
    AS $$
/**
* принудительное обновление
*
* @returns {text} новая версия базы данных
*
* @example
* [{ "action": "sf_update_version", "method": "Query", "data": [{ "params": [] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_ver text;
BEGIN
	UPDATE core.cd_settings
	SET c_value = core.sf_build_version(0)
	WHERE lower(c_key) = lower('DB_VERSION');
	
	SELECT c_value INTO _ver FROM core.cd_settings WHERE lower(c_key) = lower('DB_VERSION');
	RETURN _ver;
END;
$$;

ALTER FUNCTION core.sf_update_version() OWNER TO postgres;

COMMENT ON FUNCTION core.sf_update_version() IS 'Принудительное обновление версии базу данных';

CREATE OR REPLACE FUNCTION public.max(uuid, uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$
BEGIN
	IF $1 IS NULL OR $1 < $2 THEN
		RETURN $2;
	END IF;

	RETURN $1;
END;
$_$;

ALTER FUNCTION public.max(uuid, uuid) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.min(uuid, uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $_$
BEGIN
    IF $2 IS NULL OR $1 > $2 THEN
        RETURN $2;
    END IF;

    RETURN $1;
END;
$_$;

ALTER FUNCTION public.min(uuid, uuid) OWNER TO postgres;

CREATE AGGREGATE public.max(uuid) (
	SFUNC = public.max,
	STYPE = uuid
);

ALTER AGGREGATE public.max(uuid) OWNER TO postgres;

CREATE AGGREGATE public.min(uuid) (
	SFUNC = public.min,
	STYPE = uuid
);

ALTER AGGREGATE public.min(uuid) OWNER TO postgres;

ALTER TABLE core.cd_action_log_user
	ADD CONSTRAINT cd_user_action_log_pkey PRIMARY KEY (id);

-- DEPCY: This CONSTRAINT is a dependency of CONSTRAINT: core.cd_action_log_user.cd_action_log_user_f_user_fkey

ALTER TABLE core.pd_users
	ADD CONSTRAINT pd_users_pkey PRIMARY KEY (id);

ALTER TABLE core.cd_action_log_user
	ADD CONSTRAINT cd_action_log_user_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id) NOT VALID;

ALTER TABLE core.cd_results
	ADD CONSTRAINT cd_results_pkey PRIMARY KEY (id);

ALTER TABLE core.cd_settings
	ADD CONSTRAINT cd_settings_pkey PRIMARY KEY (id);

ALTER TABLE core.cd_settings
	ADD CONSTRAINT cd_settings_f_user FOREIGN KEY (f_user) REFERENCES core.pd_users(id);

-- DEPCY: This CONSTRAINT is a dependency of CONSTRAINT: core.cd_settings.cd_settings_f_type

ALTER TABLE core.cs_setting_types
	ADD CONSTRAINT cs_setting_types_pkey PRIMARY KEY (id);

ALTER TABLE core.cd_settings
	ADD CONSTRAINT cd_settings_f_type FOREIGN KEY (f_type) REFERENCES core.cs_setting_types(id);

ALTER TABLE core.cd_sys_log
	ADD CONSTRAINT cd_sys_log_pkey PRIMARY KEY (id);

ALTER TABLE core.pd_accesses
	ADD CONSTRAINT pd_accesses_pkey PRIMARY KEY (id);

-- DEPCY: This CONSTRAINT is a dependency of CONSTRAINT: core.pd_accesses.pd_accesses_f_role

ALTER TABLE core.pd_roles
	ADD CONSTRAINT pd_roles_pkey PRIMARY KEY (id);

ALTER TABLE core.pd_accesses
	ADD CONSTRAINT pd_accesses_f_role FOREIGN KEY (f_role) REFERENCES core.pd_roles(id);

ALTER TABLE core.pd_accesses
	ADD CONSTRAINT pd_accesses_f_user FOREIGN KEY (f_user) REFERENCES core.pd_users(id);

ALTER TABLE core.pd_roles
	ADD CONSTRAINT pd_roles_uniq_c_name UNIQUE (c_name);

ALTER TABLE core.pd_userinroles
	ADD CONSTRAINT pd_userinroles_pkey PRIMARY KEY (id);

ALTER TABLE core.pd_userinroles
	ADD CONSTRAINT pd_userinroles_f_role_fkey FOREIGN KEY (f_role) REFERENCES core.pd_roles(id);

ALTER TABLE core.pd_userinroles
	ADD CONSTRAINT pd_userinroles_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id);

ALTER TABLE core.pd_users
	ADD CONSTRAINT pd_users_uniq_c_login UNIQUE (c_login);

ALTER TABLE core.pd_users
	ADD CONSTRAINT pd_users_f_parent_fkey FOREIGN KEY (f_parent) REFERENCES core.pd_users(id);

ALTER TABLE core.sd_table_change
	ADD CONSTRAINT sd_table_change_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id) NOT VALID;

ALTER TABLE core.sd_table_change
	ADD CONSTRAINT sd_table_change_c_table_name_f_user_pkey UNIQUE (c_table_name, f_user);

ALTER TABLE core.sd_table_change
	ADD CONSTRAINT sd_table_change_pkey PRIMARY KEY (id);

ALTER TABLE core.sd_table_change_ref
	ADD CONSTRAINT sd_table_change_ref_pkey PRIMARY KEY (id);

CREATE VIEW core.pv_users AS
	SELECT u.id,
    u.f_parent,
    u.c_login,
    concat('.', ( SELECT string_agg(t.c_name, '.'::text) AS string_agg
           FROM ( SELECT r.c_name
                   FROM (core.pd_userinroles uir
                     JOIN core.pd_roles r ON ((uir.f_role = r.id)))
                  WHERE (uir.f_user = u.id)
                  ORDER BY r.n_weight DESC) t), '.') AS c_claims,
    u.fn_file,
    u.c_description,
    u.c_first_name,
    u.c_phone,
    u.c_email,
    u.c_version,
    u.n_version,
    u.b_disabled
   FROM core.pd_users u
  WHERE (u.sn_delete = false);

ALTER VIEW core.pv_users OWNER TO mobnius;

COMMENT ON VIEW core.pv_users IS 'Открытый список пользователей';

CREATE VIEW core.sv_objects AS
	SELECT table1.table_name,
    table1.table_type,
    table1.table_title,
    table1.primary_key,
    table1.table_comment,
    table1.table_schema
   FROM ( SELECT (t.table_name)::character varying AS table_name,
            (t.table_type)::character varying AS table_type,
            (pgd.description)::character varying AS table_title,
            (cc.column_name)::character varying AS primary_key,
            ''::character varying AS table_comment,
            t.table_schema
           FROM ((((information_schema.tables t
             LEFT JOIN pg_statio_all_tables st ON ((st.relname = (t.table_name)::name)))
             LEFT JOIN pg_description pgd ON (((pgd.objoid = st.relid) AND (pgd.objsubid = 0))))
             LEFT JOIN information_schema.table_constraints tc ON ((((t.table_name)::text = (tc.table_name)::text) AND ((t.table_catalog)::text = (tc.table_catalog)::text))))
             LEFT JOIN information_schema.constraint_column_usage cc ON (((tc.constraint_name)::text = (cc.constraint_name)::text)))
          WHERE (((t.table_catalog)::text = (current_database())::text) AND ((tc.constraint_type)::text = 'PRIMARY KEY'::text))
        UNION
         SELECT (t.table_name)::character varying AS table_name,
            (t.table_type)::character varying AS table_type,
            (pgd.description)::character varying AS table_title,
            ''::character varying AS primary_key,
            ''::character varying AS table_comment,
            t.table_schema
           FROM ((information_schema.tables t
             LEFT JOIN pg_class pgc ON ((pgc.relname = (t.table_name)::name)))
             LEFT JOIN pg_description pgd ON ((pgd.objoid = pgc.oid)))
          WHERE (((t.table_type)::text = 'VIEW'::text) AND ((t.table_catalog)::text = (current_database())::text))
        UNION
         SELECT (r.routine_name)::character varying AS table_name,
            (r.routine_type)::character varying AS table_type,
            (pgd.description)::character varying AS table_title,
            ''::character varying AS primary_key,
            ''::character varying AS table_comment,
            r.routine_schema AS table_schema
           FROM ((information_schema.routines r
             LEFT JOIN pg_proc pgp ON ((pgp.proname = (r.routine_name)::name)))
             LEFT JOIN pg_description pgd ON ((pgd.objoid = pgp.oid)))
          WHERE ((r.routine_catalog)::text = (current_database())::text)) table1
  WHERE (((table1.table_schema)::text <> 'pg_catalog'::text) AND ((table1.table_schema)::text <> 'information_schema'::text) AND ((table1.table_schema)::text <> 'public'::text));

ALTER VIEW core.sv_objects OWNER TO mobnius;

CREATE INDEX cd_action_log_c_table_name_c_operation_idx ON core.cd_action_log USING btree (c_table_name, c_operation);

CREATE INDEX cd_results_fn_route_b_disabled_idx ON core.cd_results USING btree (fn_route, b_disabled);

CREATE TRIGGER cd_results_change_version
	AFTER INSERT OR UPDATE OR DELETE ON core.cd_results
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_table_state_change_version();

CREATE TRIGGER cd_settings_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.cd_settings
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER cs_setting_types_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.cs_setting_types
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER pd_accesses_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.pd_accesses
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER pd_accesses_change_version
	AFTER INSERT OR UPDATE OR DELETE ON core.pd_accesses
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_table_state_change_version();

CREATE TRIGGER pd_roles_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.pd_roles
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER pd_userinroles_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.pd_userinroles
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER pd_userinroles_change_version
	AFTER INSERT OR UPDATE OR DELETE ON core.pd_userinroles
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_table_state_change_version();

CREATE TRIGGER pd_users_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.pd_users
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER pd_users_trigger_iu
	BEFORE INSERT OR UPDATE ON core.pd_users
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_sd_digest_update_version();

CREATE TRIGGER pd_users_change_version
	AFTER INSERT OR UPDATE OR DELETE ON core.pd_users
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_table_state_change_version();

ALTER SEQUENCE core.sd_table_change_id_seq
	OWNED BY core.sd_table_change.id;

ALTER SEQUENCE core.sd_table_change_ref_id_seq
	OWNED BY core.sd_table_change_ref.id;

COMMIT TRANSACTION;