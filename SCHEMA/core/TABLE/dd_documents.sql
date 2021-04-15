CREATE TABLE core.dd_documents (
	id integer DEFAULT nextval('core.dd_documents_id_seq'::regclass) NOT NULL,
	n_number integer,
	c_fio text NOT NULL,
	d_birthday date NOT NULL,
	n_year smallint NOT NULL,
	c_document text NOT NULL,
	c_address text,
	d_date timestamp with time zone,
	c_time text,
	c_intent text,
	c_account text,
	c_accept text,
	c_earth text,
	d_take_off_solution date,
	d_take_off_message date,
	c_notice text,
	f_user integer NOT NULL,
	f_parent integer,
	sn_delete boolean NOT NULL
);

ALTER TABLE core.dd_documents OWNER TO mobnius;

COMMENT ON COLUMN core.dd_documents.id IS 'Идентификатор';

COMMENT ON COLUMN core.dd_documents.n_number IS 'Номер';

COMMENT ON COLUMN core.dd_documents.c_fio IS 'Фамилия, Имя, Отчество заявителя';

COMMENT ON COLUMN core.dd_documents.d_birthday IS 'Дата рождения';

COMMENT ON COLUMN core.dd_documents.n_year IS 'Возраст на момент постановки';

COMMENT ON COLUMN core.dd_documents.c_document IS 'Реквизиты документа, удостоверяющего личность';

COMMENT ON COLUMN core.dd_documents.c_address IS 'Адрес, телефон';

COMMENT ON COLUMN core.dd_documents.d_date IS 'Дата подачи заявления';

COMMENT ON COLUMN core.dd_documents.c_time IS 'Время подачи заявления';

COMMENT ON COLUMN core.dd_documents.c_intent IS 'Цель использования земельного участка';

COMMENT ON COLUMN core.dd_documents.c_account IS 'Постановление о постановке на учет';

COMMENT ON COLUMN core.dd_documents.c_accept IS 'Дата и номер принятия решения';

COMMENT ON COLUMN core.dd_documents.c_earth IS 'Кадастровй номер земельного участка';

COMMENT ON COLUMN core.dd_documents.d_take_off_solution IS 'Решение о снятии с учета';

COMMENT ON COLUMN core.dd_documents.d_take_off_message IS 'Сообщение заявителю о снятии с учета';

COMMENT ON COLUMN core.dd_documents.c_notice IS 'Примечание';

COMMENT ON COLUMN core.dd_documents.f_user IS 'Пользователь';

COMMENT ON COLUMN core.dd_documents.f_parent IS 'Родитель';

--------------------------------------------------------------------------------

CREATE TRIGGER dd_documents_1
	BEFORE INSERT OR UPDATE OR DELETE ON core.dd_documents
	FOR EACH ROW
	EXECUTE PROCEDURE core.cft_log_action();

--------------------------------------------------------------------------------

ALTER TABLE core.dd_documents
	ADD CONSTRAINT dd_documents_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

ALTER TABLE core.dd_documents
	ADD CONSTRAINT dd_documnets_f_user_fkey FOREIGN KEY (f_user) REFERENCES core.pd_users(id) NOT VALID;

--------------------------------------------------------------------------------

ALTER TABLE core.dd_documents
	ADD CONSTRAINT dd_documents_f_parent_fkey FOREIGN KEY (f_parent) REFERENCES core.dd_documents(id) NOT VALID;
