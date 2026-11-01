
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Usuario"%>

<%
    String rolSesion = (String) session.getAttribute("rol");

    if (session.getAttribute("usuario") == null
            || !"ADMINISTRADOR".equals(rolSesion)) {

        response.sendError(403, "Acceso no autorizado");
        return;
    }

    Usuario usuario =
            (Usuario) request.getAttribute("usuarioEditar");
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Editar usuario | Statistics System</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 30px 15px;
            font-family: Arial, sans-serif;
            background: #f4f7fa;
        }

        .contenedor {
            max-width: 600px;
            margin: 30px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            border: 1px solid #e1e8ef;
        }

        h1 {
            color: #20547c;
        }

        p {
            color: #8492a6;
            font-size: 13px;
        }

        .campo {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: bold;
            font-size: 13px;
        }

        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #dce4ec;
            border-radius: 6px;
            font-size: 14px;
        }

        .boton {
            padding: 12px 18px;
            border: none;
            background: #3988dc;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }

        .volver {
            display: inline-block;
            margin-left: 10px;
            color: #3988dc;
            text-decoration: none;
        }

        .separador {
            border: none;
            border-top: 1px solid #e1e8ef;
            margin: 25px 0;
        }

    </style>

</head>

<body>

<div class="contenedor">

    <h1>Editar usuario</h1>

    <p>Modifica la información de la cuenta seleccionada.</p>

    <% if (usuario != null) { %>

        <form action="UsuariosServlet" method="POST">

            <input type="hidden"
                   name="accion"
                   value="actualizar">

            <input type="hidden"
                   name="id"
                   value="<%= usuario.getId() %>">


            <div class="campo">

                <label>Nombre completo</label>

                <input type="text"
                       name="nombre"
                       value="<%= usuario.getNombre() %>"
                       maxlength="100"
                       required>

            </div>


            <div class="campo">

                <label>Nombre de usuario</label>

                <input type="text"
                       name="usuario"
                       value="<%= usuario.getUsuario() %>"
                       maxlength="50"
                       required>

            </div>


            <div class="campo">

                <label>Perfil de usuario</label>

                <select name="rol" required>

                    <option value="ADMINISTRADOR"
                        <%= "ADMINISTRADOR".equals(usuario.getRol())
                            ? "selected" : "" %>>
                        Administrador
                    </option>

                    <option value="USUARIO"
                        <%= "USUARIO".equals(usuario.getRol())
                            ? "selected" : "" %>>
                        Usuario
                    </option>

                </select>

            </div>


            <div class="campo">

                <label>Estado de la cuenta</label>

                <select name="estado" required>

                    <option value="ACTIVO"
                        <%= "ACTIVO".equals(usuario.getEstado())
                            ? "selected" : "" %>>
                        Activo
                    </option>

                    <option value="INACTIVO"
                        <%= "INACTIVO".equals(usuario.getEstado())
                            ? "selected" : "" %>>
                        Inactivo
                    </option>

                </select>

            </div>


            <button type="submit" class="boton">
                Guardar cambios
            </button>

            <a href="UsuariosServlet" class="volver">
                Cancelar
            </a>

        </form>


        <hr class="separador">

        <h3>Cambiar contraseña</h3>

        <p>
            La nueva contraseña debe contener al menos
            ocho caracteres.
        </p>

        <form action="UsuariosServlet" method="POST">

            <input type="hidden"
                   name="accion"
                   value="contrasena">

            <input type="hidden"
                   name="id"
                   value="<%= usuario.getId() %>">

            <div class="campo">

                <label>Nueva contraseña</label>

                <input type="password"
                       name="contrasena"
                       minlength="8"
                       autocomplete="new-password"
                       required>

            </div>

            <button type="submit" class="boton">
                Actualizar contraseña
            </button>

        </form>

    <% } else { %>

        <p>No se encontró el usuario solicitado.</p>

        <a href="UsuariosServlet" class="volver">
            Volver a usuarios
        </a>

    <% } %>

</div>

</body>
</html>
