# Arquitectura del Sistema: Observatorio Regional de Inclusión Social

## 1. Visión General de la Arquitectura
El sistema se construirá bajo una arquitectura de **Microservicios** (o servicios modulares) contenerizados, desacoplando el Frontend del Backend para asegurar escalabilidad, mantenibilidad y flexibilidad tecnológica.

### Diagrama de Alto Nivel

```mermaid
graph TD
    UserInterno[Funcionarios GRC] -->|HTTPS| LoadBalancer[Nginx / Load Balancer]
    UserExterno[Gobiernos Locales] -->|HTTPS| LoadBalancer
    Publico[Público General] -->|HTTPS| LoadBalancer

    subgraph "Capa Frontera (DMZ)"
        LoadBalancer -->|Enruta| Frontend[App Web SPA\n(Angular + PrimeNG)]
    end

    subgraph "Capa de Aplicación (Cluster Docker/K8s)"
        Frontend -->|API REST / JSON| Gateway[API Gateway\n(Spring Cloud Gateway)]
        
        Gateway --> Auth[Servicio de Autenticación\n(JWT / OAuth2)]
        Gateway --> Core[Servicio Core / Unidades\n(Lógica de Negocio)]
        Gateway --> Report[Servicio de Reportes\n(Jasper Reports / ETL)]
        Gateway --> Admin[Servicio Admin\n(Gestión Usuarios/Conf)]
    end

    subgraph "Capa de Datos"
        Auth --> DB_Auth[(BD Seguridad\nPostgreSQL)]
        Core --> DB_Core[(BD Observatorio\nPostgreSQL/MongoDB)]
        Report --> DB_Core
        Admin --> DB_Auth
    end

    subgraph "Infraestructura Transversal"
        CI_CD[GitLab CI/CD] -->|Despliegue| Frontend
        CI_CD -->|Despliegue| Gateway
        CI_CD -->|Despliegue| Core
        Monitoring[Prometheus + Grafana] -.->|Monitorea| Gateway
    end
```

## 2. Stack Tecnológico

### 2.1 Backend
- **Lenguaje:** Java 17 / 21
- **Framework:** Spring Boot 3.4
- **Seguridad:** Spring Security + JWT (JSON Web Tokens)
- **Documentación API:** OpenAPI 3.0 (Swagger)
- **Construcción:** Maven / Gradle

### 2.2 Frontend
- **Framework:** Angular 17
- **Estilos:** Bootstrap 5 + SCSS
- **Componentes UI:** PrimeNG (Grillas, Modales, Gráficos)
- **Gráficos:** Chart.js / NGX-Charts (Para Dashboard)

### 2.3 Base de Datos
- **Relacional (Principal):** PostgreSQL 15+ (Datos estructurados, usuarios, catálogos)
- **NoSQL (Opcional):** MongoDB (Para almacenamiento de formularios dinámicos o datos semi-estructurados de encuestas)

### 2.4 Infraestructura y DevOps
- **Contenedores:** Docker
- **Orquestación:** Kubernetes (K8s) o Docker Swarm (según recursos disponibles)
- **Repositorio:** GitLab
- **CI/CD:** GitLab CI / Jenkins

## 3. Descripción de Módulos / Microservicios

1.  **Auth Service:**
    *   gestiona el login, recuperación de contraseñas y emisión de tokens JWT.
    *   Valida roles (Admin, Gobierno Local, Unidad Funcional).

2.  **Core Service:**
    *   Contiene la lógica de negocio principal para las 06 unidades funcionales.
    *   Gestiona los formularios de registro de beneficiarios y actividades.
    *   Valida reglas de negocio (ej. duplicidad de DNI).

3.  **Reporting Service:**
    *   Dedicado a la generación de reportes pesados (PDF, Excel).
    *   Procesa datos para el Dashboard de indicadores en tiempo real.

## 4. Estrategia de Seguridad

*   **En Tránsito:** Todo el tráfico viaja cifrado bajo HTTPS (TLS 1.2/1.3).
*   **Autenticación:** Tokens JWT con tiempo de expiración corto (AccessToken) y RefreshTokens.
*   **Protección de Datos:** Cifrado de contraseñas con BCrypt. Datos sensibles personales tratados según Ley 29733.
*   **Auditoría:** Registro (logs) de todas las acciones de escritura/edición (Quién, Qué, Cuándo).

## 5. Estrategia de Despliegue

Se utilizarán ambientes aislados:
1.  **Desarrollo:** Integración continua, despliegue automático al hacer *push* a la rama `develop`.
2.  **QA / Testing:** Ambiente estable para validación de usuarios; despliegue manual o aprobado desde `release`.
3.  **Producción:** Ambiente optimizado y seguro; despliegue desde `main` con etiquetas (tags).

## 6. Requerimientos de Infraestructura (Estimado)

*   **Servidor de Aplicaciones:** 16GB RAM, 4 vCPU, 100GB SSD.
*   **Servidor de Base de Datos:** 16GB RAM, 4 vCPU, 200GB SSD (Alta IOPS).
*   **Almacenamiento:** Backup diario automatizado (Local + Nube/Externo).
