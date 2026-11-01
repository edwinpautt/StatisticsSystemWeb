
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Si el usuario ya tiene sesión activa, ingresa al sistema.
    if (session.getAttribute("usuario") != null) {
        response.sendRedirect(
            request.getContextPath() + "/index.jsp"
        );
        return;
    }

    String error = (String) request.getAttribute("error");
    String cerrada = request.getParameter("cerrada");
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Statistics System | Iniciar sesión</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #204E70, #269D9D);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .contenedor {
            width: 100%;
            max-width: 420px;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 12px 35px rgba(0,0,0,0.18);
        }

        .logo {
            text-align: center;
            margin-bottom: 25px;
        }

        .logo img {
            width: 250px;
            max-width: 100%;
            height: auto;
            object-fit: contain;
        }

        h2 {
            color: #263445;
            text-align: center;
            margin-bottom: 8px;
        }

        .descripcion {
            text-align: center;
            color: #8492A6;
            font-size: 13px;
            margin-bottom: 30px;
        }

        .campo {
            margin-bottom: 20px;
        }

        label {
            display: block;
            color: #34475A;
            font-size: 13px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        input {
            width: 100%;
            padding: 13px;
            border: 1px solid #DCE4EC;
            border-radius: 7px;
            outline: none;
            font-size: 14px;
        }

        input:focus {
            border-color: #45BDBE;
            box-shadow: 0 0 0 3px rgba(69,189,190,0.12);
        }

        .boton {
            width: 100%;
            padding: 14px;
            background: #3F8DCB;
            border: none;
            border-radius: 7px;
            color: white;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }

        .boton:hover {
            background: #2877B4;
        }

        .error {
            background: #FFF0F0;
            border: 1px solid #F2CCCC;
            color: #C74747;
            padding: 12px;
            border-radius: 7px;
            font-size: 13px;
            margin-bottom: 20px;
        }

        .exito {
            background: #E7F7EF;
            border: 1px solid #BCE8D0;
            color: #16845B;
            padding: 12px;
            border-radius: 7px;
            font-size: 13px;
            margin-bottom: 20px;
        }

        .pie {
            text-align: center;
            color: #A0AAB5;
            font-size: 11px;
            margin-top: 30px;
        }

        @media(max-width: 480px) {
            .contenedor {
                padding: 25px;
            }
        }

    </style>

</head>

<body>

    <div class="contenedor">

        <div class="logo">
            <img src="${pageContext.request.contextPath}/img/logo.png"
                 alt="Statistics System">
        </div>

        <h2>Bienvenido</h2>

        <p class="descripcion">
            Ingresa tus credenciales para acceder al sistema.
        </p>

        <% if (error != null) { %>

            <div class="error">
                <%= error %>
            </div>

        <% } %>

        <% if ("true".equals(cerrada)) { %>

            <div class="exito">
                Sesión cerrada correctamente.
            </div>

        <% } %>

        <form action="${pageContext.request.contextPath}/LoginServlet"
              method="POST">

            <div class="campo">

                <label for="usuario">Usuario</label>

                <input type="text"
                       id="usuario"
                       name="usuario"
                       placeholder="Ingresa tu usuario"
                       autocomplete="username"
                       maxlength="50"
                       required>

            </div>

            <div class="campo">

                <label for="contrasena">Contraseña</label>

                <input type="password"
                       id="contrasena"
                       name="contrasena"
                       placeholder="Ingresa tu contraseña"
                       autocomplete="current-password"
                       required>

            </div>

            <button type="submit" class="boton">
                Iniciar sesión
            </button>

        </form>

        <div class="pie">
            Statistics System © 2026
            <br>
            Sistema de estadísticas de laboratorios clínicos
        </div>

    </div>

</body>
</html>
