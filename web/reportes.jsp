<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>Reportes - Statistics System</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
        }

        header {
            background-color: #1f4e78;
            color: white;
            padding: 25px 40px;
        }

        .contenedor {
            width: 90%;
            max-width: 1100px;
            margin: 40px auto;
        }

        .tarjeta {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 25px;
        }

        .filtros {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        label {
            font-weight: bold;
        }

        input,
        select {
            width: 100%;
            padding: 9px;
            margin-top: 6px;
            box-sizing: border-box;
        }

        button,
        .boton {
            display: inline-block;
            padding: 10px 18px;
            margin-top: 20px;
            background-color: #1f4e78;
            color: white;
            border: none;
            text-decoration: none;
            cursor: pointer;
            border-radius: 5px;
        }

        .informacion {
            line-height: 1.6;
        }

        @media (max-width: 700px) {

            .filtros {
                grid-template-columns: 1fr;
            }

        }

    </style>

</head>

<body>

<header>

    <h1>Statistics System</h1>

    <p>Reportes del uso de laboratorios</p>

</header>


<div class="contenedor">


    <div class="tarjeta">

        <h2>Generación de reportes</h2>

        <p class="informacion">

            Este módulo permitirá consultar estadísticas
            relacionadas con el uso de los laboratorios
            de simulación clínica.

        </p>


        <form>

            <div class="filtros">

                <div>

                    <label>
                        Programa académico:
                    </label>

                    <select name="programa">

                        <option value="">
                            Todos
                        </option>

                        <option>
                            Medicina
                        </option>

                        <option>
                            Enfermería
                        </option>

                        <option>
                            Fisioterapia
                        </option>

                    </select>

                </div>


                <div>

                    <label>
                        Área:
                    </label>

                    <select name="area">

                        <option value="">
                            Todas
                        </option>

                        <option>
                            Urgencias
                        </option>

                        <option>
                            Hospitalización
                        </option>

                        <option>
                            Simulación clínica
                        </option>

                    </select>

                </div>


                <div>

                    <label>
                        Fecha inicial:
                    </label>

                    <input type="date"
                           name="fechaInicial">

                </div>


                <div>

                    <label>
                        Fecha final:
                    </label>

                    <input type="date"
                           name="fechaFinal">

                </div>

            </div>


            <button type="submit">
                Generar reporte
            </button>

        </form>

    </div>


    <div class="tarjeta">

        <h2>Estadísticas disponibles</h2>

        <ul>

            <li>
                Número de registros por período.
            </li>

            <li>
                Frecuencia de uso por asignatura.
            </li>

            <li>
                Frecuencia de uso por programa académico.
            </li>

            <li>
                Uso de las diferentes áreas del laboratorio.
            </li>

            <li>
                Elementos utilizados durante las prácticas.
            </li>

        </ul>

    </div>


    <a class="boton"
       href="index.jsp">

        Volver al inicio

    </a>

</div>

</body>

</html>