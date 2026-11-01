
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Usuario"%>

<%
    String rol = (String) session.getAttribute("rol");

    if (session.getAttribute("usuario") == null
            || !"ADMINISTRADOR".equals(rol)) {

        response.sendError(403, "Acceso no autorizado");
        return;
    }

    List<Usuario> usuarios =
            (List<Usuario>) request.getAttribute("usuarios");

    String mensaje = request.getParameter("mensaje");
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Usuarios | Statistics System</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7fa;
            color: #263445;
        }

        header {
            background: linear-gradient(110deg, #20547c, #18a5a5);
            color: white;
            padding: 25px 40px;
        }

        header h1 {
            margin: 0 0 8px;
        }

        header p {
            margin: 0;
        }

        .contenedor {
            width: 92%;
            max-width: 1200px;
            margin: 35px auto;
        }

        .tarjeta {
            background: white;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #e1e8ef;
            margin-bottom: 25px;
        }

        .encabezado-seccion {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
        }

        .encabezado-seccion p {
            color: #8492a6;
            font-size: 13px;
        }

        .boton {
            display: inline-block;
            padding: 10px 15px;
            border: none;
            border-radius: 6px;
            background: #3988dc;
            color: white;
            text-decoration: none;
            cursor: pointer;
            font-size: 13px;
            font-weight: bold;
        }

        .boton:hover {
            background: #246fae;
        }

        .mensaje {
            padding: 13px;
            background: #e5f5ed;
            color: #16845b;
            border-radius: 7px;
            margin-bottom: 20px;
        }

        .tabla-contenedor {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 750px;
        }

        th {
            background: #edf3f8;
            color: #34475a;
            font-size: 12px;
            text-align: left;
            padding: 15px 10px;
        }

        td {
            padding: 14px 10px;
            border-bottom: 1px solid #e8edf2;
            font-size: 13px;
        }

        .estado {
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }

        .activo {
            background: #e0f7ee;
            color: #16845b;
        }

        .inactivo {
            background: #fff0df;
            color: #c27a27;
        }

        .rol {
            color: #3988dc;
            font-weight: bold;
        }

        .acciones {
            display: flex;
            gap: 7px;
            align-items: center;
        }

        .boton-editar {
            background: #3988dc;
            color: white;
            padding: 7px 10px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 11px;
        }

        .boton-estado {
            background: #eef1f5;
            color: #34475a;
            border: none;
            padding: 7px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 11px;
        }

        .volver {
            color: #3988dc;
            text-decoration: none;
            font-weight: bold;
            font-size: 13px;
        }

        .vacio {
            text-align: center;
            color: #8492a6;
            padding: 30px;
        }

        footer {
            text-align: center;
            padding: 25px;
            color: #8492a6;
            font-size: 12px;
        }

        @media(max-width: 600px) {
            header {
                padding: 25px;
            }

            .tarjeta {
                padding: 18px;
            }
        }

    </style>

</head>

<body>

<header>

    <h1>Statistics System</h1>

    <p>Administración de usuarios</p>

</header>

<main class="contenedor">

    <div class="encabezado-seccion">

        <div>
            <h2>Usuarios registrados</h2>
            <p>Consulta y administra las cuentas del sistema.</p>
        </div>

        <a href="configuracion.jsp" class="volver">
            ← Volver a configuración
        </a>

    </div>

    <% if (mensaje != null && !mensaje.isEmpty()) { %>

        <div class="mensaje">
            <%= mensaje %>
        </div>

    <% } %>

    <section class="tarjeta">

        <div class="encabezado-seccion">

            <div>
                <h3>Listado de usuarios</h3>
                <a href="${pageContext.request.contextPath}/crearUsuario.jsp"
   style="display:inline-block; background:#2785df; color:white;
   padding:11px 17px; border-radius:6px; text-decoration:none;
   margin:15px 0;">
    + Registrar nuevo usuario
</a>
                <p>Usuarios registrados en Statistics System.</p>
            </div>

        </div>

        <div class="tabla-contenedor">

            <table>

                <thead>

                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Usuario</th>
                        <th>Rol</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>

                </thead>

                <tbody>

                <% if (usuarios != null && !usuarios.isEmpty()) { %>

                    <% for (Usuario u : usuarios) { %>

                        <tr>

                            <td><%= u.getId() %></td>

                            <td><%= u.getNombre() %></td>

                            <td><%= u.getUsuario() %></td>

                            <td class="rol">
                                <%= u.getRol() %>
                            </td>

                            <td>

                                <% if ("ACTIVO".equals(u.getEstado())) { %>

                                    <span class="estado activo">
                                        ACTIVO
                                    </span>

                                <% } else { %>

                                    <span class="estado inactivo">
                                        INACTIVO
                                    </span>

                                <% } %>

                            </td>

                            <td>

                                <div class="acciones">

                                    <a class="boton-editar"
                                       href="UsuariosServlet?accion=editar&id=<%= u.getId() %>">

                                        Editar

                                    </a>

                                    <form action="UsuariosServlet"
                                          method="POST"
                                          onsubmit="return confirm('¿Deseas cambiar el estado de esta cuenta?');">

                                        <input type="hidden"
                                               name="accion"
                                               value="estado">

                                        <input type="hidden"
                                               name="id"
                                               value="<%= u.getId() %>">

                                        <input type="hidden"
                                               name="estado"
                                               value="<%= "ACTIVO".equals(u.getEstado()) ? "INACTIVO" : "ACTIVO" %>">

                                        <button type="submit"
                                                class="boton-estado">

                                            <%= "ACTIVO".equals(u.getEstado())
                                                ? "Desactivar"
                                                : "Activar" %>

                                        </button>

                                    </form>

                                </div>

                            </td>

                        </tr>

                    <% } %>

                <% } else { %>

                    <tr>
                        <td colspan="6" class="vacio">
                            No hay usuarios registrados.
                        </td>
                    </tr>

                <% } %>

                </tbody>

            </table>

        </div>

    </section>

</main>

<footer>
    Statistics System © 2026
</footer>

</body>
</html>
