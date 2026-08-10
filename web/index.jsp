<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>Statistics System</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
        }

        .encabezado {
            background-color: #1f4e78;
            color: white;
            padding: 25px 40px;
        }

        .encabezado h1 {
            margin: 0;
        }

        .encabezado p {
            margin-bottom: 0;
        }

        .contenedor {
            width: 90%;
            max-width: 1100px;
            margin: 40px auto;
        }

        .bienvenida {
            background-color: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
        }

        .bienvenida h2 {
            margin-top: 0;
        }

        .menu {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
        }

        .tarjeta {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            text-decoration: none;
            color: #222;
            border: 1px solid #ddd;
        }

        .tarjeta:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.15);
        }

        .tarjeta h3 {
            margin-top: 0;
            color: #1f4e78;
        }

        .boton {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #1f4e78;
            color: white;
            border-radius: 5px;
            text-decoration: none;
        }

        .pie {
            text-align: center;
            margin-top: 50px;
            padding: 20px;
            color: #666;
        }

        @media (max-width: 700px) {

            .menu {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>

<body>


<header class="encabezado">

    <h1>Statistics System</h1>

    <p>
        Sistema de estadísticas de uso de laboratorios de simulación clínica
    </p>

</header>


<main class="contenedor">


    <section class="bienvenida">

        <h2>
            Bienvenido al sistema
        </h2>

        <p>
            Desde esta plataforma puede registrar y consultar
            la información relacionada con el uso de los laboratorios
            de simulación clínica.
        </p>

    </section>


    <section class="menu">


        <!-- REGISTRAR -->

        <div class="tarjeta">

            <h3>
                Registrar uso
            </h3>

            <p>
                Registre un nuevo uso del laboratorio indicando
                programa académico, asignatura, docente, área,
                fecha, horario y elementos utilizados.
            </p>

            <a class="boton"
               href="registro.jsp">

                Registrar uso

            </a>

        </div>


        <!-- CONSULTAR -->

        <div class="tarjeta">

            <h3>
                Consultar registros
            </h3>

            <p>
                Consulte los registros almacenados en la base
                de datos y gestione la información registrada.
            </p>

            <a class="boton"
               href="RegistroServlet">

                Consultar registros

            </a>

        </div>


        <!-- REPORTES -->

        <div class="tarjeta">

            <h3>
                Reportes
            </h3>

            <p>
                Módulo destinado a la generación y consulta
                de estadísticas sobre el uso de los laboratorios.
            </p>

            <a class="boton"
               href="reportes.jsp">

                Ver reportes

            </a>

        </div>


        <!-- CONFIGURACIÓN -->

        <div class="tarjeta">

            <h3>
                Configuración
            </h3>

            <p>
                Administración de las opciones y parámetros
                utilizados por el sistema.
            </p>

            <a class="boton"
               href="configuracion.jsp">

                Configuración

            </a>

        </div>


    </section>


</main>


<footer class="pie">

    Statistics System © 2026

</footer>


</body>

</html>