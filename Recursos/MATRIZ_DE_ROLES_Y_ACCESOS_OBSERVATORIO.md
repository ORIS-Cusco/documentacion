# Matriz de Roles y Accesos - Observatorio Regional de Inclusión Social (ORIS)

Este documento define la matriz de perfiles, roles y permisos de acceso para los diferentes paquetes y módulos del sistema "Observatorio", basado en el modelo de base de datos actual. 

## 1. Definición de Roles del Sistema

En base a la arquitectura y casos de uso del Observatorio, se identifican los siguientes roles clave:

1. **Administrador del Sistema (ADM)**: Tiene control total sobre la plataforma, incluyendo la gestión de usuarios, roles, catálogos del sistema de mantenimiento, configuración de indicadores y reportes.
2. **Coordinador Regional / Validador (VAL)**: Encargado de revisar, validar u observar (aprobar/rechazar) la información de indicadores y reportes registrada por las entidades locales.
3. **Funcionario Local / Registrador (REG)**: Usuario responsable del ingreso de datos, registros de los indicadores correspondientes a su sector/gobierno local y la subida de evidencia.
4. **Especialista Temático (ESP)**: Usuario de área usuaria o especialista que configura metas e indicadores, pero no administra el sistema completo.
5. **Consulta / Público General (CON)**: Rol restringido (puede o no requerir inicio de sesión) con acceso únicamente a la visualización de tableros, informes y descarga de reportes públicos.

## 2. Leyenda de Permisos (Acciones)

- **A** = Acceso (Puede visualizar y acceder al menú/módulo correspondiente)
- **L** = Lectura / Consultar (Puede ver la lista y el detalle de los registros)
- **C** = Crear / Registrar (Puede insertar nuevos registros)
- **M** = Modificar / Editar (Puede actualizar información o inactivar/activar)
- **E** = Eliminar (Puede hacer borrado lógico o físico si el sistema lo permite)
- **V** = Validar / Observar (Puede cambiar el estado de validación en el flujo de control)
- **EX** = Exportar (Puede descargar la data a Excel, PDF, CSV, etc.)

*(Nota: En la tabla se usan combinaciones. Ej: `A,L,C,M,E` significa Acceso, Lectura, Creación, Modificación y Eliminación)*

## 3. Matriz de Roles, Accesos y Casos de Uso

| Paquete | Menú | Submenú | Cód. Menú | URL | ADM | VAL | REG | ESP | CON | Código CUS | Descripción del Caso de Uso |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **PAQ-01** | **Seguridad** | | 1000 | `/seguridad` | A | | | | | CUS-01-01 | Acceso principal a la sección de configuración de seguridad. |
| | | Roles | 1100 | `/seguridad/roles` | A,L,C,M | | | | | CUS-01-02 | Gestión de perfiles y permisos de acceso al sistema. |
| | | Usuarios | 1200 | `/seguridad/usuarios` | A,L,C,M,E | | | | | CUS-01-03 | Administración de cuentas de usuario, asignación de roles y sectores. |
| **PAQ-02** | **Mantenimiento** | | 2000 | `/mant` | A | | | A | | CUS-02-01 | Acceso a mantenedores y catálogos base del sistema. |
| | | Unidades Funcionales | 2100 | `/mant/unidades` | A,L,C,M,E | | | A,L | | CUS-02-02 | Gestión de las unidades funcionales del gobierno regional. |
| | | Categorías | 2200 | `/mant/categorias` | A,L,C,M,E | | | A,L | | CUS-02-03 | Gestión de las categorías asociadas a los indicadores. |
| | | Temporalidad | 2300 | `/mant/temporalidad` | A,L,C,M,E | | | A,L | | CUS-02-04 | Configuración de los rangos de periodicidad de medición (mensual, anual). |
| | | Niveles de Disgregación | 2400 | `/mant/niveles` | A,L,C,M,E | | | A,L | | CUS-02-05 | Definición de niveles de disgregación de información (Ej. Sexo, Zona). |
| | | Ítems de Disgregación | 2500 | `/mant/items` | A,L,C,M,E | | | A,L,C,M | | CUS-02-06 | Creación de ítems para cada nivel de disgregación configurado. |
| **PAQ-03** | **Gestión de Indicadores** | | 3000 | `/indicadores` | A | A | | A | | CUS-03-01 | Administrador de los métricos e indicadores a monitorear. |
| | | Configuración Inicial | 3100 | `/indicadores/config` | A,L,C,M,E | A,L | L | A,L,C,M | | CUS-03-02 | Parametrización de indicadores, metadatos y orígenes de datos. |
| | | Relación de Disgregación | 3200 | `/indicadores/relacion`| A,L,C,M,E | A,L | | A,L,C,M | | CUS-03-03 | Vinculación del indicador con los niveles de apertura de datos requeridos. |
| **PAQ-04** | **Datos y Registro** | | 4000 | `/datos` | A | A | A | A | | CUS-04-01 | Módulo de interacción con la carga y revisión de la data estadística. |
| | | Ingreso de Datos (Hechos)| 4100 | `/datos/registro` | A,L,M,E | A,L,EX| A,L,C,M | A,L | | CUS-04-02 | Registro de variables en `data_indicadores` por periodo y carga de evidencia. |
| | | Control y Validación | 4200 | `/datos/validacion` | A,L,V,EX| A,L,V,EX| A,L | A,L,V,EX| | CUS-04-03 | Flujo de revisión de datos donde se asigna estado (Validado/Observado). |
| **PAQ-05** | **Observatorio Público** | | 5000 | `/observatorio` | A | A | A | A | A | CUS-05-01 | Portal de información abierta a consulta externa e interna. |
| | | Tableros Dinámicos | 5100 | `/observatorio/dashboard`| A,L,EX | A,L,EX| A,L,EX | A,L,EX | A,L | CUS-05-02 | Visualización gráfica de los indicadores y porcentaje de avances. |
| | | Reportes / Descargas | 5200 | `/observatorio/reportes` | A,L,EX | A,L,EX| A,L,EX | A,L,EX | A,L,EX| CUS-05-03 | Generador y exportador de información y fichas técnicas consolidadas. |
