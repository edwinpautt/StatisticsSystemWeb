
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Verificar que exista una sesión de administrador.
    String nombre = (String) session.getAttribute("nombre");
    String rol = (String) session.getAttribute("rol");

    if (nombre == null || rol == null ||
        !"ADMINISTRADOR".equalsIgnoreCase(rol)) {

        response.sendRedirect(
            request.getContextPath() + "/index.jsp"
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Configuración | Statistics System</title>

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

        .encabezado {
            background: linear-gradient(110deg, #20547c, #18a5a5);
            color: white;
            padding: 30px 40px;
        }

        .encabezado h1 {
            margin: 0 0 8px;
            font-size: 26px;
        }

        .encabezado p {
            margin: 0;
            font-size: 14px;
        }

        .contenedor {
            width: 92%;
            max-width: 1200px;
            margin: 35px auto;
        }

        .bienvenida {
            background: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 25px;
            border: 1px solid #e1e8ef;
        }

        .bienvenida h2 {
            margin-top: 0;
        }

        .bienvenida p {
            color: #8492a6;
            line-height: 1.6;
        }

        .seccion-titulo {
            margin: 30px 0 18px;
        }

        .seccion-titulo p {
            color: #8492a6;
            font-size: 13px;
        }

        .modulos {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 22px;
        }

        .tarjeta {
            background: white;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #e1e8ef;
            transition: 0.2s;
        }

        .tarjeta:hover {
            box-shadow: 0 5px 18px rgba(0,0,0,0.08);
            transform: translateY(-2px);
        }

        .icono {
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 9px;
            font-size: 22px;
            margin-bottom: 15px;
        }

        .azul {
            background: #e5efff;
            color: #3988dc;
        }

        .verde {
            background: #e0f7ee;
            color: #18a77a;
        }

        .naranja {
            background: #fff0df;
            color: #ed963d;
        }

        .morado {
            background: #f0e8ff;
            color: #9060dc;
        }

        .tarjeta h3 {
            margin: 0 0 10px;
            color: #263445;
        }

        .tarjeta p {
            color: #8492a6;
            font-size: 13px;
            line-height: 1.6;
            min-height: 42px;
        }

        .boton {
            display: inline-block;
            margin-top: 12px;
            padding: 11px 17px;
            background: #3988dc;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: bold;
        }

        .boton:hover {
            background: #246fae;
        }

        .boton-deshabilitado {
            display: inline-block;
            margin-top: 12px;
            padding: 11px 17px;
            background: #e9edf2;
            color: #8492a6;
            border-radius: 6px;
            font-size: 13px;
        }

        .barra-superior {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
        }

        .usuario {
            font-size: 13px;
            color: #8492a6;
        }

        .volver {
            color: #3988dc;
            text-decoration: none;
            font-weight: bold;
            font-size: 13px;
        }

        .pie {
            text-align: center;
            padding: 30px;
            color: #8492a6;
            font-size: 12px;
        }

        @media(max-width: 700px) {
            .modulos {
                grid-template-columns: 1fr;
            }

            .encabezado {
                padding: 25px;
            }
        }

    </style>

</head>

<body>

    <!-- ENCABEZADO -->
    <header class="encabezado">

        <h1>Statistics System</h1>

        <p>Administración y configuración de la plataforma</p>

    </header>


    <main class="contenedor">

        <div class="barra-superior">

            <span class="usuario">
                Administrador conectado: <strong><%= nombre %></strong>
            </span>

            <a href="index.jsp" class="volver">
                ← Volver al panel principal
            </a>

        </div>


        <!-- BIENVENIDA -->
        <section class="bienvenida">

            <h2>Configuración del sistema</h2>

            <p>
                Desde este módulo puedes administrar los usuarios,
                programas académicos, asignaturas, docentes y áreas
                relacionadas con los laboratorios de simulación clínica.
            </p>

        </section>


        <!-- ADMINISTRACIÓN -->
        <div class="seccion-titulo">

            <h2>Administración general</h2>

            <p>Selecciona el módulo que deseas gestionar.</p>

        </div>


        <section class="modulos">


            <!-- USUARIOS -->
            <article class="tarjeta">

                <div class="icono azul">♙</div>

                <h3>Administración de usuarios</h3>

                <p>
                    Registra nuevos usuarios, consulta sus datos,
                    modifica sus perfiles y administra sus estados
                    de acceso al sistema.
                </p>

                <a href="UsuariosServlet" class="boton">
                    Administrar usuarios →
                </a>

            </article>


            <!-- PROGRAMAS -->
            <article class="tarjeta">

                <div class="icono verde">▤</div>

                <h3>Programas académicos</h3>

                <p>
                    Administración de los programas académicos
                    utilizados en los registros de actividades.
                </p>

                <span class="boton-deshabilitado">
                    Próximamente
                </span>

            </article>


            <!-- ASIGNATURAS -->
            <article class="tarjeta">

                <div class="icono naranja">▧</div>

                <h3>Asignaturas</h3>

                <p>
                    Gestión de las asignaturas disponibles
                    para las actividades de los laboratorios.
                </p>

                <span class="boton-deshabilitado">
                    Próximamente
                </span>

            </article>


            <!-- DOCENTES -->
            <article class="tarjeta">

                <div class="icono morado">♙</div>

                <h3>Docentes</h3>

                <p>
                    Administración de los docentes responsables
                    de las prácticas académicas.
                </p>

                <span class="boton-deshabilitado">
                    Próximamente
                </span>

            </article>


            <!-- ÁREAS -->
            <article class="tarjeta">

                <div class="icono azul">⌂</div>

                <h3>Áreas de laboratorio</h3>

                <p>
                    Gestión de las áreas de simulación clínica,
                    urgencias, hospitalización y otros espacios.
                </p>

                <span class="boton-deshabilitado">
                    Próximamente
                </span>

            </article>


            <!-- HORARIOS -->
            <article class="tarjeta">

                <div class="icono verde">◷</div>

                <h3>Horarios</h3>

                <p>
                    Administración de los horarios destinados
                    a las actividades académicas.
                </p>

                <span class="boton-deshabilitado">
                    Próximamente
                </span>

            </article>


        </section>


    </main>


    <footer class="pie">

        Statistics System © 2026 |
        Sistema de estadísticas de laboratorios clínicos

    </footer>

</body>

</html>
