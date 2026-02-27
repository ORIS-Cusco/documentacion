/*******************************************************************************
 * SCRIPT CONSOLIDADO: OBSERVATORIO REGIONAL DE INCLUSIÓN SOCIAL
 * Estructura: Esquemas de Seguridad y Observatorio (Negocio)
 * Incluye: Tablas Maestras, Transaccionales y Auditoría.
 *******************************************************************************/

-- =============================================================================
-- 1. CREACIÓN DE ESQUEMAS
-- =============================================================================
CREATE SCHEMA IF NOT EXISTS seguridad;
CREATE SCHEMA IF NOT EXISTS observatorio;

-- =============================================================================
-- 2. ESQUEMA SEGURIDAD (TABLAS)
-- =============================================================================

-- Tabla de Roles (Perfiles de usuario)
CREATE TABLE roles (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    estado VARCHAR(20) DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Usuarios (Gestión de accesos y perfiles)
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    id_rol INT NOT NULL REFERENCES roles(id_rol),
    dni VARCHAR(15) NOT NULL UNIQUE,
    nombres VARCHAR(150) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    celular VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    sector VARCHAR(100) DEFAULT 'WANCHAQ',
    unidad_funcional_asignada VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'ACTIVADO' CHECK (estado IN ('ACTIVADO', 'DESACTIVADO')),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_registro VARCHAR(100) NOT NULL,
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100)
);

-- =============================================================================
-- 3. ESQUEMA OBSERVATORIO (MAESTRAS)
-- =============================================================================

-- Unidades Funcionales (Ej: Primera Infancia, Juventud, Mujer)
CREATE TABLE mant_unidad_funcional (
    id_unidad_funcional SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    url_evidencia_creacion VARCHAR(255),
    estado VARCHAR(20) DEFAULT 'ACTIVADO' CHECK (estado IN ('ACTIVADO', 'DESACTIVADO')),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_registro VARCHAR(100) NOT NULL,
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100)
);

-- Categorías (Ej: Educación, Salud, Protección, Participación)
CREATE TABLE mant_categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_registro VARCHAR(100) NOT NULL,
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100)
);

-- Temporalidad (Ej: Anual, Semestral, Trimestral)
CREATE TABLE mant_temporalidad (
    id_temporalidad SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cantidad_dias INT,
    descripcion TEXT,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_registro VARCHAR(100) NOT NULL
);

-- Niveles de Disgregación Padre (Ej: Procedencia, Género, Nivel Académico)
CREATE TABLE mant_niveles_disgregacion (
    id_nivel_disgregacion SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_registro VARCHAR(100) NOT NULL
);

-- Items de Disgregación Hijos (Ej: Rural, Urbano, Primaria, Secundaria)
CREATE TABLE mant_items_disgregacion (
    id_item_disgregacion SERIAL PRIMARY KEY,
    id_nivel_disgregacion INT NOT NULL REFERENCES mant_niveles_disgregacion(id_nivel_disgregacion) ON DELETE CASCADE,
    nombre_item VARCHAR(150) NOT NULL,
    descripcion TEXT,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_registro VARCHAR(100) NOT NULL
);

-- INDICADORES (La tabla principal que une todo)
CREATE TABLE mant_indicadores (
    id_indicador SERIAL PRIMARY KEY,
    id_unidad_funcional INT NOT NULL REFERENCES mant_unidad_funcional(id_unidad_funcional),
    id_categoria INT NOT NULL REFERENCES mant_categorias(id_categoria),
    id_temporalidad INT NOT NULL REFERENCES mant_temporalidad(id_temporalidad),
    nombre_indicador TEXT NOT NULL,
    fuente_datos VARCHAR(50) CHECK (fuente_datos IN ('PRIMARIA', 'SECUNDARIA', 'MIXTA')),
    codigo_producto VARCHAR(50),
    url_ficha_tecnica VARCHAR(255),
    url_ficha_familiar VARCHAR(255),
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_registro VARCHAR(100) NOT NULL,
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100)
);

-- Relación Indicador <-> Niveles de Disgregación (Muchos a Muchos)
CREATE TABLE rel_indicador_disgregacion (
    id_relacion SERIAL PRIMARY KEY,
    id_indicador INT NOT NULL REFERENCES mant_indicadores(id_indicador) ON DELETE CASCADE,
    id_nivel_disgregacion INT NOT NULL REFERENCES mant_niveles_disgregacion(id_nivel_disgregacion),
    UNIQUE(id_indicador, id_nivel_disgregacion)
);

-- =============================================================================
-- 4. ESQUEMA OBSERVATORIO (TRANSACCIONAL / DATOS)
-- =============================================================================

-- Datos Institucionales (Colegios, Wawawasis, Centros de Salud, etc.)
CREATE TABLE data_institucional (
    id_registro BIGSERIAL PRIMARY KEY,
    id_indicador INT NOT NULL REFERENCES mant_indicadores(id_indicador),
    id_unidad_funcional INT REFERENCES mant_unidad_funcional(id_unidad_funcional),
    id_categoria INT REFERENCES mant_categorias(id_categoria),
    anio INT NOT NULL,
    distrito VARCHAR(100) DEFAULT 'Wanchaq',
    nombre_institucion VARCHAR(200),
    tipo_entidad VARCHAR(150),
    gestion VARCHAR(100),
    cantidad INT NOT NULL DEFAULT 0,
    fuente VARCHAR(100),
    informacion_completa VARCHAR(2) CHECK (informacion_completa IN ('SI', 'NO')),
    estado_documento VARCHAR(50),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_registro VARCHAR(100) NOT NULL,
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100)
);

-- Datos Poblacionales/Demográficos
CREATE TABLE data_poblacional (
    id_registro BIGSERIAL PRIMARY KEY,
    id_indicador INT NOT NULL REFERENCES mant_indicadores(id_indicador),
    id_categoria INT REFERENCES mant_categorias(id_categoria),
    anio INT NOT NULL,
    periodo VARCHAR(100),
    distrito VARCHAR(100) DEFAULT 'Wanchaq',
    sexo CHAR(1) CHECK (sexo IN ('F', 'M')),
    procedencia VARCHAR(50),
    grupo_etario VARCHAR(100),
    nombre_variable VARCHAR(100),
    valor_variable VARCHAR(150),
    cantidad INT NOT NULL,
    fuente VARCHAR(100),
    informacion_completa VARCHAR(2) CHECK (informacion_completa IN ('SI', 'NO')),
    estado_documento VARCHAR(50),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_registro VARCHAR(100) NOT NULL,
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100)
);

-- Control de Avance y Validación de Reportes
CREATE TABLE control_reportes (
    id_control SERIAL PRIMARY KEY,
    id_indicador INT NOT NULL REFERENCES mant_indicadores(id_indicador),
    gobierno_local VARCHAR(100) DEFAULT 'Wanchaq',
    anio_periodo INT NOT NULL,
    temporalidad_periodo VARCHAR(100),
    porcentaje_avance INT DEFAULT 0 CHECK (porcentaje_avance BETWEEN 0 AND 100),
    estado_validacion VARCHAR(20) DEFAULT 'PENDIENTE' CHECK (estado_validacion IN ('PENDIENTE', 'VALIDADO', 'OBSERVADO')),
    fecha_validacion TIMESTAMP,
    usuario_validador VARCHAR(100)
);

-- =============================================================================
-- 5. INSERCIÓN DE DATOS MAESTROS (SEGURIDAD Y OBSERVATORIO)
-- =============================================================================

INSERT INTO roles (nombre_rol, descripcion, usuario_registro) VALUES 
('ADMINISTRADOR', 'Acceso total al sistema', 'SISTEMA'),
('OPERADOR_LOCAL', 'Registro de datos para distritos', 'SISTEMA');

INSERT INTO mant_unidad_funcional (nombre, descripcion, estado, usuario_registro) VALUES 
('PRIMERA INFANCIA', 'Atención integral a niños y niñas de 0 a 5 años (Salud, Nutrición y Educación Inicial).', 'ACTIVADO', 'ADMIN_SISTEMA'),
('NIÑEZ, ADOLESCENCIA Y MUJER', 'Protección de derechos, prevención de violencia y desarrollo integral de NNA y mujeres.', 'ACTIVADO', 'ADMIN_SISTEMA'),
('JUVENTUDES', 'Indicadores de educación superior, empleo joven y participación ciudadana.', 'ACTIVADO', 'ADMIN_SISTEMA'),
('PERSONA CON DISCAPACIDAD', 'Inclusión social, accesibilidad, certificaciones y oportunidades laborales para OMAPED.', 'ACTIVADO', 'ADMIN_SISTEMA'),
('ADULTO MAYOR', 'Atención en salud, programas sociales (Pensión 65) y espacios de recreación (CIAM).', 'ACTIVADO', 'ADMIN_SISTEMA'),
('PUEBLOS ORIGINARIOS', 'Preservación cultural, acceso a servicios básicos y derechos de comunidades indígenas/nativas.', 'ACTIVADO', 'ADMIN_SISTEMA');

-- Unificamos las inserciones de categorías
INSERT INTO mant_categorias (id_categoria, nombre, descripcion, usuario_registro) VALUES 
(1, 'Salud', 'Categoría de salud y nutrición', 'SISTEMA'),
(2, 'Protección', 'Categoría de protección y derechos', 'SISTEMA'),
(3, 'Participación', 'Participación comunitaria y social', 'SISTEMA'),
(4, 'Comunicación verbal afectiva', 'Desarrollo comunicativo', 'SISTEMA'),
(5, 'Identidad', 'Derecho al nombre y nacionalidad', 'SISTEMA'),
(6, 'Vivienda y Entorno', 'Condiciones de habitabilidad', 'SISTEMA'),
(7, 'Camina solo', 'Desarrollo psicomotor', 'SISTEMA'),
(8, 'Regula emociones y comportamientos', 'Desarrollo emocional', 'SISTEMA'),
(9, 'Adecuado estado nutricional', 'Nutrición infantil', 'SISTEMA'),
(10, 'Educación', 'Categoría de educación y aprendizaje', 'SISTEMA')
ON CONFLICT (id_categoria) DO UPDATE SET 
    nombre = EXCLUDED.nombre, 
    descripcion = EXCLUDED.descripcion;

-- Insertamos un dato temporal por defecto para evitar error de FK en indicadores
INSERT INTO mant_temporalidad (id_temporalidad, nombre, cantidad_dias, descripcion, usuario_registro) 
VALUES (1, 'ANUAL', 365, 'Medición anual', 'SISTEMA');

-- Inserción de Indicadores (Asumiendo id_unidad_funcional = 1 e id_temporalidad = 1 por defecto para que funcione el insert)
INSERT INTO mant_indicadores (id_indicador, id_unidad_funcional, id_categoria, id_temporalidad, nombre_indicador, usuario_registro) VALUES 
-- Salud
(1, 1, 1, 1, 'Porcentaje de desnutrición crónica en niños menores de 5 años.', 'SISTEMA'),
(2, 1, 1, 1, 'Porcentaje de anemia en niños(as) menores de 36 meses.', 'SISTEMA'),
(3, 1, 1, 1, 'Porcentaje que acceden al paquete integrado de servicios de salud los niños (as) menores de 5 años.', 'SISTEMA'),
-- Protección
(4, 1, 2, 1, 'Porcentajes de tipos de familias que tienen los niños menores de 5 años de la localidad', 'SISTEMA'),
(5, 1, 2, 1, 'Porcentaje de niños menores de 5 años en riesgo de desprotección familiar atendidos en la DEMUNA', 'SISTEMA'),
(6, 1, 2, 1, 'Porcentaje de niños registrados en alguna UPE (Unidad de Protección Especial) o fiscalía de familia en niños menores de 05 años.', 'SISTEMA'),
(7, 1, 2, 1, 'Número de casos de denuncias por violencia sexual a niños (as) menores de 5 años', 'SISTEMA'),
(8, 1, 2, 1, 'Número de casos de niños menores de 5 años desprotegidos integrados a alguna familia (de origen, ampliada o terceros)', 'SISTEMA'),
(9, 1, 2, 1, 'Número de denuncias de desaparición de niños menores de 5 años registrados por la PNP', 'SISTEMA'),
-- Participación
(10, 1, 3, 1, 'Número de Consejo Provincial de salud (CPS) o Comité Distrital de Salud (CDS) con plan de trabajo aprobado por el gobierno local', 'SISTEMA'),
(11, 1, 3, 1, 'Número de instituciones públicas o privadas que trabajan a favor de la primera infancia.', 'SISTEMA'),
(12, 1, 3, 1, 'Número de instituciones de salud del primer nivel con certificación “Establecimientos de Salud Amigos de la Madre, la Niña y el Niño”', 'SISTEMA'),
(13, 1, 3, 1, 'Porcentaje de ejecusion presupuestal del PIM a nivel de devengado en las actividades del Producto 3033251: Familias Saludables', 'SISTEMA'),
(14, 1, 3, 1, 'Porcentaje de ejecución presupuestal del PIM a nivel de devengado en las actividades comprometidas en el producto 3033412', 'SISTEMA'),
(15, 1, 3, 1, 'Número de Centros de Promoción y Vigilancia Comunal - CPVC funcionamiento en la localidad', 'SISTEMA'),
(16, 1, 3, 1, 'Tipo de Servicios brindado por el Programa Nacional de Cuna Más funcionando en la localidad', 'SISTEMA'),
-- Comunicación verbal afectiva
(17, 1, 4, 1, 'Porcentaje de madres de niñas y niños entre 9 y 18 meses de edad que verbaliza las acciones que realiza con su hija/o mientras desarrolla.', 'SISTEMA'),
(18, 1, 4, 1, 'Porcentaje de niñas y niños entre 19 y 36 meses de edad que participa de forma frecuente en conversaciones con adultos', 'SISTEMA'),
-- Identidad
(19, 1, 5, 1, 'Porcentaje de niños menores de 30 días de nacidos que cuentan con el certificado de nacido vivo (CNV)', 'SISTEMA'),
(20, 1, 5, 1, 'Porcentaje de niños menores de 5 años que cuentan con DNI', 'SISTEMA'),
(21, 1, 5, 1, 'Porcentaje de niños menores de 5 años que cuentan con acta de nacimiento emitido por la OREC o RENIEC', 'SISTEMA'),
-- Vivienda y Entorno
(22, 1, 6, 1, 'Porcentaje de niños menores de 5 años que consumen agua con presencia de cloro residual libre (>0.5 mg/l)', 'SISTEMA'),
(23, 1, 6, 1, 'Porcentaje de niños menores de 5 años que viven en hogares con acceso a servicios básicos (agua potable, alcantarillado y electricidad)', 'SISTEMA'),
(24, 1, 6, 1, 'Porcentaje de niños menores de 5 años que realizan la disposición adecuada de residuos sólidos', 'SISTEMA'),
(25, 1, 6, 1, 'Porcentaje de niños menores de 5 años que habitan en viviendas con materiales adecuados en pisos y paredes', 'SISTEMA'),
-- Camina solo
(26, 1, 7, 1, 'Porcentaje de niñas y niños entre 12 y 18 meses que caminan por propia iniciativa sin necesidad de detenerse para lograr el equilibrio (marcha estable y autonoma)', 'SISTEMA'),
(27, 1, 7, 1, 'Porcentaje de niñas y niños de 9 a 12 meses de edad que tiene, en el hogar, un espacio físico para desplazarse/caminar libremente (entorno)', 'SISTEMA'),
(28, 1, 7, 1, 'Número de espacios públicos saludables de juego para niñas y niños menores de 5 años en buen estado y funcionamiento', 'SISTEMA'),
-- Regula emociones y comportamientos
(29, 1, 8, 1, 'Porcentaje de niñas y niños de 24 a 71 meses que regula sus emociones y comportamientos en situación de frustración y establecimiento de límites.', 'SISTEMA'),
-- Adecuado estado nutricional
(30, 1, 9, 1, 'Porcentaje de desnutrición crónica en niños menores de 5 años', 'SISTEMA'),
(31, 1, 9, 1, 'Porcentaje de anemia en niños(as) menores de 36 meses', 'SISTEMA'),
(32, 1, 9, 1, 'Porcentaje de niños(as) menores de 5 años que acceden al paquete integrado de servicios de salud.', 'SISTEMA'),
-- Educación
(33, 1, 10, 1, 'Porcentaje de niños y niñas de 3 a 5 años que asisten a instituciones educativas de nivel inicial o programas no escolarizados.', 'SISTEMA'),
(34, 1, 10, 1, 'Porcentaje de instituciones educativas de nivel inicial que cuentan con condiciones básicas de infraestructura y mobiliario adecuado.', 'SISTEMA')
ON CONFLICT (id_indicador) DO UPDATE SET 
    id_categoria = EXCLUDED.id_categoria, 
    nombre_indicador = EXCLUDED.nombre_indicador;