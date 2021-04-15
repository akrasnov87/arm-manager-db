SET TIMEZONE TO 'UTC';

SET check_function_bodies = false;

START TRANSACTION;

SET search_path = pg_catalog;

CREATE SCHEMA core;

ALTER SCHEMA core OWNER TO mobnius;

CREATE SCHEMA dbo;

ALTER SCHEMA dbo OWNER TO mobnius;

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

CREATE SEQUENCE dbo.auto_id_cs_answer
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE dbo.auto_id_cs_answer OWNER TO mobnius;

CREATE SEQUENCE dbo.auto_id_cs_people_types
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE dbo.auto_id_cs_people_types OWNER TO mobnius;

CREATE SEQUENCE dbo.auto_id_cs_question
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE dbo.auto_id_cs_question OWNER TO mobnius;

CREATE SEQUENCE dbo.auto_id_cs_uik
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE dbo.auto_id_cs_uik OWNER TO mobnius;

-- DEPCY: This SEQUENCE is a dependency of COLUMN: dbo.cs_uik_ref.id

CREATE SEQUENCE dbo.cs_uir_ref_id_seq
	AS integer
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE dbo.cs_uir_ref_id_seq OWNER TO mobnius;

CREATE TABLE dbo.cs_uik_ref (
	id integer DEFAULT nextval('dbo.cs_uir_ref_id_seq'::regclass) NOT NULL,
	f_division integer NOT NULL,
	f_subdivision integer NOT NULL,
	f_uik integer NOT NULL
);

ALTER TABLE dbo.cs_uik_ref OWNER TO mobnius;

-- DEPCY: This SEQUENCE is a dependency of COLUMN: dbo.sf_friend_types.id

CREATE SEQUENCE dbo.sf_friend_types_id_seq
	AS smallint
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE dbo.sf_friend_types_id_seq OWNER TO mobnius;

CREATE TABLE dbo.sf_friend_types (
	id smallint DEFAULT nextval('dbo.sf_friend_types_id_seq'::regclass) NOT NULL,
	c_name character varying(30) NOT NULL,
	c_const character varying(20) NOT NULL,
	b_disabled boolean DEFAULT false NOT NULL,
	b_default boolean DEFAULT false NOT NULL,
	n_order integer
);

ALTER TABLE dbo.sf_friend_types OWNER TO mobnius;

COMMENT ON TABLE dbo.sf_friend_types IS 'Статус сторонника';

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

CREATE TABLE dbo.cd_people (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	f_appartament uuid NOT NULL,
	c_first_name text,
	c_last_name text,
	c_middle_name text,
	f_user integer NOT NULL,
	dx_created timestamp with time zone DEFAULT now() NOT NULL,
	n_birth_year integer,
	c_org text,
	c_phone text,
	f_type integer NOT NULL,
	f_imp_id integer
);

ALTER TABLE dbo.cd_people OWNER TO mobnius;

COMMENT ON TABLE dbo.cd_people IS 'Лояльное население';

COMMENT ON COLUMN dbo.cd_people.f_appartament IS 'Помещение, Квартира';

COMMENT ON COLUMN dbo.cd_people.c_first_name IS 'Имя';

COMMENT ON COLUMN dbo.cd_people.c_last_name IS 'Фамилия';

COMMENT ON COLUMN dbo.cd_people.c_middle_name IS 'Отчество';

COMMENT ON COLUMN dbo.cd_people.f_user IS 'Пользователь';

COMMENT ON COLUMN dbo.cd_people.n_birth_year IS 'Год рождения';

COMMENT ON COLUMN dbo.cd_people.c_org IS 'Наименование организации';

COMMENT ON COLUMN dbo.cd_people.c_phone IS 'Номер телефона';

COMMENT ON COLUMN dbo.cd_people.f_type IS 'Тип записи';

COMMENT ON COLUMN dbo.cd_people.f_imp_id IS 'иден. для импорта';

CREATE TABLE dbo.cd_signature_2018 (
	id integer NOT NULL,
	d_date date NOT NULL,
	n_signature smallint,
	f_appartament uuid NOT NULL,
	f_friend_type smallint NOT NULL
);

ALTER TABLE dbo.cd_signature_2018 ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
	SEQUENCE NAME dbo.cs_signature_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1
);

ALTER TABLE dbo.cd_signature_2018 OWNER TO mobnius;

COMMENT ON TABLE dbo.cd_signature_2018 IS 'Результат голосования 2018';

COMMENT ON COLUMN dbo.cd_signature_2018.f_friend_type IS 'Тип лояльности';

CREATE TABLE dbo.cd_uik (
	id integer DEFAULT nextval('dbo.auto_id_cs_uik'::regclass) NOT NULL,
	c_fio text,
	c_email text,
	c_work_place text,
	c_job text,
	c_phone text,
	c_place text,
	c_place_phone text
);

ALTER TABLE dbo.cd_uik OWNER TO mobnius;

COMMENT ON TABLE dbo.cd_uik IS 'УИК';

COMMENT ON COLUMN dbo.cd_uik.id IS 'Идентификатор';

COMMENT ON COLUMN dbo.cd_uik.c_fio IS 'ФИО';

COMMENT ON COLUMN dbo.cd_uik.c_email IS 'Email';

COMMENT ON COLUMN dbo.cd_uik.c_place IS 'указывается адрес и место голосования';

COMMENT ON COLUMN dbo.cd_uik.c_place_phone IS 'указываются телефоны УИКа';

CREATE TABLE dbo.cs_answer (
	id bigint DEFAULT nextval('dbo.auto_id_cs_answer'::regclass) NOT NULL,
	c_text text,
	f_question integer NOT NULL,
	f_next_question integer,
	c_action text,
	n_order integer DEFAULT 0 NOT NULL,
	b_disabled boolean DEFAULT false NOT NULL,
	dx_created timestamp with time zone DEFAULT now() NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL,
	f_role integer,
	c_const text
);

ALTER TABLE dbo.cs_answer OWNER TO mobnius;

COMMENT ON TABLE dbo.cs_answer IS 'Речевой модуль';

COMMENT ON COLUMN dbo.cs_answer.id IS '[e90] Идентификатор';

COMMENT ON COLUMN dbo.cs_answer.c_text IS '[e80|d] Текст';

COMMENT ON COLUMN dbo.cs_answer.f_question IS '[e70] Вопрос';

COMMENT ON COLUMN dbo.cs_answer.f_next_question IS '[e60] Следующий вопрос';

COMMENT ON COLUMN dbo.cs_answer.c_action IS '[e50] Действие';

COMMENT ON COLUMN dbo.cs_answer.n_order IS '[e40] Сортировка';

COMMENT ON COLUMN dbo.cs_answer.b_disabled IS '[e30] Отключить';

COMMENT ON COLUMN dbo.cs_answer.dx_created IS '[e20] Дата создания';

COMMENT ON COLUMN dbo.cs_answer.sn_delete IS '[e10] Признак удаленной записи';

COMMENT ON COLUMN dbo.cs_answer.f_role IS 'Конкретно для указанной роли';

COMMENT ON COLUMN dbo.cs_answer.c_const IS 'Константа ответа, можно использовать и c_color';

CREATE TABLE dbo.cs_appartament (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	f_house uuid NOT NULL,
	c_number text,
	n_number integer,
	dx_date timestamp with time zone DEFAULT now() NOT NULL,
	b_disabled boolean DEFAULT false NOT NULL,
	f_user integer,
	jkh_premise_link integer,
	b_off_range boolean NOT NULL,
	b_check boolean,
	c_notice text,
	f_created_user integer
);

ALTER TABLE dbo.cs_appartament OWNER TO mobnius;

COMMENT ON TABLE dbo.cs_appartament IS 'Квартиры';

COMMENT ON COLUMN dbo.cs_appartament.id IS 'Идентификатор';

COMMENT ON COLUMN dbo.cs_appartament.f_house IS 'Дом';

COMMENT ON COLUMN dbo.cs_appartament.c_number IS 'Строковый номер';

COMMENT ON COLUMN dbo.cs_appartament.n_number IS 'Номер';

COMMENT ON COLUMN dbo.cs_appartament.f_user IS 'Агитатор';

COMMENT ON COLUMN dbo.cs_appartament.jkh_premise_link IS 'Идентификатор квартиры из ГИС ЖКХ';

COMMENT ON COLUMN dbo.cs_appartament.b_off_range IS 'Вне диапазона квартир';

CREATE TABLE dbo.cs_house (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	f_street uuid,
	dx_date timestamp with time zone DEFAULT now() NOT NULL,
	b_disabled boolean DEFAULT false NOT NULL,
	n_uik integer,
	f_subdivision integer,
	f_user integer,
	f_candidate_users jsonb,
	n_latitude numeric,
	n_longitude numeric,
	n_building_year smallint,
	n_lift_count smallint,
	c_entrance_count text,
	n_appart_count smallint,
	s_fias_guid uuid,
	c_house_corp text,
	c_house_number text,
	c_house_litera text,
	n_count_floor_min text,
	n_count_floor_max text,
	jkh_house_link integer,
	c_full_number text,
	n_number integer,
	b_tmp_kalinin boolean,
	b_tmp_lenin boolean,
	b_tmp_moscow boolean,
	dx_tmp_modified timestamp with time zone DEFAULT now(),
	b_tmp_unknow boolean,
	b_check boolean,
	c_notice text,
	n_tmp_appart_count bigint,
	b_tmp_nov boolean,
	b_energo boolean,
	n_gos_subdivision integer
);

ALTER TABLE dbo.cs_house OWNER TO mobnius;

COMMENT ON TABLE dbo.cs_house IS 'Улицы';

COMMENT ON COLUMN dbo.cs_house.id IS 'Идентификатор';

COMMENT ON COLUMN dbo.cs_house.f_street IS 'Улица';

COMMENT ON COLUMN dbo.cs_house.f_candidate_users IS 'Кандидаты';

COMMENT ON COLUMN dbo.cs_house.n_latitude IS 'широта';

COMMENT ON COLUMN dbo.cs_house.n_longitude IS 'долгота';

COMMENT ON COLUMN dbo.cs_house.n_building_year IS 'год строения';

COMMENT ON COLUMN dbo.cs_house.n_lift_count IS 'количество лифтов';

COMMENT ON COLUMN dbo.cs_house.c_entrance_count IS 'кол-во подъездов';

COMMENT ON COLUMN dbo.cs_house.n_appart_count IS 'кол-во квартир';

COMMENT ON COLUMN dbo.cs_house.s_fias_guid IS 'ФИАС';

COMMENT ON COLUMN dbo.cs_house.c_house_corp IS 'корпус';

COMMENT ON COLUMN dbo.cs_house.c_house_litera IS 'литерала';

COMMENT ON COLUMN dbo.cs_house.n_count_floor_min IS 'мин. кол-во этажей';

COMMENT ON COLUMN dbo.cs_house.n_count_floor_max IS 'макс. кол-во этажей';

COMMENT ON COLUMN dbo.cs_house.jkh_house_link IS 'Идентификатор дома в ГИС ЖКХ';

COMMENT ON COLUMN dbo.cs_house.c_full_number IS 'Полный номер дома';

COMMENT ON COLUMN dbo.cs_house.n_number IS 'Числовой номер дома';

COMMENT ON COLUMN dbo.cs_house.b_tmp_kalinin IS 'Относится к калининскому району';

COMMENT ON COLUMN dbo.cs_house.b_tmp_lenin IS 'Относится к ленинскому району';

COMMENT ON COLUMN dbo.cs_house.b_tmp_moscow IS 'Относится к московскому району';

COMMENT ON COLUMN dbo.cs_house.dx_tmp_modified IS 'Дата внесения изменения';

COMMENT ON COLUMN dbo.cs_house.b_tmp_unknow IS 'Неизвестна привязка';

COMMENT ON COLUMN dbo.cs_house.n_tmp_appart_count IS 'Временная колонка. Количество квартир по дому';

COMMENT ON COLUMN dbo.cs_house.n_gos_subdivision IS 'Номер округа при голосовании в госсовет';

CREATE TABLE dbo.cs_people_types (
	id integer DEFAULT nextval('dbo.auto_id_cs_people_types'::regclass) NOT NULL,
	n_code integer,
	c_name text NOT NULL,
	c_short_name text,
	c_const text NOT NULL,
	n_order integer DEFAULT 0,
	b_default boolean DEFAULT false NOT NULL,
	b_disabled boolean DEFAULT false NOT NULL
);

ALTER TABLE dbo.cs_people_types OWNER TO mobnius;

COMMENT ON TABLE dbo.cs_people_types IS 'Тип маршрута';

COMMENT ON COLUMN dbo.cs_people_types.id IS '[e80] Идентификатор';

COMMENT ON COLUMN dbo.cs_people_types.n_code IS '[e70] Код';

COMMENT ON COLUMN dbo.cs_people_types.c_name IS '[e60|d] Наименование';

COMMENT ON COLUMN dbo.cs_people_types.c_short_name IS '[e50] Краткое наименование';

COMMENT ON COLUMN dbo.cs_people_types.c_const IS '[e40] Константа';

COMMENT ON COLUMN dbo.cs_people_types.n_order IS '[e30] Сортировка';

COMMENT ON COLUMN dbo.cs_people_types.b_default IS '[e20] По умолчанию';

COMMENT ON COLUMN dbo.cs_people_types.b_disabled IS '[e10] Отключено';

CREATE TABLE dbo.cs_question (
	id bigint DEFAULT nextval('dbo.auto_id_cs_question'::regclass) NOT NULL,
	c_title text NOT NULL,
	c_description text NOT NULL,
	c_text text NOT NULL,
	n_order integer DEFAULT 0 NOT NULL,
	b_disabled boolean DEFAULT false NOT NULL,
	dx_created timestamp with time zone DEFAULT now() NOT NULL,
	sn_delete boolean DEFAULT false NOT NULL,
	f_role integer,
	n_priority integer
);

ALTER TABLE dbo.cs_question OWNER TO mobnius;

COMMENT ON TABLE dbo.cs_question IS 'Речевой модуль';

COMMENT ON COLUMN dbo.cs_question.id IS '[e80] Идентификатор';

COMMENT ON COLUMN dbo.cs_question.c_title IS '[e70|d] Заголовок';

COMMENT ON COLUMN dbo.cs_question.c_description IS '[e60] Описание';

COMMENT ON COLUMN dbo.cs_question.c_text IS '[e50] Текст';

COMMENT ON COLUMN dbo.cs_question.n_order IS '[e40] Сортировка';

COMMENT ON COLUMN dbo.cs_question.b_disabled IS '[e30] Отключить';

COMMENT ON COLUMN dbo.cs_question.dx_created IS '[e20] Дата создания';

COMMENT ON COLUMN dbo.cs_question.sn_delete IS '[e10] Признак удаленной записи';

COMMENT ON COLUMN dbo.cs_question.f_role IS 'Конкретно для указанной роли';

CREATE TABLE dbo.cs_street (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	c_name text,
	c_type text,
	dx_date timestamp with time zone DEFAULT now() NOT NULL,
	b_disabled boolean DEFAULT false NOT NULL,
	c_short_type text,
	f_user integer,
	n_latitude numeric,
	n_longitude numeric,
	f_main_division integer,
	f_location integer
);

ALTER TABLE dbo.cs_street OWNER TO mobnius;

COMMENT ON TABLE dbo.cs_street IS 'Улицы';

COMMENT ON COLUMN dbo.cs_street.id IS '[e110] Идентификатор';

COMMENT ON COLUMN dbo.cs_street.c_name IS 'улица';

COMMENT ON COLUMN dbo.cs_street.c_type IS 'Тип';

COMMENT ON COLUMN dbo.cs_street.f_main_division IS 'Город';

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

CREATE OR REPLACE FUNCTION dbo.cf_bss_check_appartament_update(_appartaments json, _b_check boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
*
* @params {json} _appartaments - список идентификатор квартир, '["e7ded0cd-12dd-47f5-a75b-192376291e83"]'
* @params {boolean} _b_check - статус подтверждения
*
* @returns {integer}
* 0 - ОК
*
* @example
* [{ "action": "cf_check_appartament_update", "method": "Query", "data": [{ "params": [_appartaments, _b_check] }], "type": "rpc", "tid": 0}]
*/
BEGIN
	update dbo.cs_appartament as a
	set b_check = _b_check
	where a.id IN (select t.value::uuid from json_array_elements_text(_appartaments) as t);
	
	RETURN 0;
END
$$;

ALTER FUNCTION dbo.cf_bss_check_appartament_update(_appartaments json, _b_check boolean) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_check_appartament_update(_appartaments json, _b_check boolean) IS 'Обновление статуса проверки';

-- DEPCY: This VIEW is a dependency of FUNCTION: dbo.cf_bss_cs_appartament(integer, uuid, uuid)

CREATE VIEW dbo.cv_uik_ref AS
	SELECT ur.f_division,
    ur.f_subdivision,
    ur.f_uik,
    sd.c_name AS c_subdivision
   FROM (dbo.cs_uik_ref ur
     JOIN core.sd_subdivisions sd ON ((ur.f_subdivision = sd.id)));

ALTER VIEW dbo.cv_uik_ref OWNER TO mobnius;

COMMENT ON VIEW dbo.cv_uik_ref IS 'Привязка УИК к Округам и Районам. Вычисляется динамически';

CREATE OR REPLACE FUNCTION dbo.cf_bss_cs_appartament(_f_user integer, _f_street uuid, _f_house uuid) RETURNS TABLE(id uuid, f_street uuid, c_short_type text, c_name text, f_house uuid, c_full_number text, c_number text, n_number integer, dx_date timestamp with time zone, b_disabled boolean, f_user integer, c_first_name text, b_check boolean, c_notice text, f_division integer, f_subdivision integer, n_uik integer, n_gos_subdivision integer, f_main_division integer)
    LANGUAGE plpgsql
    AS $$
/**
* @params {integer} _f_user - идентификатор пользователя
* @params {uuid} _f_street - идентификатор улицы. Можно передать null
* @params {uuid} _f_house - идентификатор улицы. Можно передать null
*/
BEGIN	
	return query 
	select
		a.id, -- иден. квартиры
		h.f_street, -- иден. улицы
		s.c_short_type, -- тип улицы
		s.c_name, -- имя улицы
		a.f_house, -- иден. дома
		h.c_full_number, -- номер дома
		a.c_number, -- номер
		a.n_number, -- номер для сортировки
		a.dx_date, -- дата создания
		a.b_disabled, -- отключено
		a.f_user, -- иден. агитатора
		u.c_first_name, -- имя агитатора
		case when h.b_check = false then false else a.b_check end as b_check,
		a.c_notice,
		d.id as f_division,
		sd.id as f_subdivision,
		h.n_uik,
		h.n_gos_subdivision,
		s.f_main_division
	from dbo.cs_appartament as a
	left join core.pd_users as u ON a.f_user = u.id
	inner join dbo.cs_house as h ON h.id = a.f_house
	inner join dbo.cs_street as s ON s.id = h.f_street
	left join core.sd_subdivisions as sd ON sd.id = h.f_subdivision
	inner join core.sd_divisions as d ON d.id = sd.f_division
	where 
	(case when _f_street is null then 1=1 else s.id = _f_street end) and
	(case when _f_house is null then 1=1 else h.id = _f_house end) and
	(case when _f_user is null then 1=1 else (h.n_uik in (with items as (select uid.f_division, uid.f_subdivision, uid.f_uik
							from core.pd_userindivisions as uid
							where uid.f_user = _f_user)
			select ur.f_uik from dbo.cv_uik_ref as ur
			where ur.f_division in (select t.f_division from items as t) or
			ur.f_subdivision in (select t.f_subdivision from items as t) or
			ur.f_uik in (select t.f_uik from items as t))) end) and a.b_disabled = true;
END
$$;

ALTER FUNCTION dbo.cf_bss_cs_appartament(_f_user integer, _f_street uuid, _f_house uuid) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_cs_appartament(_f_user integer, _f_street uuid, _f_house uuid) IS 'Получение квартир, которые доступны определенному пользователю';

CREATE OR REPLACE FUNCTION dbo.cf_bss_cs_appartament_info(_f_appartament uuid) RETURNS TABLE(c_first_name text, c_last_name text, c_middle_name text, c_name text)
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_appartament - идентификатор квартир
*/
BEGIN	
	return query 
	select 
		p.c_first_name, -- фамилия
		p.c_last_name, -- имя
		p.c_middle_name, -- отчество
		pt.c_name -- категория
	from dbo.cd_people as p
	inner join dbo.cs_people_types as pt ON p.f_type = pt.id
	where p.f_appartament = _f_appartament;
END
$$;

ALTER FUNCTION dbo.cf_bss_cs_appartament_info(_f_appartament uuid) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_cs_appartament_info(_f_appartament uuid) IS 'Получение информации по квартире';

CREATE OR REPLACE FUNCTION dbo.cf_bss_cs_house(_f_user integer, _f_street uuid, _uiks json) RETURNS TABLE(id uuid, f_street uuid, c_short_type text, c_name text, f_subdivision integer, c_subdivision text, c_full_number text, dx_date timestamp with time zone, b_disabled boolean, n_uik integer, f_user integer, c_first_name text, n_number integer, n_premise_count bigint, b_check boolean, c_notice text, b_finish boolean)
    LANGUAGE plpgsql
    AS $$
/**
* @params {integer} _f_user - идентификатор пользователя
* @params {uuid} _f_street - идентификатор улицы. Можно передать null
*/
BEGIN	
	IF _uiks is null then
		with users as (
			select uid.f_division, uid.f_subdivision, uid.f_uik
			from core.pd_userindivisions as uid
			where uid.f_user = _f_user
		), uiks as (
			select ur.f_uik from dbo.cv_uik_ref as ur
			where ur.f_division in (select t.f_division from users as t) or
			ur.f_subdivision in (select t.f_subdivision from users as t) or
			ur.f_uik in (select t.f_uik from users as t)
		) select  json_agg(t) into _uiks from (select i.f_uik from uiks as i) as t;
	end if;
	
	return query 
	select
		h.id, -- иден. дома
		h.f_street, -- иден. улицы
		s.c_short_type, -- тип улицы
		s.c_name, -- наименование улицы
		sd.id as f_subdivision, -- иден. округа
		sd.c_name as c_subdivision, -- имя округа
		h.c_full_number, -- адрес дома
		h.dx_date, -- дата создания
		h.b_disabled, -- отключен
		h.n_uik, -- УИК
		h.f_user, -- иден. автора
		u.c_first_name, -- имя автора
		h.n_number, -- числовой номер дома для сортировки
		h.n_tmp_appart_count as n_premise_count, -- количество квартир
		h.b_check,
		h.c_notice,
		coalesce((((select count(*) from dbo.cs_appartament as a where a.b_disabled = true and a.f_house = h.id and a.b_check is not null) = (select count(*) from dbo.cs_appartament as a where a.b_disabled = true and a.f_house = h.id)) and h.b_check is not null) or (h.b_check = false), false) as b_finish -- количество квартир
	from dbo.cs_house as h
	inner join dbo.cs_street as s ON s.id = h.f_street
	left join core.pd_users as u ON h.f_user = u.id
	left join core.sd_subdivisions as sd ON sd.id = h.f_subdivision
	where (h.b_disabled = true
		   or (select count(*) from dbo.cs_appartament as a where a.b_disabled = true and a.f_house = h.id) > 0
		  ) and h.f_subdivision is not null and h.n_tmp_appart_count != 0 and
	(case when _f_street is null then 1=1 else h.f_street = _f_street end) and
	(case when _f_user is null then h.n_uik is not null 
	 else h.n_uik in (select (t.value#>>'{f_uik}')::integer from json_array_elements(_uiks) as t) end)
	;
END
$$;

ALTER FUNCTION dbo.cf_bss_cs_house(_f_user integer, _f_street uuid, _uiks json) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_cs_house(_f_user integer, _f_street uuid, _uiks json) IS 'Получение домов, которые доступны определенному пользователю';

CREATE OR REPLACE FUNCTION dbo.cf_bss_cs_house(_n_gos_subdivision integer) RETURNS TABLE(f_main_division integer, f_division integer, f_subdivision integer, c_subdivision text, n_uik integer, c_street_type text, c_street text, f_house uuid, c_house_number text, n_gos_subdivision integer, n_total_appartament bigint, n_min_appartament integer, n_max_appartament integer, jb_info json)
    LANGUAGE plpgsql
    AS $$
/**
* @params {integer} _n_gos_subdivision - номер округа для госсовета
*/
BEGIN	
	return query 
	select 
		s.f_main_division,
		sd.f_division,
		sd.id as f_subdivision,
		sd.c_name as c_subdivision,
		h.n_uik as n_uik,
		s.c_type as c_street_type,
		s.c_name as c_street,
		h.id as f_house,
		h.c_full_number as c_house_number,
		h.n_gos_subdivision,
		(select count(*) from dbo.cs_appartament as a where a.f_house = h.id and a.b_disabled = false) as n_total_appartament,
		(case when _n_gos_subdivision is null then 0 else (select min(a.n_number) from dbo.cs_appartament as a where a.f_house = h.id and a.b_disabled = false) end) as n_min_appartament,
		(case when _n_gos_subdivision is null then 0 else (select max(a.n_number) from dbo.cs_appartament as a where a.f_house = h.id and a.b_disabled = false) end) as n_max_appartament,
		(case when _n_gos_subdivision is null then null::json else (SELECT json_agg(t) FROM (select 
			a.f_user, 
			min(n_number) as n_min_number, 
			max(n_number) as n_max_number, 
			count(*) as n_count
		from dbo.cs_appartament as a 
		where a.f_house = h.id and a.b_disabled = false
		group by a.f_user
		order by a.f_user) as t) end) as jb_info
	from dbo.cs_house as h
	inner join dbo.cs_street as s on h.f_street = s.id
	inner join core.sd_subdivisions as sd on sd.id = h.f_subdivision
	where h.b_disabled = false
	and (case when _n_gos_subdivision is null then 1=1 else h.n_gos_subdivision = _n_gos_subdivision end)
	order by sd.id, h.n_uik, s.c_name, h.c_full_number;
END
$$;

ALTER FUNCTION dbo.cf_bss_cs_house(_n_gos_subdivision integer) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_cs_house(_n_gos_subdivision integer) IS 'Список домов для участия в госсовете';

-- DEPCY: This CONSTRAINT is a dependency of FUNCTION: dbo.cf_bss_cs_house_info(uuid, uuid)

ALTER TABLE dbo.cs_house
	ADD CONSTRAINT cs_house_pkey PRIMARY KEY (id);

CREATE OR REPLACE FUNCTION dbo.cf_bss_cs_house_info(_f_street uuid, _f_house uuid) RETURNS TABLE(c_division text, c_subdivision text, n_uik integer, c_type text, c_name text, c_full_number text, f_house uuid, c_people_types text, n_appart_count integer, n_count bigint, n_percent numeric)
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_street - идентификатор улицы. Можно передать null
* @params {uuid} _f_house - идентификатор дома. Можно передать null
*/
BEGIN	
	return query select 
		max(d.c_name) as c_division, 
		max(sd.c_name) as c_subdivision, 
		h.n_uik, 
		max(s.c_type) as c_type, 
		max(s.c_name) as c_name, 
		h.c_full_number, 
		h.id as f_house, 
		max(pt.c_name) as c_people_types, 
		coalesce(h.n_appart_count, 1) as n_appart_count, 
		count(*) as n_count, 
		dbo.sf_percent(count(*)::numeric, h.n_appart_count::numeric) as n_percent
	from (select h1.id, p1.f_type, p1.f_appartament from dbo.cd_people as p1
		  inner join dbo.cs_appartament as a1 ON p1.f_appartament = a1.id
		  inner join dbo.cs_house as h1 ON h1.id = a1.f_house 
		  where (case when _f_street is null then 1=1 else h1.f_street = _f_street end) and
		  (case when _f_house is null then 1=1 else h1.id = _f_house end)
		  group by h1.id, p1.f_type, p1.f_appartament) as t
	inner join dbo.cs_people_types as pt ON pt.id = t.f_type
	inner join dbo.cs_appartament as a ON t.f_appartament = a.id
	inner join dbo.cs_house as h ON h.id = a.f_house
	left join core.sd_subdivisions as sd ON sd.id = h.f_subdivision
	left join core.sd_divisions as d ON d.id = sd.f_division 
	inner join dbo.cs_street as s ON s.id = h.f_street
	group by h.id, t.f_type
	order by max(d.id), max(sd.id), h.n_uik, h.c_full_number, max(t.f_type);
END
$$;

ALTER FUNCTION dbo.cf_bss_cs_house_info(_f_street uuid, _f_house uuid) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_cs_house_info(_f_street uuid, _f_house uuid) IS 'Информация по дому в разрезе жильцов';

CREATE OR REPLACE FUNCTION dbo.cf_bss_cs_house_loyalty(_f_street uuid, _f_house uuid) RETURNS TABLE(c_division text, c_subdivision text, n_uik integer, c_type text, c_name text, c_full_number text, f_house uuid, n_year double precision, n_rating numeric)
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_street - идентификатор улицы. Можно передать null
* @params {uuid} _f_house - идентификатор дома. Можно передать null
*/
BEGIN	
	return query select
		max(d.c_name) as c_division, 
		max(sd.c_name) as c_subdivision, 
		h.n_uik, 
		max(s.c_type) as c_type, 
		max(s.c_name) as c_name, 
		h.c_full_number, 
		h.id as f_house, 
		date_part('year', t.d_date) as n_year, 
		avg(ft.n_order) as n_order
	from (
	select 
		p.f_appartament, 
		(case when r.n_rating between 1 and 5 then 5
			when r.n_rating = 5 then 2
			when r.n_rating between 6 and 8 then 1
			when r.n_rating >= 8 then 3
			else 6 end) as f_friend_type,
		r.d_date
	from core.cd_results as r
	inner join core.cd_points as p ON p.id = r.fn_point
	inner join dbo.cs_appartament as a ON a.id = p.f_appartament
	inner join dbo.cs_house as h ON a.f_house = h.id
	where r.n_rating is not null and (case when _f_street is null then 1=1 else h.f_street = _f_street end) and
	(case when _f_house is null then 1=1 else h.id = _f_house end)
	UNION ALL
	select s.f_appartament, s.f_friend_type, s.d_date from dbo.cd_signature_2018 as s 
	inner join dbo.cs_appartament as a ON a.id = s.f_appartament
	inner join dbo.cs_house as h ON a.f_house = h.id
	where s.f_friend_type != 6 and (case when _f_street is null then 1=1 else h.f_street = _f_street end) and
	(case when _f_house is null then 1=1 else h.id = _f_house end)) as t
	inner join dbo.sf_friend_types as ft ON ft.id = t.f_friend_type
	inner join dbo.cs_appartament as a ON a.id = t.f_appartament
	inner join dbo.cs_house as h ON a.f_house = h.id
	left join core.sd_subdivisions as sd ON sd.id = h.f_subdivision
	left join core.sd_divisions as d ON d.id = sd.f_division 
	inner join dbo.cs_street as s ON s.id = h.f_street
	group by h.id, date_part('year', t.d_date)
	order by max(d.id), max(sd.id), h.n_uik, h.c_full_number, date_part('year', t.d_date);
END
$$;

ALTER FUNCTION dbo.cf_bss_cs_house_loyalty(_f_street uuid, _f_house uuid) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_cs_house_loyalty(_f_street uuid, _f_house uuid) IS 'Информация о лояльности';

-- DEPCY: This CONSTRAINT is a dependency of FUNCTION: dbo.cf_bss_cs_street(integer)

ALTER TABLE dbo.cs_street
	ADD CONSTRAINT cs_street_pkey PRIMARY KEY (id);

CREATE OR REPLACE FUNCTION dbo.cf_bss_cs_street(_f_user integer) RETURNS TABLE(id uuid, c_name text, c_type text, c_short_type text, b_disabled boolean, dx_date timestamp with time zone, f_user integer, c_first_name text, b_finish boolean)
    LANGUAGE plpgsql
    AS $$
/**
* @params {integer} f_user - идентификатор пользователя
*/
BEGIN	
	return query 
	with users as (
		select uid.f_division, uid.f_subdivision, uid.f_uik
		from core.pd_userindivisions as uid
		where uid.f_user = _f_user
	), uiks as (
		select ur.f_uik from dbo.cv_uik_ref as ur
		where ur.f_division in (select t.f_division from users as t) or
		ur.f_subdivision in (select t.f_subdivision from users as t) or
		ur.f_uik in (select t.f_uik from users as t)
	)
	select
		s.id, -- иден.
		s.c_name, -- имя улицы
		s.c_type, -- тип
		s.c_short_type, -- короткое наименование типа
		s.b_disabled, -- отключен
		s.dx_date, -- дата создания
		s.f_user, -- иден. пользователя создавшего запись
		max(u.c_first_name), -- имя пользователя создавшего запись
		(select count(*) from dbo.cf_bss_cs_house(_f_user, s.id, (select json_agg(t) from (select i.f_uik from uiks as i) as t)) as t where t.b_finish = false) = 0 as b_finish -- выполнено
	from dbo.cs_street as s
	left join dbo.cs_house as h ON h.f_street = s.id
	left join core.pd_users as u ON s.f_user = u.id
	where (h.b_disabled = true and h.f_subdivision is not null and h.n_tmp_appart_count != 0 and 
	(case when _f_user is null then h.n_uik is not null
		  else h.n_uik in (select i.f_uik from uiks as i) end)) or s.f_user = _f_user
	group by s.id;
END
$$;

ALTER FUNCTION dbo.cf_bss_cs_street(_f_user integer) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_cs_street(_f_user integer) IS 'Получение списка улиц, которые доступны определенному пользователю';

CREATE OR REPLACE FUNCTION dbo.cf_bss_cs_street(_f_user integer, _n_uik integer) RETURNS TABLE(id uuid, c_name text, c_type text, c_short_type text, b_disabled boolean, dx_date timestamp with time zone, f_user integer, c_first_name text, b_finish boolean)
    LANGUAGE plpgsql
    AS $$
/**
* @params {integer} _f_user - идентификатор пользователя
* @params {integer} _n_uik - УИК
*/
BEGIN	
	return query 
	with users as (
		select uid.f_division, uid.f_subdivision, uid.f_uik
		from core.pd_userindivisions as uid
		where uid.f_user = _f_user
	), uiks as (
		select ur.f_uik from dbo.cv_uik_ref as ur
		where 
		ur.f_division in (select t.f_division from users as t) or
		ur.f_subdivision in (select t.f_subdivision from users as t) or
		ur.f_uik in (select t.f_uik from users as t)
	)
	select
		s.id, -- иден.
		s.c_name, -- имя улицы
		s.c_type, -- тип
		s.c_short_type, -- короткое наименование типа
		s.b_disabled, -- отключен
		s.dx_date, -- дата создания
		s.f_user, -- иден. пользователя создавшего запись
		max(u.c_first_name), -- имя пользователя создавшего запись
		(select count(*) from dbo.cf_bss_cs_house(_f_user, s.id, (select json_agg(t) from (select i.f_uik from uiks as i) as t)) as t where t.b_finish = false) = 0 as b_finish -- выполнено
	from dbo.cs_street as s
	left join dbo.cs_house as h ON h.f_street = s.id
	left join core.pd_users as u ON s.f_user = u.id
	where (h.b_disabled = true and h.f_subdivision is not null and h.n_tmp_appart_count != 0 and 
	(case when _f_user is null then h.n_uik is not null
		  else h.n_uik in (select i.f_uik from uiks as i) end) and (case when _n_uik is null then 1=1 else h.n_uik = _n_uik end)) or (case when _n_uik is null then s.f_user = _f_user else 1!=1 end)
	group by s.id;
END
$$;

ALTER FUNCTION dbo.cf_bss_cs_street(_f_user integer, _n_uik integer) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_cs_street(_f_user integer, _n_uik integer) IS 'Получение списка улиц, которые доступны определенному пользователю';

CREATE OR REPLACE FUNCTION dbo.cf_bss_is_appartament_exists(_f_street uuid, _f_house uuid, _c_number text) RETURNS TABLE(id uuid, c_type text, c_name text, f_house uuid, c_house_number text, c_house_corp text, c_house_litera text, f_appartament uuid, c_premise_number text)
    LANGUAGE plpgsql
    AS $$
/**
*
* @params {uuid} _f_street - иден. улицы
* @params {uuid} _f_house - иден. дома
* @params {text} _c_number - номер
*
* @example
* [{ "action": "cf_bss_is_appartament_exists", "method": "Query", "data": [{ "params": [_f_street, _f_house, _c_number] }], "type": "rpc", "tid": 0}]
*/
BEGIN
	return query 
	select
		s.id, s.c_type, s.c_name, h.id, h.c_house_number, h.c_house_corp, h.c_house_litera, a.id, a.c_number
	from dbo.cs_appartament as a
	inner join dbo.cs_house as h ON a.f_house = h.id
	inner join dbo.cs_street as s ON h.f_street = s.id
	where h.f_street = _f_street
	and h.id = _f_house
	and (case when _c_number is not null then a.c_number ilike '%'||_c_number||'%' else 1=1 end);
END
$$;

ALTER FUNCTION dbo.cf_bss_is_appartament_exists(_f_street uuid, _f_house uuid, _c_number text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_is_appartament_exists(_f_street uuid, _f_house uuid, _c_number text) IS 'Проверка на наличие квартир';

CREATE OR REPLACE FUNCTION dbo.cf_bss_is_house_exists(_f_street uuid, _c_house_number text, _c_house_corp text, _c_house_litera text) RETURNS TABLE(id uuid, c_type text, c_name text, f_house uuid, c_house_number text, c_house_corp text, c_house_litera text)
    LANGUAGE plpgsql
    AS $$
/**
*
* @params {uuid} _f_street - иден. улицы
* @params {text} _c_house_number - дом
* @params {text} _c_house_corp - корпус
* @params {text} _c_house_litera - литерала
*
* @example
* [{ "action": "cf_bss_is_house_exists", "method": "Query", "data": [{ "params": [_f_street, _c_house_number, _c_house_corp, _c_house_litera] }], "type": "rpc", "tid": 0}]
*/
BEGIN
	return query 
	select
		s.id, s.c_type, s.c_name, h.id, h.c_house_number, h.c_house_corp, h.c_house_litera
	from dbo.cs_house as h
	inner join dbo.cs_street as s ON h.f_street = s.id
	where h.f_street = _f_street
	and (case when _c_house_number is not null then h.c_house_number ilike '%'||_c_house_number||'%' else 1=1 end)
	and (case when _c_house_corp is not null then h.c_house_corp ilike '%'||_c_house_corp||'%' else 1=1 end)
	and (case when _c_house_litera is not null then h.c_house_litera ilike '%'||_c_house_litera||'%' else 1=1 end);
END
$$;

ALTER FUNCTION dbo.cf_bss_is_house_exists(_f_street uuid, _c_house_number text, _c_house_corp text, _c_house_litera text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_is_house_exists(_f_street uuid, _c_house_number text, _c_house_corp text, _c_house_litera text) IS 'Проверка на наличие дома';

CREATE OR REPLACE FUNCTION dbo.cf_bss_is_steet_exists(_c_name text) RETURNS TABLE(id uuid, c_type text, c_name text)
    LANGUAGE plpgsql
    AS $$
/**
*
* @params {text} _c_name - часть имени улицы
*
* @example
* [{ "action": "cf_bss_is_steet_exists", "method": "Query", "data": [{ "params": [_c_name] }], "type": "rpc", "tid": 0}]
*/
BEGIN
	return query select s.id, s.c_type, s.c_name from dbo.cs_street as s where s.c_name ilike '%'||_c_name||'%';
END
$$;

ALTER FUNCTION dbo.cf_bss_is_steet_exists(_c_name text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_is_steet_exists(_c_name text) IS 'Проверка на наличие улицы';

CREATE OR REPLACE FUNCTION dbo.cf_bss_pd_users(_f_user integer, _f_role integer = NULL::integer, _f_division integer = NULL::integer, _f_subdivision integer = NULL::integer, _f_uik integer = NULL::integer) RETURNS TABLE(id integer, c_login text, c_first_name text, c_description text, b_disabled boolean, c_version text, n_version bigint)
    LANGUAGE plpgsql
    AS $$
/**
* @params {integer} f_user - идентификатор пользователя
* @params {integer} f_role - идентификатор роли
* @params {integer} f_division - идентификатор Района
* @params {integer} f_subdivision - идентификатор Округа
* @params {integer} f_uik - идентификатор УИК
*
* @returns - списка пользователей, которые досутпны для просмотра
*/
DECLARE
	_n_weight integer;
BEGIN	
	-- определяем вес роли
	select r.n_weight into _n_weight
	from core.pd_userinroles as uir
	inner join core.pd_roles as r ON uir.f_role = r.id
	where uir.f_user = _f_user
	order by r.n_weight desc
	limit 1;
	
	return query 
	select 
		u.id, -- иден.
		u.c_login, -- логин
		u.c_first_name, -- ФИО
		u.c_description, -- описание
		u.b_disabled, -- отключена
		u.c_version, -- строковая версия
		u.n_version -- номер версии
	-- список пользователей по весам
	from (select uir.f_user, uid.f_uik 
			from core.pd_userindivisions as uid
			inner join core.pd_userinroles as uir ON uir.f_user = uid.f_user
			inner join core.pd_roles as r ON r.id = uir.f_role
			where r.n_weight <= _n_weight
		 	and (case when _f_role is null then 1=1 else r.id = _f_role end)) as tu
	inner join core.pd_users as u ON u.id = tu.f_user
	where tu.f_uik in (with items as (select uid.f_division, uid.f_subdivision, uid.f_uik
						from core.pd_userindivisions as uid
						where uid.f_user = _f_user
									 and (case when _f_division is null then 1=1 else uid.f_division = _f_division end)
									 and (case when _f_subdivision is null then 1=1 else uid.f_subdivision = _f_subdivision end)
									 and (case when _f_uik is null then 1=1 else uid.f_uik = _f_uik end))
						select ur.f_uik from dbo.cv_uik_ref as ur
						where ur.f_division in (select t.f_division from items as t) or
						ur.f_subdivision in (select t.f_subdivision from items as t) or
						ur.f_uik in (select t.f_uik from items as t));
END
$$;

ALTER FUNCTION dbo.cf_bss_pd_users(_f_user integer, _f_role integer, _f_division integer, _f_subdivision integer, _f_uik integer) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_bss_pd_users(_f_user integer, _f_role integer, _f_division integer, _f_subdivision integer, _f_uik integer) IS 'Получение списка пользователей';

CREATE OR REPLACE FUNCTION dbo.cf_imp_generate_routes(_d_date_end date) RETURNS TABLE(c_login text, n_count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	return query 
	select
		u.c_login,
		dbo.cf_imp_by_user(r.f_user, 8, 3, now()::date, _d_date_end) as n_count
	from (	select 
		  		f_user
			from core.pd_userinroles
			where f_role = 5 -- только обходчики
			group by f_user) as r
	inner join core.pd_users as u ON r.f_user = u.id;
END
$$;

ALTER FUNCTION dbo.cf_imp_generate_routes(_d_date_end date) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_imp_generate_routes(_d_date_end date) IS 'Генерация маршрутов для агитаторов';

CREATE OR REPLACE FUNCTION dbo.cf_mui_cs_answer(_fn_user integer, _c_version text) RETURNS TABLE(id bigint, c_text text, f_question integer, f_next_question integer, c_action text, n_order integer, b_disabled boolean, dx_created timestamp with time zone, sn_delete boolean, c_const text, f_role integer)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
	RETURN QUERY SELECT a.id, a.c_text, a.f_question, a.f_next_question, a.c_action, a.n_order, a.b_disabled, a.dx_created, a.sn_delete, a.c_const, a.f_role
	FROM dbo.cs_answer as a
	where a.f_question IN (select q.id from dbo.cf_mui_cs_question(_fn_user, _c_version) as q);
END
$$;

ALTER FUNCTION dbo.cf_mui_cs_answer(_fn_user integer, _c_version text) OWNER TO mobnius;

CREATE OR REPLACE FUNCTION dbo.cf_mui_cs_question(_fn_user integer, _c_version text) RETURNS TABLE(id bigint, c_title text, c_description text, c_text text, n_order integer, dx_created timestamp with time zone, sn_delete boolean, c_role text, n_priority integer)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
	RETURN QUERY select q.id, q.c_title, q.c_description, q.c_text, q.n_order, q.dx_created, q.sn_delete, r.c_name, q.n_priority 
	from dbo.cs_question as q
	left join core.pd_roles as r ON q.f_role = r.id
	where q.b_disabled = false;
END
$$;

ALTER FUNCTION dbo.cf_mui_cs_question(_fn_user integer, _c_version text) OWNER TO mobnius;

CREATE OR REPLACE FUNCTION dbo.cf_tmp_cs_house_unknow() RETURNS TABLE(n_row bigint, id uuid, f_street uuid, c_short_type text, c_name text, f_subdivision integer, c_subdivision text, c_full_number text, c_house_number text, c_house_corp text, c_house_litera text, dx_date timestamp with time zone, b_disabled boolean, n_uik integer, f_user integer, c_first_name text, n_number integer, b_tmp_kalinin boolean, b_tmp_lenin boolean, b_tmp_moscow boolean, b_tmp_nov boolean, n_premise_count bigint, c_notice text, f_main_division integer)
    LANGUAGE plpgsql
    AS $$
BEGIN	
	return query 
	select
		row_number() over(order by s.c_type, s.c_name, h.id) AS n_row, -- номер п/п
		h.id, -- иден. дома
		h.f_street, -- иден. улицы
		s.c_short_type, -- тип улицы
		s.c_name, -- наименование улицы
		sd.id as f_subdivision, -- иден. округа
		sd.c_name as c_subdivision, -- имя округа
		h.c_full_number, -- адрес дома
		h.c_house_number,
		h.c_house_corp,
		h.c_house_litera,
		h.dx_date, -- дата создания
		h.b_disabled, -- отключен
		h.n_uik, -- УИК
		h.f_user, -- иден. автора
		u.c_first_name, -- имя автора
		h.n_number, -- числовой номер дома для сортировки
		h.b_tmp_kalinin,
		h.b_tmp_lenin,
		h.b_tmp_moscow,
		h.b_tmp_nov,
		(select count(*) from dbo.cs_appartament as a where a.f_house = h.id) as n_premise_count, -- количество квартир
		h.c_notice,
		s.f_main_division
	from dbo.cs_house as h
	left join dbo.cs_street as s ON s.id = h.f_street
	left join core.pd_users as u ON h.f_user = u.id
	left join core.sd_subdivisions as sd ON sd.id = h.f_subdivision
	where h.b_tmp_unknow --and (select count(*) from dbo.cs_appartament as a where a.f_house = h.id) != 0
	--and h.b_tmp_kalinin is null and h.b_tmp_lenin is null and h.b_tmp_moscow is null
	order by s.c_type, s.c_name, h.id;
END
$$;

ALTER FUNCTION dbo.cf_tmp_cs_house_unknow() OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_tmp_cs_house_unknow() IS 'Временная функция для получения неизвестных домов';

CREATE OR REPLACE FUNCTION dbo.cf_tmp_cs_house_unknow_history(_f_house uuid) RETURNS TABLE(id uuid, jb_old_value jsonb, jb_new_value jsonb, c_user text, d_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_house - иден. дома
*/
BEGIN	
	return query 
		select a.id, -- иден.
		a.jb_old_value, -- старые данные
		a.jb_new_value, -- новые данные
		a.c_user, -- пользователь
		a.d_date -- дата изменения
	FROM core.cd_action_log as a
	where a.c_table_name = 'cs_house' and a.c_operation = 'UPDATE' and _f_house::text = a.jb_old_value->>'id'
	order by a.d_date desc;
END
$$;

ALTER FUNCTION dbo.cf_tmp_cs_house_unknow_history(_f_house uuid) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_tmp_cs_house_unknow_history(_f_house uuid) IS 'Получение истории изменения дома';

CREATE OR REPLACE FUNCTION dbo.cf_tmp_house_update(_f_house uuid, _f_user integer, _n_uik integer, _f_subdivision integer, _c_house_number text, _c_house_corp text, _c_house_litera text, _b_kalinin boolean, _b_lenin boolean, _b_moscow boolean, _b_nov boolean, _c_notice text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_house - значение
* @params {integer} _f_user - Пользователь который вносит изменения
* @params {integer} _n_uik - УИК
* @params {integer} _f_subdivision - Округ ЧГСД
* @params {text} _c_house_number - номер дома
* @params {text} _c_house_corp - корпус
* @params {text} _c_house_litera - литера
* @params {boolean} _b_kalinin - принадлежит калининскому району
* @params {boolean} _b_lenin - принадлежит ленинскому району
* @params {boolean} _b_moscow - принадлежит московскому району
* @params {boolean} _b_nov - принадлежит новочебоксарску
* @params {text} _c_notice - примечание
*
* @returns {integer}
* 0 - ОК
* 1 - дом не найден или не отностится к плохим
*
* @example
* [{ "action": "cf_tmp_house_update", "method": "Select", "data": [{ "params": [_f_house, _f_user, _n_uik, _f_subdivision, _c_house_number, _c_house_corp, _c_house_litera, _b_kalinin, _b_lenin, _b_moscow, _b_nov, _c_notice] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	IF (select count(*) from dbo.cs_house where id = _f_house and b_tmp_unknow) = 1 then
		update dbo.cs_house as h
		set f_user = _f_user,
		n_uik = _n_uik,
		f_subdivision = _f_subdivision,
		b_tmp_kalinin = _b_kalinin,
		b_tmp_lenin = _b_lenin,
		b_tmp_moscow = _b_moscow,
		b_tmp_nov = _b_nov,
		dx_tmp_modified = now(),
		c_house_number = _c_house_number,
		c_house_corp = _c_house_corp,
		c_house_litera = _c_house_litera,
		c_notice = _c_notice
		where h.id = _f_house;
		
		return 0;
	end if;
	
	return 1;
END;
$$;

ALTER FUNCTION dbo.cf_tmp_house_update(_f_house uuid, _f_user integer, _n_uik integer, _f_subdivision integer, _c_house_number text, _c_house_corp text, _c_house_litera text, _b_kalinin boolean, _b_lenin boolean, _b_moscow boolean, _b_nov boolean, _c_notice text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_tmp_house_update(_f_house uuid, _f_user integer, _n_uik integer, _f_subdivision integer, _c_house_number text, _c_house_corp text, _c_house_litera text, _b_kalinin boolean, _b_lenin boolean, _b_moscow boolean, _b_nov boolean, _c_notice text) IS 'Обновление дома. Привязка УИК и Округа';

CREATE OR REPLACE FUNCTION dbo.cft_cs_house_number_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'INSERT' or TG_OP = 'UPDATE') THEN
		UPDATE dbo.cs_house as h
		set n_number = coalesce((select regexp_matches(c_house_number, '\d+'))[1]::integer, 0)
		where h.id = NEW.id;
	END IF;

	RETURN NEW;
END
$$;

ALTER FUNCTION dbo.cft_cs_house_number_update() OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cft_cs_house_number_update() IS 'Триггер. Обновление числового номера дома';

CREATE OR REPLACE FUNCTION dbo.cft_cs_house_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (TG_OP = 'INSERT' or TG_OP = 'UPDATE') THEN
		UPDATE dbo.cs_house as h
		set c_full_number = concat(c_house_number, (case when c_house_litera is not null then c_house_litera else '' end), (case when c_house_corp is not null and c_house_corp != '' then concat(' корп. ', c_house_corp) else '' end))
		where h.id = NEW.id;
	END IF;

	RETURN NEW;
END
$$;

ALTER FUNCTION dbo.cft_cs_house_update() OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cft_cs_house_update() IS 'Триггер. Обновление дома';

CREATE OR REPLACE FUNCTION dbo.sf_convert_number(_c_num text) RETURNS integer
    LANGUAGE plv8 IMMUTABLE STRICT
    AS $$
	/**
	* Преобразование номера агитатора в число
	*
	* @params {text} _c_num - например 1801-01
	* @returns {integer} 180101
	*
	* @example
	* [{ "action": "sf_convert_number", "method": "Select", "data": [{ "params": [_c_num] }], "type": "rpc", "tid": 0 }]
	*/
	return parseInt(_c_num.replace('-', ''));
$$;

ALTER FUNCTION dbo.sf_convert_number(_c_num text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.sf_convert_number(_c_num text) IS 'Преобразование номера агитатора в число';

CREATE OR REPLACE FUNCTION dbo.sf_distance(_n_longitude1 numeric, _n_latitude1 numeric, _n_longitude2 numeric, _n_latitude2 numeric) RETURNS numeric
    LANGUAGE plv8 IMMUTABLE STRICT
    AS $$
	/**
	* Дистанция между двумя точками
	*
	* @params {numeric} _n_longitude1
	* @params {numeric} _n_latitude1
	* @params {numeric} _n_longitude2
	* @params {numeric} _n_latitude2
	* @returns {numeric}
	*
	* @example
	* [{ "action": "sf_distance", "method": "Select", "data": [{ "params": [_n_longitude1, _n_latitude1, _n_longitude2, _n_latitude2] }], "type": "rpc", "tid": 0 }]
	*/
	return Math.sqrt(Math.pow(Math.abs(_n_longitude1 - _n_longitude2), 2) + Math.pow(Math.abs(_n_latitude1 - _n_latitude2), 2));
$$;

ALTER FUNCTION dbo.sf_distance(_n_longitude1 numeric, _n_latitude1 numeric, _n_longitude2 numeric, _n_latitude2 numeric) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.sf_distance(_n_longitude1 numeric, _n_latitude1 numeric, _n_longitude2 numeric, _n_latitude2 numeric) IS 'Дистанция между двумя точками';

CREATE OR REPLACE FUNCTION dbo.sf_generate_point_jb_data(_f_appartament uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_appartament - идентификатор квартиры
*
* @returns {jsonb}
*
* @example
* [{ "action": "sf_generate_point_jb_data", "method": "Query", "data": [{ "params": [_f_appartament] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_jb_data jsonb;
BEGIN
	select json_build_object('c_premise_num', a.c_number, 
					 		'n_premise_num', a.n_number,
					 		'c_address', concat(s.c_type, ' ', s.c_name),
					 		'c_house_number', h.c_full_number,
					 		'n_uik', h.n_uik,
					 		'n_priority', null,
					 		'c_premise_notice', a.c_notice)::jsonb into _jb_data
	from dbo.cs_appartament as a
	inner join dbo.cs_house as h ON h.id = a.f_house
	inner join dbo.cs_street as s ON s.id = h.f_street
	where a.id = _f_appartament;	

	RETURN _jb_data;
END
$$;

ALTER FUNCTION dbo.sf_generate_point_jb_data(_f_appartament uuid) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.sf_generate_point_jb_data(_f_appartament uuid) IS 'Генерация JSON информации для квартиры';

CREATE OR REPLACE FUNCTION dbo.sf_generate_route_jb_data(_f_house uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_house - идентификатор дома
*
* @returns {jsonb}
*
* @example
* [{ "action": "sf_generate_route_jb_data", "method": "Query", "data": [{ "params": [_f_house] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_jb_data jsonb;
BEGIN
	select json_build_object('c_street', concat(s.c_type, ' ', s.c_name),
					 		'c_house_number', h.c_full_number,
					 		'n_uik', h.n_uik,
					 		'c_house_notice', coalesce(h.c_notice, ''))::jsonb into _jb_data
	from dbo.cs_house as h
	inner join dbo.cs_street as s ON s.id = h.f_street
	where h.id = _f_house;	

	RETURN _jb_data;
END
$$;

ALTER FUNCTION dbo.sf_generate_route_jb_data(_f_house uuid) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.sf_generate_route_jb_data(_f_house uuid) IS 'Генерация JSON информации для дома';

CREATE OR REPLACE FUNCTION dbo.sf_imp_by_user(_f_user integer, _f_route_type integer, _f_point_type integer, _d_date_start date, _d_date_end date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
* @params {integer} _f_user - идентификатор агитатора
* @params {integer} _f_route_type - тип маршрута
* @params {integer} _f_point_type - тип точки
* @params {date} _d_date_start - дата начала
* @params {date} _d_date_end - дата завершения
*
* @returns {integer} - количество созданных точек
*
* @example
* [{ "action": "sf_imp_by_user", "method": "Query", "data": [{ "params": [_f_user, _f_route_type, _f_point_type, _d_date_start, _d_date_end] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_result integer;
BEGIN
	IF (select count(*) from dbo.cs_appartament as a where a.f_user = _f_user and a.b_disabled = false) > 0 THEN
		_result = ( select 
						sum((select dbo.cf_imp_points(_f_user, t.f_house, t.f_route, _f_point_type)))
					from (	select 
								a.f_house,
								(select dbo.sf_imp_route(a.f_house, _f_user, _f_route_type, _d_date_start, _d_date_end)) as f_route
							from dbo.cs_appartament as a
							where a.f_user = _f_user and a.b_disabled = false
							group by a.f_house, a.f_user) as t);
	ELSE
		_result = 0;
	END IF;
	
	RETURN _result;
END
$$;

ALTER FUNCTION dbo.sf_imp_by_user(_f_user integer, _f_route_type integer, _f_point_type integer, _d_date_start date, _d_date_end date) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.sf_imp_by_user(_f_user integer, _f_route_type integer, _f_point_type integer, _d_date_start date, _d_date_end date) IS 'Импорт данных для пользователя';

CREATE OR REPLACE FUNCTION dbo.sf_imp_generate_subdivision_routes(_n_subdivision integer, _d_date_date date) RETURNS TABLE(c_login text, n_count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	return query 
		select 
			u.c_login,
			dbo.cf_imp_by_user(uid.f_user, 8, 3, now()::date, _d_date_date) as n_count
		from core.pd_userindivisions as uid
		inner join core.sd_subdivisions as sd on sd.id = uid.f_subdivision
		inner join core.cd_userinroles as uir on uir.f_user = uid.f_user
		where uir.f_role = 5 and sd.n_code = _n_subdivision;
END
$$;

ALTER FUNCTION dbo.sf_imp_generate_subdivision_routes(_n_subdivision integer, _d_date_date date) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.sf_imp_generate_subdivision_routes(_n_subdivision integer, _d_date_date date) IS 'Генерация маршрутов для округа';

CREATE OR REPLACE FUNCTION dbo.sf_imp_points(_f_user integer, _f_house uuid, _f_route uuid, _f_point_type integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
* @params {integer} _f_user - иден. агитатора
* @params {uuid} _f_house - идентификатор дома
* @params {uuid} _f_route - идентификтаор маршрута
* @params {integer} _f_point_type - тип работ
*
* @returns {integer} - количество обработанных квартир
*
* @example
* [{ "action": "cf_imp_points", "method": "Select", "data": [{ "params": [_f_user, _f_house, _f_route, _f_point_type] }], "type": "rpc", "tid": 0 }]
*/
DECLARE
	_result integer;
BEGIN
	insert into core.cd_points(f_appartament, f_route, f_type, c_info, c_short_info, jb_data, n_order, sn_delete, b_anomaly)
	select a.id, _f_route, _f_point_type, '<b>Адрес:</b> c_address д. c_house_number кв. c_premise_num<br /><b>Примечание:</b> c_premise_notice', '', dbo.sf_generate_point_jb_data(a.id), coalesce(a.n_number, 0), false, false 
	from dbo.cs_appartament as a
	inner join dbo.cs_house as h ON h.id = a.f_house
	inner join dbo.cs_street as s ON s.id = h.f_street
	where a.f_user = _f_user and a.f_house = _f_house and a.b_disabled = false;
	
	_result = (select count(*) from dbo.cs_appartament as a
			   where a.f_user = _user_id and a.f_house = _f_house and a.b_disabled = false);
	RETURN _result;
END
$$;

ALTER FUNCTION dbo.sf_imp_points(_f_user integer, _f_house uuid, _f_route uuid, _f_point_type integer) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.sf_imp_points(_f_user integer, _f_house uuid, _f_route uuid, _f_point_type integer) IS 'Генерация точек маршрута';

CREATE OR REPLACE FUNCTION dbo.sf_imp_route(_f_house uuid, _f_user integer, _f_route_type integer, _d_date_start date, _d_date_end date, _b_draft boolean) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_house - идентификатор дома
* @params {integer} _f_user - идентификатор агитатора
* @params {integer} _f_route_type - тип маршрута
* @params {date} _d_date_start - дата начала
* @params {date} _d_date_end - дата завершения
*
* @returns {jsonb}
*
* @example
* [{ "action": "sf_create_route", "method": "Query", "data": [{ "params": [_f_house, _f_user, _f_route_type, _d_date_start, _d_date_end] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_f_route uuid;
	_c_address text;
	_n_order integer;
BEGIN
	_f_route = uuid_generate_v4();
	
	select concat(s.c_type, ' ', s.c_name, ' д. ', h.c_full_number), h.n_number into _c_address, _n_order
	from dbo.cs_house as h
	inner join dbo.cs_street as s ON h.f_street = s.id
	where h.id = _f_house;
	
	-- создать маршрут
	insert into core.cd_routes(id, f_type, c_address, d_date, d_date_start, d_date_end, c_info, b_extended, d_extended, jb_data, n_order, b_draft, f_status, f_house)
	values (_f_route, _f_route_type, _c_address, now(), _d_date_start, _d_date_end, '<b>Адрес:</b> c_street д. c_house_number<br /><b>Примечание:</b> c_house_notice', false, null, dbo.sf_generate_route_jb_data(_f_house), _n_order, _b_draft, 2, _f_house);

	-- привязать маршрут к пользователю
	insert into core.cd_userinroutes(f_route, f_user, b_main)
	values(_route_id, _user_id, true);

	-- добавить историю по маршруту
	insert into core.cd_route_history (fn_route, fn_status, fn_user, d_date) values
	(_route_id, 2, _user_id, now()),
	(_route_id, 3, _user_id, now());
	
	insert into core.cd_notifications(fn_user_to, c_title, c_message, d_date, fn_user_from, b_readed, b_sended)
	values (_user_id, 'Уведомление', concat('Назначен обход по адресу ', _c_address, ' на ', to_char(_d_date_start, 'dd.MM.YYYY'::text)), now(), 1, false, false);
	
	RETURN _route_id;
END
$$;

ALTER FUNCTION dbo.sf_imp_route(_f_house uuid, _f_user integer, _f_route_type integer, _d_date_start date, _d_date_end date, _b_draft boolean) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.sf_imp_route(_f_house uuid, _f_user integer, _f_route_type integer, _d_date_start date, _d_date_end date, _b_draft boolean) IS 'Создание маршрута';

CREATE OR REPLACE FUNCTION dbo.sf_percent(_n_item numeric, _n_count numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
/**
* @params {numeric} _n_item - значение
* @params {numeric} _n_count - общее количество
* @returns {numeric}
*
* @example
* [{ "action": "sf_percent", "method": "Select", "data": [{ "params": [_n_item, _n_count] }], "type": "rpc", "tid": 0 }]
*/
BEGIN
	return (_n_item * 100) / coalesce((case when _n_count = 0 then 1 else _n_count end), 1)::numeric;
END;
$$;

ALTER FUNCTION dbo.sf_percent(_n_item numeric, _n_count numeric) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.sf_percent(_n_item numeric, _n_count numeric) IS 'Вычисление процента';

CREATE OR REPLACE FUNCTION dbo.sf_point_update_info(_f_point uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
/**
* @params {uuid} _f_point - идентификатор точки
*
* @returns {jsonb}
*
* @example
* [{ "action": "cf_point_update_info", "method": "Query", "data": [{ "params": [_f_point] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_f_appartament uuid;
	_jb_data jsonb;
BEGIN
	select p.f_appartament into _f_appartament from core.cd_points as p
	where p.id = _f_point;

	select dbo.sf_generate_point_jb_data(_f_appartament) into _jb_data 
	from dbo.cs_appartament as a
	where a.id = _f_appartament;

	update core.cd_points as p
	set c_info = '<b>Адрес:</b> c_address д. c_house_number кв. c_premise_num<br /><b>Примечание:</b> c_premise_notice',
	jb_data = _jb_data
	where p.id = _f_point;
	
	RETURN 0;
END
$$;

ALTER FUNCTION dbo.sf_point_update_info(_f_point uuid) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.sf_point_update_info(_f_point uuid) IS 'Обновление информации для точки маршрута';

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

ALTER TABLE dbo.cd_people
	ADD CONSTRAINT cd_people_pkey PRIMARY KEY (id);

-- DEPCY: This CONSTRAINT is a dependency of CONSTRAINT: dbo.cd_people.cd_people_f_appartament

ALTER TABLE dbo.cs_appartament
	ADD CONSTRAINT cs_apartament_pkey PRIMARY KEY (id);

ALTER TABLE dbo.cd_people
	ADD CONSTRAINT cd_people_f_appartament FOREIGN KEY (f_appartament) REFERENCES dbo.cs_appartament(id);

-- DEPCY: This CONSTRAINT is a dependency of CONSTRAINT: dbo.cd_people.cd_people_f_type

ALTER TABLE dbo.cs_people_types
	ADD CONSTRAINT cs_people_types_pkey PRIMARY KEY (id);

ALTER TABLE dbo.cd_people
	ADD CONSTRAINT cd_people_f_type FOREIGN KEY (f_type) REFERENCES dbo.cs_people_types(id);

ALTER TABLE dbo.cd_signature_2018
	ADD CONSTRAINT cs_signature_pkey PRIMARY KEY (id);

ALTER TABLE dbo.cd_signature_2018
	ADD CONSTRAINT cs_signature_f_appartament_fkey FOREIGN KEY (f_appartament) REFERENCES dbo.cs_appartament(id) NOT VALID;

-- DEPCY: This CONSTRAINT is a dependency of CONSTRAINT: dbo.cd_signature_2018.cs_signature_f_friend_type_fkey

ALTER TABLE dbo.sf_friend_types
	ADD CONSTRAINT sf_friend_types_pkey PRIMARY KEY (id);

ALTER TABLE dbo.cd_signature_2018
	ADD CONSTRAINT cs_signature_f_friend_type_fkey FOREIGN KEY (f_friend_type) REFERENCES dbo.sf_friend_types(id) NOT VALID;

ALTER TABLE dbo.cd_uik
	ADD CONSTRAINT cd_uik_pkey PRIMARY KEY (id);

ALTER TABLE dbo.cs_answer
	ADD CONSTRAINT cs_answer_pkey PRIMARY KEY (id);

-- DEPCY: This CONSTRAINT is a dependency of CONSTRAINT: dbo.cs_answer.cs_answer_f_question_fkey

ALTER TABLE dbo.cs_question
	ADD CONSTRAINT cs_question_pkey PRIMARY KEY (id);

ALTER TABLE dbo.cs_answer
	ADD CONSTRAINT cs_answer_f_question_fkey FOREIGN KEY (f_question) REFERENCES dbo.cs_question(id);

ALTER TABLE dbo.cs_answer
	ADD CONSTRAINT cs_answer_f_next_question_fkey FOREIGN KEY (f_next_question) REFERENCES dbo.cs_question(id);

ALTER TABLE dbo.cs_answer
	ADD CONSTRAINT cs_answer_f_role_fkey FOREIGN KEY (f_role) REFERENCES core.pd_roles(id) NOT VALID;

ALTER TABLE dbo.cs_appartament
	ADD CONSTRAINT cs_apartment_f_house_fkey FOREIGN KEY (f_house) REFERENCES dbo.cs_house(id);

ALTER TABLE dbo.cs_appartament
	ADD CONSTRAINT cs_apartment_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id) NOT VALID;

ALTER TABLE dbo.cs_appartament
	ADD CONSTRAINT cs_appartament_f_created_user_idx FOREIGN KEY (f_created_user) REFERENCES core.pd_users(id) NOT VALID;

ALTER TABLE dbo.cs_house
	ADD CONSTRAINT cs_house_f_street_fkey FOREIGN KEY (f_street) REFERENCES dbo.cs_street(id);

ALTER TABLE dbo.cs_house
	ADD CONSTRAINT cs_house_f_subdivision_fkey FOREIGN KEY (f_subdivision) REFERENCES core.sd_subdivisions(id);

ALTER TABLE dbo.cs_house
	ADD CONSTRAINT cs_house_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id) NOT VALID;

ALTER TABLE dbo.cs_question
	ADD CONSTRAINT cs_question_f_role_fkey FOREIGN KEY (f_role) REFERENCES core.pd_roles(id) NOT VALID;

ALTER TABLE dbo.cs_street
	ADD CONSTRAINT cs_street_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id) NOT VALID;

ALTER TABLE dbo.cs_uik_ref
	ADD CONSTRAINT cs_uir_ref_pkey PRIMARY KEY (id);

ALTER TABLE dbo.cs_uik_ref
	ADD CONSTRAINT cs_uik_ref_f_division_fkey FOREIGN KEY (f_division) REFERENCES core.sd_divisions(id) NOT VALID;

ALTER TABLE dbo.cs_uik_ref
	ADD CONSTRAINT cs_uik_ref_f_subdivision_fkey FOREIGN KEY (f_subdivision) REFERENCES core.sd_subdivisions(id) NOT VALID;

ALTER TABLE dbo.cs_uik_ref
	ADD CONSTRAINT cs_uik_ref_f_uik_fkey FOREIGN KEY (f_uik) REFERENCES dbo.cd_uik(id) NOT VALID;

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

CREATE VIEW dbo.cv_street AS
	SELECT s.id,
    concat(d.c_name, ', ', s.c_short_type, ' ', s.c_name) AS c_name
   FROM (dbo.cs_street s
     JOIN core.sd_divisions d ON ((s.f_main_division = d.id)));

ALTER VIEW dbo.cv_street OWNER TO mobnius;

CREATE VIEW dbo.cv_tracking AS
	SELECT t.f_user,
    u.c_first_name AS c_name,
    t.d_date_str,
    t.d_date,
    t.n_longitude,
    t.n_latitude,
    t.c_network_status
   FROM (( SELECT t_1.fn_user AS f_user,
            to_char(t_1.d_date, 'dd.MM.YYYY HH24:MI'::text) AS d_date_str,
            max(t_1.d_date) AS d_date,
            avg(t_1.n_longitude) AS n_longitude,
            avg(t_1.n_latitude) AS n_latitude,
            max(t_1.c_network_status) AS c_network_status
           FROM core.ad_tracking t_1
          GROUP BY t_1.fn_user, (to_char(t_1.d_date, 'dd.MM.YYYY HH24:MI'::text))
        UNION ALL
         SELECT t_1.fn_user AS f_user,
            to_char(t_1.d_date, 'dd.MM.YYYY HH24:MI'::text) AS d_date_str,
            t_1.d_date,
            t_1.n_longitude,
            t_1.n_latitude,
            'online'::text AS c_network_status
           FROM core.cd_user_points t_1
          WHERE (t_1.n_longitude > (1)::numeric)) t
     JOIN core.pd_users u ON ((t.f_user = u.id)))
  ORDER BY t.d_date;

ALTER VIEW dbo.cv_tracking OWNER TO mobnius;

CREATE VIEW dbo.cv_uik_tmp_nov_ref AS
	SELECT ur.f_division,
    ur.f_subdivision,
    ur.f_uik,
    sd.c_name AS c_subdivision
   FROM (dbo.cs_uik_ref ur
     JOIN core.sd_subdivisions sd ON ((ur.f_subdivision = sd.id)));

ALTER VIEW dbo.cv_uik_tmp_nov_ref OWNER TO mobnius;

COMMENT ON VIEW dbo.cv_uik_tmp_nov_ref IS 'Привязка УИК к Округам и Районам. для новочебоксарска. Временно';

CREATE INDEX cd_action_log_c_table_name_c_operation_idx ON core.cd_action_log USING btree (c_table_name, c_operation);

CREATE INDEX cd_results_fn_route_b_disabled_idx ON core.cd_results USING btree (fn_route, b_disabled);

CREATE INDEX cd_people_f_appartament_idx ON dbo.cd_people USING btree (f_appartament);

CREATE INDEX cd_people_f_type_idx ON dbo.cd_people USING btree (f_type);

CREATE INDEX cd_people_f_appartament_f_type_idx ON dbo.cd_people USING btree (f_appartament, f_type);

CREATE INDEX cd_signature_2018_f_friend_type_idx ON dbo.cd_signature_2018 USING btree (f_friend_type);

CREATE INDEX cd_signature_2018_f_appartament_idx ON dbo.cd_signature_2018 USING btree (f_appartament);

CREATE INDEX cd_signature_2018_n_signature_idx ON dbo.cd_signature_2018 USING btree (n_signature);

CREATE INDEX cs_appartament_f_house_idx ON dbo.cs_appartament USING btree (f_house);

CREATE INDEX cs_appartament_f_user_idx ON dbo.cs_appartament USING btree (f_user);

CREATE INDEX cs_appartament_f_house_b_disabled ON dbo.cs_appartament USING btree (f_house, b_disabled);

CREATE INDEX cs_appartament_f_user_f_house_b_disabled_idx ON dbo.cs_appartament USING btree (f_user, f_house, b_disabled);

CREATE INDEX cs_appartament_f_user_b_disabled_idx ON dbo.cs_appartament USING btree (f_user, b_disabled);

CREATE INDEX cs_house_f_street_idx ON dbo.cs_house USING btree (f_street);

CREATE INDEX cs_house_f_subdivision_idx ON dbo.cs_house USING btree (f_subdivision);

CREATE INDEX cs_house_b_disabled ON dbo.cs_house USING btree (b_disabled);

CREATE INDEX cs_street_idx ON dbo.cs_street USING btree (f_user);

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

CREATE TRIGGER cd_people_1
	BEFORE INSERT OR UPDATE OR DELETE ON dbo.cd_people
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER cd_uik_1
	BEFORE INSERT OR UPDATE OR DELETE ON dbo.cd_uik
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER cs_answer_1
	BEFORE INSERT OR UPDATE OR DELETE ON dbo.cs_answer
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER cs_answer_change_version
	AFTER INSERT OR UPDATE ON dbo.cs_answer
	FOR EACH STATEMENT
	EXECUTE PROCEDURE core.cft_table_state_change_version();

CREATE TRIGGER cs_appartament_1
	BEFORE INSERT OR UPDATE OR DELETE ON dbo.cs_appartament
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER cs_house_1
	BEFORE INSERT OR UPDATE OR DELETE ON dbo.cs_house
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER cs_house_update
	AFTER INSERT OR UPDATE OF c_house_number, c_house_corp, c_house_litera ON dbo.cs_house
	FOR EACH ROW
	EXECUTE PROCEDURE dbo.cft_cs_house_update();

CREATE TRIGGER cs_house_number_update
	AFTER INSERT OR UPDATE OF c_house_number ON dbo.cs_house
	FOR EACH ROW
	EXECUTE PROCEDURE dbo.cft_cs_house_number_update();

CREATE TRIGGER cs_people_types_1
	BEFORE INSERT OR UPDATE OR DELETE ON dbo.cs_people_types
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER cs_question_1
	BEFORE INSERT OR UPDATE OR DELETE ON dbo.cs_question
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

CREATE TRIGGER cs_question_change_version
	AFTER INSERT OR UPDATE ON dbo.cs_question
	FOR EACH STATEMENT
	EXECUTE PROCEDURE core.cft_table_state_change_version();

CREATE TRIGGER cs_street_1
	BEFORE INSERT OR UPDATE OR DELETE ON dbo.cs_street
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

ALTER SEQUENCE core.sd_table_change_id_seq
	OWNED BY core.sd_table_change.id;

ALTER SEQUENCE core.sd_table_change_ref_id_seq
	OWNED BY core.sd_table_change_ref.id;

ALTER SEQUENCE dbo.cs_uir_ref_id_seq
	OWNED BY dbo.cs_uik_ref.id;

ALTER SEQUENCE dbo.sf_friend_types_id_seq
	OWNED BY dbo.sf_friend_types.id;

COMMIT TRANSACTION;