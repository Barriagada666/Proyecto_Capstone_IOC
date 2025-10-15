-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.dim_maquina (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  codigo_maquina character varying NOT NULL UNIQUE,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  nombre_maquina character varying,
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT dim_maquina_pkey PRIMARY KEY (id)
);
CREATE TABLE public.dim_maquinista (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  codigo_maquinista bigint NOT NULL UNIQUE,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  nombre_completo character varying,
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT dim_maquinista_pkey PRIMARY KEY (id)
);
CREATE TABLE public.etl_jobs (
  job_id uuid NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  details character varying,
  file_hash character varying NOT NULL UNIQUE,
  file_name character varying NOT NULL,
  finished_at timestamp with time zone,
  max_date date,
  min_date date,
  status character varying NOT NULL,
  user_id character varying NOT NULL,
  CONSTRAINT etl_jobs_pkey PRIMARY KEY (job_id)
);
CREATE TABLE public.fact_production (
  fecha_contabilizacion date NOT NULL,
  id bigint NOT NULL DEFAULT nextval('fact_production_id_seq'::regclass),
  bodeguero character varying,
  cantidad numeric NOT NULL,
  centro_costos bigint,
  documento bigint,
  fecha_notificacion date NOT NULL,
  hora_contabilizacion time without time zone NOT NULL,
  jornada character varying,
  lista character varying,
  material_descripcion character varying,
  material_sku bigint NOT NULL,
  numero_log bigint NOT NULL,
  numero_pallet integer,
  peso_neto numeric NOT NULL,
  turno character varying NOT NULL,
  usuario_sap character varying,
  version_produccion character varying,
  maquina_fk bigint NOT NULL,
  maquinista_fk bigint,
  status_origen character varying,
  CONSTRAINT fact_production_pkey PRIMARY KEY (id),
  CONSTRAINT fkdk22snqrhksgxmy15068ohk8r FOREIGN KEY (maquina_fk) REFERENCES public.dim_maquina(id),
  CONSTRAINT fk5l7gwkhptwe57j4b45k989tyi FOREIGN KEY (maquinista_fk) REFERENCES public.dim_maquinista(id)
);
CREATE TABLE public.quarantined_records (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  error_details character varying NOT NULL,
  file_name character varying NOT NULL,
  line_number integer,
  raw_line character varying NOT NULL,
  job_id uuid NOT NULL,
  CONSTRAINT quarantined_records_pkey PRIMARY KEY (id),
  CONSTRAINT fkjtwob9x7adq03rhjr74wuvlsg FOREIGN KEY (job_id) REFERENCES public.etl_jobs(job_id)
);
CREATE TABLE public.roles (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  name character varying NOT NULL UNIQUE,
  CONSTRAINT roles_pkey PRIMARY KEY (id)
);
CREATE TABLE public.test (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  nombre text,
  CONSTRAINT test_pkey PRIMARY KEY (id)
);
CREATE TABLE public.users (
  id uuid NOT NULL,
  email character varying NOT NULL UNIQUE,
  full_name character varying,
  role_id integer,
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT fkp56c1712k691lhsyewcssf40f FOREIGN KEY (role_id) REFERENCES public.roles(id)
);
