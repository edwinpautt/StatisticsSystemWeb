

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Recuperar información del usuario autenticado.
    String nombreUsuario = (String) session.getAttribute("nombre");
    String rolUsuario = (String) session.getAttribute("rol");

    // Si no existe una sesión, regresar al login.
    if (nombreUsuario == null || rolUsuario == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    String inicial = nombreUsuario.substring(0, 1).toUpperCase();
    boolean esAdministrador = "ADMINISTRADOR".equals(rolUsuario);
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Statistics System | Panel principal</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css">

</head>

<body>

    <!-- MENÚ LATERAL -->
    <aside class="sidebar">

        <div class="logo-icon">
            <img src="${pageContext.request.contextPath}/img/logo.png"
                 alt="Logo Statistics System">
        </div>

        <div class="menu-titulo">MENÚ PRINCIPAL</div>

        <nav class="navegacion">

            <a href="index.jsp" class="nav-link activo">
                <span>▦</span> Panel principal
            </a>

            <a href="registro.jsp" class="nav-link">
                <span>＋</span> Registrar uso
            </a>

            <a href="RegistroServlet" class="nav-link">
                <span>▤</span> Consultar registros
            </a>

            <a href="reportes.jsp" class="nav-link">
                <span>▥</span> Reportes
            </a>

            <% if (esAdministrador) { %>

                <a href="configuracion.jsp" class="nav-link">
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


        <!-- BARRA SUPERIOR -->
        <header class="topbar">

            <div class="usuario-sesion">

                <div class="avatar">
                    <%= inicial %>
                </div>

                <div class="datos-usuario">

                    <strong>
                        <%= nombreUsuario %>
                    </strong>

                    <span>
                        <%= esAdministrador ? "Administrador" : "Usuario" %>
                    </span>

                </div>

                <form action="${pageContext.request.contextPath}/LogoutServlet"
                      method="POST"
                      onsubmit="return confirm('¿Deseas cerrar tu sesión?');">

                    <button type="submit" class="btn-cerrar">
                        ⏻ Cerrar sesión
                    </button>

                </form>

            </div>

        </header>


        <!-- BIENVENIDA -->
        <section class="bienvenida">

            <div>

                <span class="etiqueta">
                    PLATAFORMA DE GESTIÓN
                </span>

                <h2>Bienvenido a Statistics System</h2>

                <p>
                    Administra, consulta y analiza la información
                    relacionada con el uso de los laboratorios
                    de simulación clínica.
                </p>

            </div>

            <div class="bienvenida-icono">
                📊
            </div>

        </section>


        <!-- INDICADORES GENERALES -->
        <section class="seccion">

            <div class="seccion-encabezado">

                <div>
                    <h2>Resumen del sistema</h2>
                    <p>Indicadores generales de gestión</p>
                </div>

            </div>

            <div class="indicadores">

                <article class="indicador">

                    <div class="indicador-icono azul">▤</div>

                    <div>
                        <span>Registros</span>
                        <h3>--</h3>
                        <small>Total de registros</small>
                    </div>

                </article>


                <article class="indicador">

                    <div class="indicador-icono verde">⌂</div>

                    <div>
                        <span>Laboratorios</span>
                        <h3>--</h3>
                        <small>Áreas disponibles</small>
                    </div>

                </article>


                <article class="indicador">

                    <div class="indicador-icono naranja">◷</div>

                    <div>
                        <span>Horas de uso</span>
                        <h3>--</h3>
                        <small>Horas registradas</small>
                    </div>

                </article>


                <article class="indicador">

                    <div class="indicador-icono morado">▧</div>

                    <div>
                        <span>Reportes</span>
                        <h3>--</h3>
                        <small>Consultas estadísticas</small>
                    </div>

                </article>

            </div>

        </section>


        <!-- MÓDULOS DEL SISTEMA -->
        <section class="seccion">

            <div class="seccion-encabezado">

                <div>
                    <h2>Módulos del sistema</h2>
                    <p>Selecciona el módulo que deseas utilizar</p>
                </div>

            </div>


            <div class="modulos">


                <article class="modulo">

                    <div class="modulo-icono azul">＋</div>

                    <h3>Registrar uso</h3>

                    <p>
                        Registra las actividades realizadas en los
                        laboratorios, incluyendo programas,
                        asignaturas, docentes y horarios.
                    </p>

                    <a href="registro.jsp">
                        Ingresar al módulo →
                    </a>

                </article>


                <article class="modulo">

                    <div class="modulo-icono verde">▤</div>

                    <h3>Consultar registros</h3>

                    <p>
                        Consulta y administra la información
                        almacenada en la base de datos.
                    </p>

                    <a href="RegistroServlet">
                        Ingresar al módulo →
                    </a>

                </article>


                <article class="modulo">

                    <div class="modulo-icono naranja">▥</div>

                    <h3>Reportes y estadísticas</h3>

                    <p>
                        Consulta información estadística sobre
                        la utilización de los laboratorios.
                    </p>

                    <a href="reportes.jsp">
                        Ingresar al módulo →
                    </a>

                </article>


                <% if (esAdministrador) { %>

                    <article class="modulo">

                        <div class="modulo-icono morado">⚙</div>

                        <h3>Configuración</h3>

                        <p>
                            Gestiona las opciones y parámetros
                            generales de la plataforma.
                        </p>

                        <a href="configuracion.jsp">
                            Ingresar al módulo →
                        </a>

                    </article>

                <% } %>


            </div>

        </section>


        <!-- PIE DE PÁGINA -->
        <footer class="footer">

            Statistics System © 2026 |
            Sistema de estadísticas de laboratorios clínicos

        </footer>

    </main>

</body>
</html>
