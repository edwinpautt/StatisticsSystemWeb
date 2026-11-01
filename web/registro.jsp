
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
    // ==========================================
    // CONTROL DE SESIÓN Y ROLES
    // ==========================================

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
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Statistics System | Registro</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

    <!-- ======================================
         MENÚ LATERAL
    ======================================= -->

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
               class="nav-link activo">
                <span>＋</span> Registrar uso
            </a>

            <a href="${pageContext.request.contextPath}/RegistroServlet"
               class="nav-link">
                <span>▤</span> Consultar registros
            </a>

            <a href="${pageContext.request.contextPath}/reportes.jsp"
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

    <!-- ======================================
         CONTENIDO PRINCIPAL
    ======================================= -->

    <main class="contenido">

        <!-- ENCABEZADO -->

        <header class="topbar">

            <div>
                <h1>Registro de laboratorio</h1>
                <p>Administración de actividades académicas</p>
            </div>

            <div class="usuario">

                <div class="avatar">
                    <%= escaparHtml(inicial) %>
                </div>

                <div>
                    <strong><%= escaparHtml(nombreSesion) %></strong>

                    <small>
                        <%= esAdmin ? "Administrador" : "Usuario" %>
                    </small>
                </div>

            </div>

        </header>

        <!-- PRESENTACIÓN -->

        <section class="bienvenida">

            <div>

                <span class="etiqueta">GESTIÓN ACADÉMICA</span>

                <h2>Registro de uso de laboratorios</h2>

                <p>
                    Registra la información de las actividades
                    desarrolladas en los laboratorios de
                    simulación clínica.
                </p>

            </div>

            <div class="bienvenida-icono">📋</div>

        </section>

        <!-- MENSAJES -->

        <%
            String mensaje = request.getParameter("mensaje");
            String error = (String) request.getAttribute("error");
        %>

        <% if (mensaje != null && !mensaje.trim().isEmpty()) { %>

            <div class="alerta alerta-exito">
                <strong>✓</strong>
                <span><%= escaparHtml(mensaje) %></span>
            </div>

        <% } %>

        <% if (error != null && !error.trim().isEmpty()) { %>

            <div class="alerta alerta-error">
                <strong>!</strong>
                <span><%= escaparHtml(error) %></span>
            </div>

        <% } %>

        <!-- ======================================
             FORMULARIO DE REGISTRO
        ======================================= -->

        <section class="panel-registro">

            <div class="panel-titulo">

                <div>
                    <h2>Nuevo registro</h2>
                    <p>Completa los campos para registrar una actividad.</p>
                </div>

                <span class="etiqueta-panel">FORMULARIO</span>

            </div>

            <form action="${pageContext.request.contextPath}/RegistroServlet"
                  method="POST"
                  class="formulario">

                <input type="hidden" name="accion" value="insertar">

                <!-- INFORMACIÓN ACADÉMICA -->

                <div class="grupo-formulario">

                    <h3>01. Información académica</h3>

                    <div class="campos-grid">

                        <div class="campo">
                            <label for="programa">Programa académico *</label>

                            <input type="text"
                                   id="programa"
                                   name="programa"
                                   placeholder="Ej. Enfermería"
                                   maxlength="150"
                                   required>
                        </div>

                        <div class="campo">
                            <label for="asignatura">Asignatura *</label>

                            <input type="text"
                                   id="asignatura"
                                   name="asignatura"
                                   placeholder="Nombre de la asignatura"
                                   maxlength="150"
                                   required>
                        </div>

                        <div class="campo">
                            <label for="docente">Docente responsable *</label>

                            <input type="text"
                                   id="docente"
                                   name="docente"
                                   placeholder="Nombre completo del docente"
                                   maxlength="150"
                                   required>
                        </div>

                        <div class="campo">
                            <label for="area">Área o laboratorio *</label>

                            <input type="text"
                                   id="area"
                                   name="area"
                                   placeholder="Ej. Simulación clínica"
                                   maxlength="150"
                                   required>
                        </div>

                    </div>

                </div>

                <!-- INFORMACIÓN DE LA ACTIVIDAD -->

                <div class="grupo-formulario">

                    <h3>02. Información de la actividad</h3>

                    <div class="campos-grid">

                        <div class="campo">
                            <label for="fecha">Fecha de actividad *</label>

                            <input type="date"
                                   id="fecha"
                                   name="fecha"
                                   required>
                        </div>

                        <div class="campo">
                            <label for="horario">Horario *</label>

                            <input type="text"
                                   id="horario"
                                   name="horario"
                                   placeholder="Ej. 8:00 a.m. - 10:00 a.m."
                                   maxlength="100"
                                   required>
                        </div>

                    </div>

                </div>

                <!-- RECURSOS UTILIZADOS -->

                <div class="grupo-formulario">

                    <h3>03. Recursos utilizados</h3>

                    <div class="campo">

                        <label for="elementos">Elementos utilizados *</label>

                        <textarea id="elementos"
                                  name="elementos"
                                  rows="4"
                                  maxlength="2000"
                                  placeholder="Describe los simuladores, equipos, materiales e instrumentos utilizados durante la actividad..."
                                  required></textarea>

                    </div>

                </div>

                <!-- BOTONES -->

                <div class="acciones-formulario">

                    <button type="reset" class="boton-secundario">
                        Limpiar formulario
                    </button>

                    <button type="submit" class="boton-principal">
                        Registrar actividad →
                    </button>

                </div>

            </form>

        </section>

        <!-- ======================================
             TABLA DE REGISTROS
        ======================================= -->

        <section class="panel-registro">

            <div class="panel-titulo">

                <div>
                    <h2>Registros del laboratorio</h2>
                    <p>Consulta las actividades registradas.</p>
                </div>

                <a href="${pageContext.request.contextPath}/RegistroServlet"
                   class="boton-consultar">
                    ↻ Actualizar registros
                </a>

            </div>

            <%
                List<Registro> registros =
                    (List<Registro>) request.getAttribute("registros");
            %>

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

                    <p>
                        Cuando registres una actividad aparecerá en esta tabla.
                    </p>

                </div>

            <% } %>

        </section>

        <!-- PIE DE PÁGINA -->

        <footer class="footer">

            Statistics System © 2026 |
            Sistema de estadísticas de laboratorios clínicos

        </footer>

    </main>

</body>
</html>
