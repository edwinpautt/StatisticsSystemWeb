
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String rolSesion = (String) session.getAttribute("rol");

    if (session.getAttribute("usuario") == null ||
        !"ADMINISTRADOR".equalsIgnoreCase(rolSesion)) {
        response.sendRedirect("index.jsp");
        return;
    }

    String mensaje = request.getParameter("mensaje");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Registrar usuario | Statistics System</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fa;
            color: #24364b;
        }

        header {
            background: linear-gradient(110deg, #245b82, #18aaa6);
            color: white;
            padding: 24px 35px;
        }

        header h1 {
            margin: 0 0 6px;
            font-size: 27px;
        }

        header p {
            margin: 0;
        }

        .contenedor {
            max-width: 750px;
            margin: 45px auto;
            padding: 0 20px;
        }

        .tarjeta {
            background: white;
            border: 1px solid #dce5ef;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 3px 12px rgba(0,0,0,.04);
        }

        h2 {
            margin-top: 0;
        }

        .descripcion {
            color: #718096;
            margin-bottom: 25px;
        }

        .campo {
            margin-bottom: 19px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
        }

        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccd6e2;
            border-radius: 6px;
            font-size: 14px;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #269fba;
        }

        .botones {
            display: flex;
            gap: 12px;
            margin-top: 25px;
        }

        button, .cancelar {
            border: none;
            border-radius: 6px;
            padding: 12px 20px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
        }

        button {
            background: #2785df;
            color: white;
        }

        .cancelar {
            background: #e9eef4;
            color: #34445a;
        }

        .mensaje {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            background: #fff3cd;
            color: #765b00;
        }

        footer {
            text-align: center;
            color: #8190a5;
            font-size: 12px;
            margin: 45px 0;
        }
    </style>
</head>

<body>

<header>
    <h1>Statistics System</h1>
    <p>Administración de usuarios</p>
</header>

<main class="contenedor">

    <section class="tarjeta">

        <h2>Registrar nuevo usuario</h2>

        <p class="descripcion">
            Completa los datos para crear una cuenta en el sistema.
        </p>

        <% if (mensaje != null && !mensaje.isEmpty()) { %>
            <div class="mensaje"><%= mensaje %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/UsuariosServlet"
              method="POST">

            <input type="hidden" name="accion" value="crear">

            <div class="campo">
                <label for="nombre">Nombre completo</label>
                <input type="text"
                       id="nombre"
                       name="nombre"
                       placeholder="Ingrese el nombre completo"
                       maxlength="100"
                       required>
            </div>

            <div class="campo">
                <label for="usuario">Nombre de usuario</label>
                <input type="text"
                       id="usuario"
                       name="usuario"
                       placeholder="Ingrese un nombre de usuario"
                       maxlength="50"
                       required>
            </div>

            <div class="campo">
                <label for="contrasena">Contraseña</label>
                <input type="password"
                       id="contrasena"
                       name="contrasena"
                       placeholder="Mínimo 8 caracteres"
                       minlength="8"
                       required>
            </div>

            <div class="campo">
                <label for="rol">Rol del usuario</label>
                <select id="rol" name="rol" required>
                    <option value="">Seleccione un rol</option>
                    <option value="ADMINISTRADOR">Administrador</option>
                    <option value="USUARIO">Usuario</option>
                </select>
            </div>

            <div class="botones">
                <button type="submit">
                    Registrar usuario
                </button>

                <a href="${pageContext.request.contextPath}/UsuariosServlet"
                   class="cancelar">
                    Cancelar
                </a>
            </div>

        </form>

    </section>

</main>

<footer>
    Statistics System © 2026
</footer>

</body>
</html>
