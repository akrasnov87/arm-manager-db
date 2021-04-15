CREATE SEQUENCE core.dd_documents_id_seq
	AS integer
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

ALTER SEQUENCE core.dd_documents_id_seq OWNER TO mobnius;

ALTER SEQUENCE core.dd_documents_id_seq
	OWNED BY core.dd_documents.id;
