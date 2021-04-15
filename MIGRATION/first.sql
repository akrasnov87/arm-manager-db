START TRANSACTION;

insert into core.pd_roles (id, c_name, c_description, n_weight) values 
(-1, 'anonymous', 'Анонимный', 0), -- -1
(1, 'admin', 'Администратор', 900), -- 1
(2, 'user', 'Пользователь', 800), -- 2
(3, 'full', 'Полный доступ', 700), -- 3
(4, 'change', 'Только изменение', 600), -- 4
(5, 'readonly', 'Просмотр', 500); -- 5

insert into core.pd_users (id, c_login, c_password) values(-1, 'anonymous', ''); -- -1
insert into core.pd_users (id, c_login, c_password) values
(1, 'admin', 'admin0'); --1

insert into core.pd_accesses (f_role, c_function, b_deletable, b_creatable, b_editable, b_full_control) 
values (1, 'PN.*', true, true, true, false),
(2, 'PN.*', false, false, false, false),
(3, 'PN.*', true, true, true, false),
(4, 'PN.*', false, false, true, false);


insert into core.pd_userinroles (f_user, f_role) 
values (1, 1);

insert into core.pd_userinroles (id, f_user, f_role) 
values (-1, -1, -1); -- анонимный

insert into core.cs_setting_types (id, n_code, c_name, c_short_name, c_const, n_order, b_default) values
(1, 1, 'Строка', 'стр.', 'TEXT', 1000, true),
(2, 2, 'Число', 'чсл.', 'INTEGER', 900, false),
(3, 3, 'Логическое', 'лог.', 'BOOLEAN', 800, false),
(4, 4, 'Числа с запятой', 'чслз.', 'REAL', 700, false);

insert into core.cd_settings (id, c_key, c_value, f_type, c_label, c_summary, f_user) values
(1, 'home_page', 'login', 1, 'Домашняя страница', null, null),
(2, 'DB_VERSION', '1.39.0.504', 1, 'Версия БД', null, null),
(3, 'ALL_DEL_AFTER', '30', 2, 'Хранение информации', null, null);

COMMIT TRANSACTION;