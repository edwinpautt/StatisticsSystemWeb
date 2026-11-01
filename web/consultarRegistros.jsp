
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Registro"%>

<%!
    private String escaparHtml(Object valor) {
        if (valor == null) return "";

        return String.valueOf(valor)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
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

    List<Registro> registros =
            (List<Registro>) request.getAttribute("registros");

    String mensaje = request.getParameter("mensaje");
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Statistics System | Consultar registros</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

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
               class="nav-link activo">
                <span>▤</span> Consultar registros
            </a>

            <a href="${pageContext.request.contextPath}/ReporteServlet"
               class="nav-link">
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

    <main class="contenido">

        <header class="topbar">

            <div>
                <h1>Consultar registros</h1>
                <p>Historial de actividades de los laboratorios</p>
            </div>

            <div class="usuario">
                <div class="avatar">
                    <%= escaparHtml(inicial) %>
                </div>

                <div>
                    <strong><%= escaparHtml(nombreSesion) %></strong>
                    <small><%= esAdmin ? "Administrador" : "Usuario" %></small>
                </div>
            </div>

        </header>

        <section class="bienvenida">

            <div>
                <span class="etiqueta">CONSULTA DE INFORMACIÓN</span>

                <h2>Registros de uso de laboratorios</h2>

                <p>
                    Consulta las actividades académicas registradas
                    en los laboratorios de simulación clínica.
                </p>
            </div>

            <div class="bienvenida-icono">📋</div>

        </section>

        <% if (mensaje != null && !mensaje.trim().isEmpty()) { %>
            <div class="alerta alerta-exito">
                <strong>✓</strong>
                <span><%= escaparHtml(mensaje) %></span>
            </div>
        <% } %>

        <section class="panel-registro">

            <div class="panel-titulo">

                <div>
                    <h2>Historial de registros</h2>
                    <p>
                        Consulta la información almacenada en el sistema.
                    </p>
                </div>

                <a href="${pageContext.request.contextPath}/RegistroServlet"
                   class="boton-consultar">
                    ↻ Actualizar registros
                </a>

            </div>

            <% if (registros != null && !registros.isEmpty()) { %>

                <div class="tabla-contenedor">

                    <table class="tabla-registros">

                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Programa</th>
                                <th>Asignatura</th>
                                <th>Docente</th>
                                <th>Área</th>
                                <th>Fecha</th>
                                <th>Horario</th>
                                <th>Elementos</th>

                                <% if (esAdmin) { %>
                                    <th>Acciones</th>
                                <% } %>
                            </tr>
                        </thead>

                        <tbody>

                            <% for (Registro registro : registros) { %>

                                <tr>

                                    <td><%= registro.getId() %></td>

                                    <td>
                                        <%= escaparHtml(registro.getPrograma()) %>
                                    </td>

                                    <td>
                                        <%= escaparHtml(registro.getAsignatura()) %>
                                    </td>

                                    <td>
                                        <%= escaparHtml(registro.getDocente()) %>
                                    </td>

                                    <td>
                                        <%= escaparHtml(registro.getArea()) %>
                                    </td>

                                    <td>
                                        <%= escaparHtml(registro.getFecha()) %>
                                    </td>

                                    <td>
                                        <%= escaparHtml(registro.getHorario()) %>
                                    </td>

                                    <td>
                                        <%= escaparHtml(registro.getElementos()) %>
                                    </td>

                                    <% if (esAdmin) { %>

                                        <td class="acciones-tabla">

                                            <a class="accion-editar"
                                               href="${pageContext.request.contextPath}/editar.jsp?id=<%= registro.getId() %>">
                                                Editar
                                            </a>

                                            <form action="${pageContext.request.contextPath}/RegistroServlet"
                                                  method="POST"
                                                  class="form-eliminar"
                                                  onsubmit="return confirm('¿Está seguro de eliminar este registro?');">

                                                <input type="hidden"
                                                       name="accion"
                                                       value="eliminar">

                                                <input type="hidden"
                                                       name="id"
                                                       value="<%= registro.getId() %>">

                                                <button type="submit"
                                                        class="accion-eliminar">
                                                    Eliminar
                                                </button>

                                            </form>

                                        </td>

                                    <% } %>

                                </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>

            <% } else { %>

                <div class="sin-registros">
                    <div>📂</div>
                    <h3>No hay registros disponibles</h3>
                    <p>Cuando existan actividades registradas aparecerán aquí.</p>
                </div>

            <% } %>

        </section>

        <footer class="footer">
            Statistics System © 2026 |
            Sistema de estadísticas de laboratorios clínicos
        </footer>

    </main>

</body>
</html>
