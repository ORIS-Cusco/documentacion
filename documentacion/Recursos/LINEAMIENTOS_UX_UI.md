# Lineamientos de UX/UI: Observatorio Regional de Inclusión Social

## 1. Identidad Visual

### 1.1 Paleta de Colores
Se adoptará la identidad visual definida en el prototipo, con un predominio del color **Guinda / Borgoña** institucional.

| Color | Hex (Aprox) | Uso |
| :--- | :--- | :--- |
| **Brand Burgundy (Guinda)** | `#8B1E3F` | **Sidebar (Menú Lateral)**, Botones principales ("Siguiente", "Acceder"), Iconos activos. |
| **Accent Orange** | `#F4A261` | Gráficos (Líneas de tendencia), Alertas, Elementos destacados. |
| **Accent Yellow** | `#E9C46A` | Gráficos (Comparativas), Indicadores secundarios. |
| **Text Dark** | `#333333` | Títulos principales, Texto general. |
| **Text Grey** | `#6C757D` | Subtítulos, migas de pan (breadcrumbs), iconos inactivos. |
| **Background Light** | `#F4F6F9` | Fondo general del área de contenido (gris muy suave / blanco). |
| **White** | `#FFFFFF` | Fondo de Tarjetas (Cards) y contenedores. |

### 1.2 Tipografía
Tipografía Sans-Serif moderna y limpia (ej. **Poppins**, **Montserrat** o **Roboto**).

*   **Títulos Grandes (Páginas):** Bold, color Guinda o Gris Oscuro.
*   **Etiquetas de Menú:** Medium, color Blanco (sobre fondo Guinda).
*   **Números (Indicadores):** Bold / ExtraBold, tamaño grande para KPIs.

## 2. Estructura del Layout (Diseño)

### 2.1 Sidebar (Menú Lateral)
*   **Fondo:** Color Sólido **Guinda (`#8B1E3F`)**.
*   **Logo/Header:** "Página Principal" con icono de casa en contenedor redondeado blanco/claro.
*   **Items de Menú:** Iconos a la izquierda, texto a la derecha. Color blanco.
    *   *Primera Infancia*
    *   *Niño, Niña*
    *   *Juventud*
    *   *Mujer*
    *   *Adulto Mayor*
    *   *Discapacidad*
    *   *Pueblos Originarios*
*   **Footer del Sidebar:**
    *   *Reportes*
    *   *Configuración*
    *   *Cerrar Sesión* (con icono de salida).

### 2.2 Topbar (Cabecera)
*   **Fondo:** Blanco (`#FFFFFF`).
*   **Izquierda:** Breadcrumbs (Ruta): "Pages / Página Principal".
*   **Centro:** Título de la Entidad: "GOBIERNO LOCAL - DISTRITO [NOMBRE]".
*   **Derecha:**
    *   Perfil de Usuario: Nombre (Negrita) + Rol (Texto pequeño color rojo/guinda).
    *   Botón de texto "Cerrar Sesión".
    *   Icono de Notificación (Campana) con badge verde.
*   **Navegación Secundaria:** Botones "Regresar" (Guinda), Icono Home, "Siguiente" (Guinda).

### 2.3 Dashboard Principal (Estructura)
El dashboard se divide en secciones horizontales claras:

1.  **Fila Superior (Accesos Directos):**
    *   Título grande "INDICADORES" a la izquierda.
    *   Fila de **Tarjetas (Cards)** rectangulares blancas con sombra suave.
    *   Cada tarjeta representa una Unidad Funcional (Icono Gris + Nombre).
    *   Botón inferior en cada tarjeta: "Acceder >" (Gris/Guinda).

2.  **Sección Central (Gráficos y Calendario):**
    *   **Izquierda (Gráfico):** "Indicadores Generales". Gráfico de líneas curvas (Spline Chart) mostrando tendencias mensuales. Colores: Gradientes Naranja/Amarillo.
    *   **Derecha (Calendario/Actividades):** Calendario mensual pequeño y lista de actividades.

3.  **Fila Inferior (KPIs / Totales):**
    *   Barra blanca inferior con resumen estadístico.
    *   Formato: Icono representativo + Título pequeño + **Número Grande** (Negrita/Azul oscuro).
    *   Ejemplo: *Niños 932*, *Adolescentes 754*, *Mujeres 32k*.

## 3. Componentes de Interfaz

### 3.1 Botones
*   **Estilo "Pill" (Pastilla):** Bordes totalmente redondeados (radius 50px).
*   **Colores:** Fondo Guinda para acciones primarias.

### 3.2 Tarjetas (Cards)
*   Fondo blanco, borde muy sutil o sin borde, sombra difuminada (`box-shadow`).
*   Diseño minimalista: Icono centrado, texto debajo, botón de acción al pie.

### 3.3 Gráficos
*   Estilo limpio, sin cuadrículas pesadas.
*   Uso de áreas con gradiente (fill) debajo de las líneas para dar volumen.

## 4. Accesibilidad y Responsividad
*   Contraste alto entre el texto blanco y el fondo guinda del sidebar.
*   En móviles, el sidebar se oculta (Off-canvas) y los KPIs inferiores se apilan verticalmente.
