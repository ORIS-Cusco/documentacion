# Arquitectura de Tecnología de Información v1.0

## Proyecto: Observatorio Regional de Inclusión Social – GRC
**Siglas:** ORIS
**Código:** PROYECTO-ORIS-2026-v1
**Versión:** 1.0
**GERENCIA REGIONAL DE DESARROLLO SOCIAL**

---

## Identificación del documento
| Rol | Nombre | Cargo | Fecha | Firma |
| :--- | :--- | :--- | :--- | :--- |
| Elaboración | [Nombre del Analista/Arquitecto] | Arquitecto de Software / Analista | [Fecha] | |
| Revisión | [Nombre del Revisor] | Especialista en TI | [Fecha] | |
| Aprobación | [Nombre del Aprobador] | Gerente de Proyecto | [Fecha] | |

## Historial de cambios
| Versión | Ítem | Autor | Descripción | Fecha |
| :--- | :--- | :--- | :--- | :--- |
| 1.0 | 1 | [Autor] | Versión Inicial | [Fecha] |

---

## Contenido
1. INTRODUCCIÓN
   1.1. Propósito
   1.2. Alcance
2. Definiciones y abreviaturas
   2.1. Definiciones
   2.2. Abreviaturas
3. Referencias
4. ARQUITECTURA DE TI
   4.1. Diagrama de Arquitectura física
   4.2. Sistemas y servicios asociados
5. Dimensionamiento de Hardware y Software Base
   5.1. Hardware
   5.2. Software
6. LICENCIAMIENTO

---

## 1. INTRODUCCIÓN
El presente documento ayuda a describir las necesidades de recursos de hardware y software del Sistema "Observatorio Regional de Inclusión Social – GRC" (ORIS).

### 1.1. Propósito
El objetivo es brindar información necesaria sobre los recursos de infraestructura tecnológica que se requiere para el despliegue y funcionamiento óptimo del Observatorio Regional de Inclusión Social, asegurando escalabilidad, mantenibilidad y flexibilidad tecnológica basado en microservicios.

### 1.2. Alcance
Descripción de recursos de hardware y software del proyecto Sistema del Observatorio Regional de Inclusión Social.

## 2. Definiciones y abreviaturas
Se definen los siguientes términos para mejor interpretación del contenido de este documento.

### 2.1. Definiciones
- **Gobierno Regional (GRC):** Entidad encargada de la administración regional.
- **Sistema de Observatorio:** Es el sistema centralizado para el registro, análisis y reporte de información sobre inclusión social y cierre de brechas en la región, compuesto por microservicios desacoplados y una aplicación web interactiva.
- **Microservicio:** Enfoque arquitectónico donde una gran aplicación se compone de pequeños servicios independientes que se comunican entre sí.

### 2.2. Abreviaturas
- **GRC:** Gobierno Regional.
- **HTTP/HTTPS:** Protocolo de comunicaciones (cifrado para HTTPS).
- **LAN/WAN:** Red de área local / Red de área amplia.
- **VPN:** Red Privada Virtual.
- **DMZ:** Zona desmilitarizada.
- **API REST:** Interfaz de programación de aplicaciones basada en el estilo arquitectónico REST.
- **JWT:** JSON Web Token (estándar de seguridad para tokens).
- **SPA:** Single Page Application (Aplicación de página única).
- **CI/CD:** Integración Continua / Despliegue Continuo.
- **K8s:** Kubernetes (orquestador de contenedores).

## 3. Referencias
Para la elaboración del presente documento se ha tomado como referencia los lineamientos técnicos del proyecto:
- Arquitectura del Sistema (ARQUITECTURA_SISTEMA.md)
- Términos de Referencia (TDR / TDR.docx) del Observatorio Regional de Inclusión Social.

## 4. ARQUITECTURA DE TI

### 4.1. Diagrama de Arquitectura física
**Descripción:**
- **Capa Frontera (DMZ):** Un balanceador de carga (Nginx u otro Load Balancer) enruta el tráfico web HTTPS seguro externo hacia la aplicación web (Frontend), protegiendo la red interna.
- **Capa Web (Frontend):** La aplicación cliente tipo SPA (construida en Angular) se aloja y distribuye mediante un servidor web ligero o contenedor.
- **Capa de Aplicación (Backend):** Los microservicios de negocio (Auth Service, Core Service, Report Service, Admin Service desarrollados en Spring Boot) se ejecutan dentro y se administran en un clúster de contenedores (Docker / Kubernetes o Docker Swarm) ubicados en el servidor de aplicaciones, expuestos de manera segura mediante un API Gateway.
- **Capa de Datos:** La base de datos relacional (PostgreSQL) y la base opcional NoSQL (MongoDB) se alojan en un servidor de base de datos dedicado con discos de alta velocidad (Alta IOPS).

### 4.2. Sistemas y servicios asociados
El sistema y sus servicios están orientados a ser distribuidos, garantizando alta disponibilidad, fácil escalamiento horizontal y bajo acoplamiento arquitecturizado mediante microservicios independientes.

## 5. Dimensionamiento de Hardware y Software Base

### 5.1. Hardware

**SERVIDOR DE APLICACIONES (CONTENEDORES Y WEB SER-Web)**
| Característica | Descripción |
| :--- | :--- |
| **Sistema Operativo** | Linux (Ubuntu Server 22.04 LTS o superior / CentOS) |
| **Tipo** | Máquina Virtual o Servidor Físico |
| **Procesador Mínimo** | Intel(R) CPU 4 vCPU (2.7 GHz o superior) |
| **Arquitectura** | x64 |
| **Memoria Mínima** | 16 GB RAM |
| **Capacidad Disco** | 100 GB SSD (Para el Sistema Operativo y Volúmenes de Contenedores) |
| **Software Necesario** | Docker Engine, Docker Compose / Kubernetes, Nginx (Balanceador/Proxy Inverso), Java JRE 17/21 |
| **Puertos de Comunicación** | 80/443 (HTTP/HTTPS) |

**ALMACENAMIENTO (APLICACIONES Y ARCHIVOS SER-Archivos)**
| Característica | Descripción |
| :--- | :--- |
| **Almacenamiento Requerido** | Volumen de almacenamiento necesario para contener los binarios construidos, contenedores en ejecución, subidas directas del usuario y archivos generados del sistema temporalmente (PDFs de reportes, Exceles, entre otros). Backup en infraestructura transversal de la nube o discos replicados. |

**SERVIDOR DE BASE DE DATOS (SER-BD)**
| Característica | Descripción |
| :--- | :--- |
| **Sistema Operativo** | Linux (Ubuntu Server 22.04 LTS o superior / CentOS) |
| **Tipo** | Máquina Virtual o Servidor Físico Dedicado |
| **Procesador Mínimo** | Intel(R) CPU 4 vCPU (2.7 GHz o superior) |
| **Arquitectura** | x64 |
| **Memoria Mínima** | 16 GB RAM |
| **Capacidad Disco** | 200 GB SSD (Alta IOPS).<br><br>Distribución Inicial:<br>- *Disco 0:* 50 GB (SO y utilidades del Motor DB)<br>- *Disco 1:* 100 GB (Data SQL / PostgreSQL)<br>- *Disco 2:* 50 GB (Data NoSQL / MongoDB y Logs/Backups locales temporales) |
| **Software Necesario** | PostgreSQL 15+, MongoDB (Opcional) |

**SERVIDOR DE RESPALDO / CI-CD / CLÚSTER (SER-Infra/DevOps)**
| Característica | Descripción |
| :--- | :--- |
| **Sistema Operativo** | Linux (Ubuntu Server) |
| **Tipo** | Máquina Virtual |
| **Memoria Mínima** | 8 GB RAM |
| **Capacidad Disco** | 200 GB |
| **Requerimiento** | Para gestión de repositorios en GitLab CI, herramientas de monitorización (Prometheus, Grafana), y almacenamiento de copias de seguridad de las DB. |

### 5.2. Software

**BASE DE DATOS**
| Característica | Descripción |
| :--- | :--- |
| **Motor de Base de datos (Relacional)** | PostgreSQL 15 o superior |
| **Motor de Base de datos (NoSQL)** | MongoDB (Opcional) |
| **Conexiones Diarias** | Múltiples conexiones por los pool de cada Microservicio. |

**APLICACIONES Y APIS**
| Característica | Descripción |
| :--- | :--- |
| **Aplicación Cliente (Frontend)** | Angular 17, HTML/SCSS, Node.js (Entorno local) |
| **Plataforma Backend & APIs** | Spring Boot 3.4 (Java 17/21) para Auth/Core/Report Services |
| **Generación de Archivos (Reportes)** | Jasper Reports, Apache POI |
| **Proxy de Seguridad** | Seguridad API basada en tokens - Spring Security + JWT |

**INFRAESTRUCTURA Y SERVIDOR WEB**
| Característica | Descripción |
| :--- | :--- |
| **Servidor Web y Balanceador** | Nginx |
| **Orquestación de Contenedores** | Docker Engine, Kubernetes (K8s) o Docker Swarm |

**MONITOREO**
| Característica | Descripción |
| :--- | :--- |
| **Herramientas de Diagnóstico** | Prometheus, Grafana |

## 6. LICENCIAMIENTO
El modelo conceptualizado para el Observatorio está fuertemente dirigido al uso de tecnologías "Open Source", de código abierto y herramientas libres, lo que permite minimizar sustancialmente los costos por licencias privativas.

| Componente | Tipo de Licencia / Descripción |
| :--- | :--- |
| **Sistema Operativo (Linux)** | Open Source (Integración GPL, BSDL o licenciamiento Ubuntu Canonical) - Sin costo de licencia para software base. |
| **Base de Datos (PostgreSQL)** | Open Source (PostgreSQL License) - Sin costo de licencia en la edición comunitaria libre. |
| **Base de Datos (MongoDB)** | Open Source (Server Side Public License - SSPL) - Sin costo de licencia para su variante comunitaria. |
| **Lenguaje de Programación y Frameworks (Java, Spring, Angular)** | Open Source - Sin costo asociados. |
| **Plataforma de Contenedores (Docker / K8s)** | Open Source (Apache 2.0 y similares) - Uso libre en ediciones comunitarias. |
| **Servidor Web (Nginx)** | Open Source (BSDL) - Sin costo asociado para versión general. |

*Nota Final: Las futuras adquisiciones de licencias comerciales se darán únicamente si la institución solicitase expresamente soporte empresarial directo de la marca (ej. RedHat Enterprise Support, MongoDB Enterprise Support) o para la expedición de Certificados SSL Comerciales para garantizar cifrado HTTPS en el dominio público de producción.*
