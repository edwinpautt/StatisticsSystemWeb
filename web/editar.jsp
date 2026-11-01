
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.RegistroDAO"%>
<%@page import="model.Registro"%>

<%!
    // Protege los valores mostrados en los campos del formulario.
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
    // Obtiene el identificador enviado desde la tabla de registros.
    String idTexto = request.getParameter("id");

    Registro registro = null;

    if (idTexto != null) {
        try {
            int id = Integer.parseInt(idTexto);

            // Consulta la información almacenada en MySQL.
            RegistroDAO dao = new RegistroDAO();
            registro = dao.consultarRegistro(id);

        } catch (NumberFormatException e) {
            registro = null;
        }
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Statistics System | Editar registro</title>

    <!-- Hoja de estilos compartida -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

    <!-- Menú lateral -->
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

            <a href="index.jsp" class="nav-link">
                <span>▦</span> Panel principal
            </a>

            <a href="registro.jsp" class="nav-link">
                <span>＋</span> Registrar uso
            </a>

            <a href="RegistroServlet" class="nav-link activo">
                <span>▤</span> Consultar registros
            </a>

            <a href="reportes.jsp" class="nav-link">
                <span>▥</span> Reportes
            </a>

            <a href="configuracion.jsp" class="nav-link">
                <span>⚙</span> Configuración
            </a>

        </nav>

        <div class="sidebar-footer">
            <span class="estado"></span>
            Sistema de gestión
            <small>Versión 1.0</small>
        </div>

    </aside>

    <!-- Contenido principal -->
    <main class="contenido">

        <header class="topbar">
            <div>
                <h1>Editar registro</h1>
                <p>Actualización de información de los laboratorios</p>
            </div>

            <div class="usuario">
                <div class="avatar">A</div>
                <div>
                    <strong>Administrador</strong>
                    <small>Usuario del sistema</small>
                </div>
            </div>
        </header>

        <section class="bienvenida">
            <div>
                <span class="etiqueta">GESTIÓN DE INFORMACIÓN</span>

                <h2>Actualizar actividad registrada</h2>

                <p>
                    Modifica los datos de la actividad académica
                    y guarda los cambios en el sistema.
                </p>
            </div>

            <div class="bienvenida-icono">✏️</div>
        </section>

        <% if (registro != null) { %>

            <section class="panel-registro">

                <div class="panel-titulo">
                    <div>
                        <h2>Información del registro #<%= registro.getId() %></h2>
                        <p>Verifica y modifica los campos necesarios.</p>
                    </div>

                    <span class="etiqueta-panel">EDICIÓN</span>
                </div>

                <form action="${pageContext.request.contextPath}/RegistroServlet"
                      method="POST"
                      class="formulario">

                    <!-- Acción e identificador del registro -->
                    <input type="hidden" name="accion" value="actualizar">

                    <input type="hidden"
                           name="id"
                           value="<%= registro.getId() %>">

                    <div class="grupo-formulario">

                        <h3>01. Información académica</h3>

                        <div class="campos-grid">

                            <div class="campo">
                                <label for="programa">Programa académico *</label>

                                <input type="text"
                                       id="programa"
                                       name="programa"
                                       maxlength="150"
                                       value="<%= escaparHtml(registro.getPrograma()) %>"
                                       required>
                            </div>

                            <div class="campo">
                                <label for="asignatura">Asignatura *</label>

                                <input type="text"
                                       id="asignatura"
                                       name="asignatura"
                                       maxlength="150"
                                       value="<%= escaparHtml(registro.getAsignatura()) %>"
                                       required>
                            </div>

                            <div class="campo">
                                <label for="docente">Docente responsable *</label>

                                <input type="text"
                                       id="docente"
                                       name="docente"
                                       maxlength="150"
                                       value="<%= escaparHtml(registro.getDocente()) %>"
                                       required>
                            </div>

                            <div class="campo">
                                <label for="area">Área o laboratorio *</label>

                                <input type="text"
                                       id="area"
                                       name="area"
                                       maxlength="150"
                                       value="<%= escaparHtml(registro.getArea()) %>"
                                       required>
                            </div>

                        </div>

                    </div>

                    <div class="grupo-formulario">

                        <h3>02. Información de la actividad</h3>

                        <div class="campos-grid">

                            <div class="campo">
                                <label for="fecha">Fecha de actividad *</label>

                                <input type="date"
                                       id="fecha"
                                       name="fecha"
                                       value="<%= escaparHtml(registro.getFecha()) %>"
                                       required>
                            </div>

                            <div class="campo">
                                <label for="horario">Horario *</label>

                                <input type="text"
                                       id="horario"
                                       name="horario"
                                       maxlength="100"
                                       value="<%= escaparHtml(registro.getHorario()) %>"
                                       required>
                            </div>

                        </div>

                    </div>

                    <div class="grupo-formulario">

                        <h3>03. Recursos utilizados</h3>

                        <div class="campo">
                            <label for="elementos">Elementos utilizados *</label>

                            <textarea id="elementos"
                                      name="elementos"
                                      rows="5"
                                      maxlength="2000"
                                      required><%= escaparHtml(registro.getElementos()) %></textarea>
                        </div>

                    </div>

                    <div class="acciones-formulario">

                        <a href="${pageContext.request.contextPath}/RegistroServlet"
                           class="boton-secundario">
                            Cancelar
                        </a>

                        <button type="submit" class="boton-principal">
                            Guardar cambios →
                        </button>

                    </div>

                </form>

            </section>

        <% } else { %>

            <section class="panel-registro">

                <div class="sin-registros">
                    <div>⚠️</div>

                    <h3>No se encontró el registro</h3>

                    <p>
                        El registro solicitado no existe o el identificador
                        proporcionado no es válido.
                    </p>

                    <br>

                    <a href="${pageContext.request.contextPath}/RegistroServlet"
                       class="boton-principal">
                        Volver a los registros
                    </a>
                </div>

            </section>

        <% } %>

        <footer class="footer">
            Statistics System © 2026 |
            Sistema de estadísticas de laboratorios clínicos
        </footer>

    </main>

</body>
</html>
