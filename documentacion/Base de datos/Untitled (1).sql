-- =============================================================================
-- 1. TABLAS DE SEGURIDAD Y ROLES
-- =============================================================================

CREATE TABLE "ori_user" (
                            "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
                            "user_name" varchar(255) UNIQUE NOT NULL,
                            "password_hash" varchar(255) NOT NULL,
                            "status" varchar(50) NOT NULL,
                            "created_at" timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                            "mfa_secret" varchar(64),
                            "mfa_enabled" boolean NOT NULL DEFAULT false,
                            "mfa_setup_at" timestamp,
                            "mfa_validation_attempts" integer DEFAULT 0,
                            "mfa_last_attempt_at" timestamp
);
CREATE TABLE "ori_role" (
                            "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
                            "name" varchar(50) UNIQUE NOT NULL,
                            "description" varchar(255),
                            "status" varchar(20) NOT NULL DEFAULT 'ACTIVE',
                            "created_at" timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                            "updated_at" timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                            "created_by" uuid
);
CREATE TABLE "ori_permission" (
                                  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
                                  "name" varchar(100) UNIQUE NOT NULL,
                                  "resource" varchar(50) NOT NULL,
                                  "action" varchar(50) NOT NULL,
                                  "description" varchar(255),
                                  "status" varchar(20) NOT NULL,
                                  "created_at" timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);
CREATE TABLE "ori_user_role" (
                                 "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
                                 "user_id" uuid NOT NULL,
                                 "role_id" uuid NOT NULL,
                                 "assigned_at" timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                                 "assigned_by" uuid,
                                 "expires_at" timestamp
);
CREATE TABLE "ori_role_permission" (
                                       "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
                                       "role_id" uuid NOT NULL,
                                       "permission_id" uuid NOT NULL,
                                       "granted_at" timestamp NOT NULL DEFAULT (CURRENT_TIMESTAMP),
                                       "granted_by" uuid
);


ALTER TABLE "ori_user_role" ADD FOREIGN KEY ("user_id") REFERENCES "ori_user" ("id");
ALTER TABLE "ori_user_role" ADD FOREIGN KEY ("role_id") REFERENCES "ori_role" ("id");
ALTER TABLE "ori_role_permission" ADD FOREIGN KEY ("role_id") REFERENCES "ori_role" ("id");
ALTER TABLE "ori_role_permission" ADD FOREIGN KEY ("permission_id") REFERENCES "ori_permission" ("id");


-- =============================================================================
-- 2. TABLAS DE MANTENIMIENTO (CATÁLOGOS)
-- =============================================================================

CREATE TABLE "mant_unidad_funcional" (
  "id_unidad_funcional" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "nombre" VARCHAR(150) NOT NULL,
  "descripcion" TEXT,
  "url_evidencia_creacion" VARCHAR(255),
  "estado" VARCHAR(20) CHECK (estado IN ('ACTIVADO', 'DESACTIVADO')) DEFAULT 'ACTIVADO',
  "fecha_registro" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "usuario_registro" VARCHAR(100) NOT NULL,
  "fecha_modificacion" TIMESTAMP,
  "usuario_modificacion" VARCHAR(100)
);

CREATE TABLE "mant_categorias" (
  "id_categoria" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "nombre" VARCHAR(150) NOT NULL,
  "descripcion" TEXT,
  "estado" VARCHAR(20) DEFAULT 'ACTIVO',
  "fecha_registro" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "usuario_registro" VARCHAR(100) NOT NULL,
  "fecha_modificacion" TIMESTAMP,
  "usuario_modificacion" VARCHAR(100)
);

CREATE TABLE "mant_temporalidad" (
  "id_temporalidad" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "nombre" VARCHAR(100) NOT NULL,
  "cantidad_dias" INT,
  "descripcion" TEXT,
  "estado" VARCHAR(20) DEFAULT 'ACTIVO',
  "fecha_registro" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "usuario_registro" VARCHAR(100) NOT NULL
);

-- =============================================================================
-- 3. CONFIGURACIÓN DINÁMICA DE INDICADORES
-- =============================================================================

CREATE TABLE "mant_indicadores" (
  "id_indicador" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "id_unidad_funcional" INT NOT NULL,
  "id_categoria" INT NOT NULL,
  "id_temporalidad" INT NOT NULL,
  "nombre_indicador" TEXT NOT NULL,
  "fuente_datos" VARCHAR(50) CHECK (fuente_datos IN ('PRIMARIA', 'SECUNDARIA', 'MIXTA')),
  "codigo_producto" VARCHAR(50),
  "url_ficha_tecnica" VARCHAR(255),
  "url_ficha_familiar" VARCHAR(255),
  
  -- METADATO PARA EL FRONTEND: Define qué columnas se ven en la tabla
  -- Ejemplo: {"columnas": [{"key": "sexo", "label": "Género"}, {"key": "procedencia", "label": "Procedencia"}]}
  "config_tabla_ui" JSONB NOT NULL DEFAULT '{"columnas": []}',
  
  "estado" VARCHAR(20) DEFAULT 'ACTIVO',
  "fecha_registro" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "usuario_registro" VARCHAR(100) NOT NULL,
  "fecha_modificacion" TIMESTAMP,
  "usuario_modificacion" VARCHAR(100),
  
  CONSTRAINT fk_ind_unidad FOREIGN KEY ("id_unidad_funcional") REFERENCES "mant_unidad_funcional" ("id_unidad_funcional"),
  CONSTRAINT fk_ind_categoria FOREIGN KEY ("id_categoria") REFERENCES "mant_categorias" ("id_categoria"),
  CONSTRAINT fk_ind_temporalidad FOREIGN KEY ("id_temporalidad") REFERENCES "mant_temporalidad" ("id_temporalidad")
);

-- =============================================================================
-- 4. TABLA ÚNICA DE HECHOS (DATA GENERALIZADA CON JSONB)
-- =============================================================================

CREATE TABLE "data_indicadores" (
  "id_registro" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "id_indicador" INT NOT NULL,
  "anio" INT NOT NULL,
  "periodo" VARCHAR(100), -- Eje: '2024-Q1', 'Marzo'
  
  -- CAMPOS DINÁMICOS: Aquí se guardan las variables que varían entre figuras
  -- Ejemplo Figura 1: {"sexo": "F", "procedencia": "Rural"}
  -- Ejemplo Figura 2: {"tipo_intervencion": "Nutrición"}
  "dimensiones" JSONB NOT NULL DEFAULT '{}',
  
  "cantidad" INT NOT NULL DEFAULT 0,
  "fuente" VARCHAR(100),
  "informacion_completa" VARCHAR(2) CHECK (informacion_completa IN ('SI', 'NO')),
  "estado_documento" VARCHAR(50), -- Eje: 'Con Documento', 'Sin Documento'
  "url_evidencia" VARCHAR(255),
  
  "fecha_registro" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "usuario_registro" VARCHAR(100) NOT NULL,
  "fecha_modificacion" TIMESTAMP,
  "usuario_modificacion" VARCHAR(100),
  
  CONSTRAINT fk_data_indicador FOREIGN KEY ("id_indicador") REFERENCES "mant_indicadores" ("id_indicador")
);

-- ÍNDICE GIN: Crucial para Postgres 16 para buscar velozmente dentro de JSONB
CREATE INDEX idx_data_dimensiones_gin ON "data_indicadores" USING GIN ("dimensiones");

-- =============================================================================
-- 5. DISGREGACIÓN Y REPORTES
-- =============================================================================

CREATE TABLE "mant_niveles_disgregacion" (
  "id_nivel_disgregacion" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "nombre" VARCHAR(150) NOT NULL,
  "descripcion" TEXT,
  "estado" VARCHAR(20) DEFAULT 'ACTIVO',
  "fecha_registro" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "usuario_registro" VARCHAR(100) NOT NULL
);

CREATE TABLE "mant_items_disgregacion" (
  "id_item_disgregacion" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "id_nivel_disgregacion" INT NOT NULL,
  "nombre_item" VARCHAR(150) NOT NULL,
  "descripcion" TEXT,
  "estado" VARCHAR(20) DEFAULT 'ACTIVO',
  "fecha_registro" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "usuario_registro" VARCHAR(100) NOT NULL,
  CONSTRAINT fk_item_nivel FOREIGN KEY ("id_nivel_disgregacion") REFERENCES "mant_niveles_disgregacion" ("id_nivel_disgregacion") ON DELETE CASCADE
);

CREATE TABLE "rel_indicador_disgregacion" (
  "id_relacion" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "id_indicador" INT NOT NULL,
  "id_nivel_disgregacion" INT NOT NULL,
  CONSTRAINT fk_rel_indicador FOREIGN KEY ("id_indicador") REFERENCES "mant_indicadores" ("id_indicador") ON DELETE CASCADE,
  CONSTRAINT fk_rel_nivel FOREIGN KEY ("id_nivel_disgregacion") REFERENCES "mant_niveles_disgregacion" ("id_nivel_disgregacion")
);

CREATE UNIQUE INDEX idx_rel_ind_nivel ON "rel_indicador_disgregacion" ("id_indicador", "id_nivel_disgregacion");

CREATE TABLE "control_reportes" (
  "id_control" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "id_indicador" INT NOT NULL,
  "gobierno_local" VARCHAR(100) DEFAULT 'Wanchaq',
  "anio_periodo" INT NOT NULL,
  "temporalidad_periodo" VARCHAR(100),
  "porcentaje_avance" INT CHECK (porcentaje_avance BETWEEN 0 AND 100) DEFAULT 0,
  "estado_validacion" VARCHAR(20) CHECK (estado_validacion IN ('PENDIENTE', 'VALIDADO', 'OBSERVADO')) DEFAULT 'PENDIENTE',
  "fecha_validacion" TIMESTAMP,
  "usuario_validador" VARCHAR(100),
  CONSTRAINT fk_control_indicador FOREIGN KEY ("id_indicador") REFERENCES "mant_indicadores" ("id_indicador")
);