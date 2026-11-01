
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Collections"%>

<%!
    private String escaparReporte(Object valor) {
        if (valor == null) return "";

        return String.valueOf(valor)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private int porcentaje(int cantidad, int maximo) {
        if (maximo <= 0) return 0;
        return (int) Math.round((cantidad * 100.0) / maximo);
    }
%>

<%
    // CONTROL DE SESIÓN
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String nombreSesion = (String) session.getAttribute("nombre");
    String rolSesion = (String) session.getAttribute("rol");

    if (nombreSesion == null || nombreSesion.trim().isEmpty()) {
        nombreSesion = "Usuario";
    }

    if (rolSesion == null) {
        rolSesion = "USUARIO";
    }

    boolean esAdmin = "ADMINISTRADOR".equalsIgnoreCase(rolSesion);

    String inicial = nombreSesion.trim().substring(0, 1).toUpperCase();

    // INFORMACIÓN DE LOS REPORTES
    Map<String, Integer> indicadores =
            (Map<String, Integer>) request.getAttribute("indicadores");

    Map<String, Integer> porArea =
            (Map<String, Integer>) request.getAttribute("porArea");

    Map<String, Integer> porPrograma =
            (Map<String, Integer>) request.getAttribute("porPrograma");

    Map<String, Integer> porAsignatura =
            (Map<String, Integer>) request.getAttribute("porAsignatura");

    if (indicadores == null) indicadores = Collections.emptyMap();
    if (porArea == null) porArea = Collections.emptyMap();
    if (porPrograma == null) porPrograma = Collections.emptyMap();
    if (porAsignatura == null) porAsignatura = Collections.emptyMap();

    int total = indicadores.getOrDefault("total", 0);
    int areas = indicadores.getOrDefault("areas", 0);
    int programas = indicadores.getOrDefault("programas", 0);

    int maxArea = porArea.values().stream()
            .mapToInt(Integer::intValue).max().orElse(0);

    int maxPrograma = porPrograma.values().stream()
            .mapToInt(Integer::intValue).max().orElse(0);

    int maxAsignatura = porAsignatura.values().stream()
            .mapToInt(Integer::intValue).max().orElse(0);

    String filtroPrograma = (String) request.getAttribute("filtroPrograma");
    String filtroArea = (String) request.getAttribute("filtroArea");
    String fechaInicial = (String) request.getAttribute("filtroFechaInicial");
    String fechaFinal = (String) request.getAttribute("filtroFechaFinal");

    String error = (String) request.getAttribute("error");

    boolean generado = request.getAttribute("porArea") != null;
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Statistics System | Reportes</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

    <!-- MENÚ LATERAL -->
    <aside class="sidebar">

        <div class="logo">
            <div class="logo-icon">
                <img src="${pageContext.request.contextPath}/img/logo.png"
                     alt="Statistics System">
            </div>

            <div>
                <h2>Statistics</h2>
                <span>SYSTEM</span>
            </div>
        </div>

        <div class="menu-titulo">MENÚ PRINCIPAL</div>

        <nav class="navegacion">

            <a href="${pageContext.request.contextPath}/index.jsp"
               class="nav-link">
                <span>▦</span> Panel principal
            </a>

            <a href="${pageContext.request.contextPath}/registro.jsp"
               class="nav-link">
                <span>＋</span> Registrar uso
            </a>

            <a href="${pageContext.request.contextPath}/RegistroServlet"
               class="nav-link">
                <span>▤</span> Consultar registros
            </a>

            <a href="${pageContext.request.contextPath}/ReporteServlet"
               class="nav-link activo">
                <span>▥</span> Reportes
            </a>

            <% if (esAdmin) { %>
                <a href="${pageContext.request.contextPath}/configuracion.jsp"
                   class="nav-link">
                    <span>⚙</span> Configuración
                </a>
            <% } %>

        </nav>

        <div class="sidebar-footer">
            <span class="estado"></span>
            Sistema de gestión
            <small>Versión 1.0</small>
        </div>

    </aside>

    <!-- CONTENIDO PRINCIPAL -->
    <main class="contenido">

        <header class="topbar">

            <div>
                <h1>Reportes y estadísticas</h1>
                <p>Análisis de utilización de laboratorios clínicos</p>
            </div>

            <div class="usuario">
                <div class="avatar">
                    <%= escaparReporte(inicial) %>
                </div>

                <div>
                    <strong><%= escaparReporte(nombreSesion) %></strong>
                    <small><%= esAdmin ? "Administrador" : "Usuario" %></small>
                </div>
            </div>

        </header>

        <!-- PRESENTACIÓN -->
        <section class="bienvenida">

            <div>
                <span class="etiqueta">ANÁLISIS DE INFORMACIÓN</span>

                <h2>Estadísticas de los laboratorios</h2>

                <p>
                    Consulta y analiza las actividades registradas
                    mediante filtros académicos y períodos de tiempo.
                </p>
            </div>

            <div class="bienvenida-icono">📊</div>

        </section>

        <!-- FILTROS -->
        <section class="panel-registro">

            <div class="panel-titulo">
                <div>
                    <h2>Generación de reportes</h2>
                    <p>Selecciona los criterios de búsqueda.</p>
                </div>

                <span class="etiqueta-panel">FILTROS</span>
            </div>

            <form action="${pageContext.request.contextPath}/ReporteServlet"
                  method="GET"
                  class="formulario">

                <div class="campos-grid">

                    <div class="campo">
                        <label for="programa">Programa académico</label>

                        <input type="text"
                               id="programa"
                               name="programa"
                               value="<%= escaparReporte(filtroPrograma) %>"
                               placeholder="Todos los programas">
                    </div>

                    <div class="campo">
                        <label for="area">Área o laboratorio</label>

                        <input type="text"
                               id="area"
                               name="area"
                               value="<%= escaparReporte(filtroArea) %>"
                               placeholder="Todas las áreas">
                    </div>

                    <div class="campo">
                        <label for="fechaInicial">Fecha inicial</label>

                        <input type="date"
                               id="fechaInicial"
                               name="fechaInicial"
                               value="<%= escaparReporte(fechaInicial) %>">
                    </div>

                    <div class="campo">
                        <label for="fechaFinal">Fecha final</label>

                        <input type="date"
                               id="fechaFinal"
                               name="fechaFinal"
                               value="<%= escaparReporte(fechaFinal) %>">
                    </div>

                </div>

                <div class="acciones-formulario">

                    <a href="${pageContext.request.contextPath}/ReporteServlet"
                       class="boton-secundario">
                        Limpiar filtros
                    </a>

                    <button type="submit" class="boton-principal">
                        Generar reporte →
                    </button>

                </div>

            </form>

        </section>

        <% if (error != null) { %>

            <div class="alerta alerta-error">
                <strong>!</strong>
                <span><%= escaparReporte(error) %></span>
            </div>

        <% } %>

        <% if (generado) { %>

            <!-- INDICADORES -->
            <section class="seccion">

                <div class="seccion-encabezado">
                    <h2>Resumen estadístico</h2>
                    <p>Resultados obtenidos de la base de datos.</p>
                </div>

                <div class="indicadores">

                    <article class="indicador">
                        <div class="indicador-icono azul">▤</div>

                        <div>
                            <span>Total de registros</span>
                            <h3><%= total %></h3>
                            <small>Actividades registradas</small>
                        </div>
                    </article>

                    <article class="indicador">
                        <div class="indicador-icono verde">⌂</div>

                        <div>
                            <span>Áreas utilizadas</span>
                            <h3><%= areas %></h3>
                            <small>Áreas diferentes</small>
                        </div>
                    </article>

                    <article class="indicador">
                        <div class="indicador-icono naranja">▧</div>

                        <div>
                            <span>Programas académicos</span>
                            <h3><%= programas %></h3>
                            <small>Programas registrados</small>
                        </div>
                    </article>

                    <article class="indicador">
                        <div class="indicador-icono morado">◷</div>

                        <div>
                            <span>Asignaturas</span>
                            <h3><%= porAsignatura.size() %></h3>
                            <small>Asignaturas registradas</small>
                        </div>
                    </article>

                </div>

            </section>

            <!-- GRÁFICA POR ÁREA -->
            <section class="panel-registro">

                <div class="panel-titulo">
                    <div>
                        <h2>Uso por laboratorio o área</h2>
                        <p>Distribución de las actividades registradas.</p>
                    </div>
                </div>

                <% if (porArea.isEmpty()) { %>

                    <p>No hay datos disponibles para este filtro.</p>

                <% } else { %>

                    <% for (Map.Entry<String, Integer> dato : porArea.entrySet()) { %>

                        <div class="barra-item">

                            <div class="barra-info">
                                <strong><%= escaparReporte(dato.getKey()) %></strong>
                                <span><%= dato.getValue() %> actividades</span>
                            </div>

                            <div class="barra-fondo">
                                <div class="barra-progreso"
                                     style="width:<%= porcentaje(dato.getValue(), maxArea) %>%">
                                </div>
                            </div>

                        </div>

                    <% } %>

                <% } %>

            </section>

            <!-- GRÁFICA POR PROGRAMA -->
            <section class="panel-registro">

                <div class="panel-titulo">
                    <div>
                        <h2>Actividades por programa académico</h2>
                        <p>Frecuencia de utilización según programa.</p>
                    </div>
                </div>

                <% if (porPrograma.isEmpty()) { %>

                    <p>No hay datos disponibles para este filtro.</p>

                <% } else { %>

                    <% for (Map.Entry<String, Integer> dato : porPrograma.entrySet()) { %>

                        <div class="barra-item">

                            <div class="barra-info">
                                <strong><%= escaparReporte(dato.getKey()) %></strong>
                                <span><%= dato.getValue() %> actividades</span>
                            </div>

                            <div class="barra-fondo">
                                <div class="barra-progreso barra-turquesa"
                                     style="width:<%= porcentaje(dato.getValue(), maxPrograma) %>%">
                                </div>
                            </div>

                        </div>

                    <% } %>

                <% } %>

            </section>

            <!-- GRÁFICA POR ASIGNATURA -->
            <section class="panel-registro">

                <div class="panel-titulo">
                    <div>
                        <h2>Actividades por asignatura</h2>
                        <p>Frecuencia de uso según asignatura.</p>
                    </div>
                </div>

                <% if (porAsignatura.isEmpty()) { %>

                    <p>No hay datos disponibles para este filtro.</p>

                <% } else { %>

                    <% for (Map.Entry<String, Integer> dato : porAsignatura.entrySet()) { %>

                        <div class="barra-item">

                            <div class="barra-info">
                                <strong><%= escaparReporte(dato.getKey()) %></strong>
                                <span><%= dato.getValue() %> actividades</span>
                            </div>

                            <div class="barra-fondo">
                                <div class="barra-progreso"
                                     style="width:<%= porcentaje(dato.getValue(), maxAsignatura) %>%">
                                </div>
                            </div>

                        </div>

                    <% } %>

                <% } %>

            </section>

        <% } else { %>

            <section class="panel-registro sin-registros">
                <div>📊</div>

                <h3>Genera tu primer reporte</h3>

                <p>
                    Selecciona los filtros o presiona el botón
                    Generar reporte para consultar las estadísticas.
                </p>
            </section>

        <% } %>

        <footer class="footer">
            Statistics System © 2026 |
            Sistema de estadísticas de laboratorios clínicos
        </footer>

    </main>

</body>
</html>
