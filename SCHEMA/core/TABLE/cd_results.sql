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

--------------------------------------------------------------------------------

CREATE INDEX cd_results_fn_route_b_disabled_idx ON core.cd_results USING btree (fn_route, b_disabled);

--------------------------------------------------------------------------------

CREATE TRIGGER cd_results_change_version
	AFTER INSERT OR UPDATE OR DELETE ON core.cd_results
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_table_state_change_version();

--------------------------------------------------------------------------------

ALTER TABLE core.cd_results
	ADD CONSTRAINT cd_results_pkey PRIMARY KEY (id);
