<%@ page import="java.util.List" %>
<%@ page import="model.Registro" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>Statistics System - Registro</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f5f5f5;
        }

        h1 {
            margin-bottom: 5px;
        }

        .contenedor {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
        }

        form {
            width: 450px;
        }

        label {
            font-weight: bold;
        }

        input,
        textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
        }

        button {
            padding: 8px 15px;
            cursor: pointer;
            margin: 3px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 30px;
            background-color: white;
        }

        th,
        td {
            border: 1px solid #999;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #eeeeee;
        }

        .mensaje {
            padding: 10px;
            margin: 15px 0;
            border: 1px solid #999;
            background-color: #eeeeee;
        }

        .acciones {
            white-space: nowrap;
        }

    </style>

</head>

<body>

<div class="contenedor">

    <h1>Statistics System</h1>

    <h2>Registro de uso del laboratorio</h2>


    <!-- ================================================= -->
    <!-- MENSAJE -->
    <!-- ================================================= -->

    <%
        String mensaje = request.getParameter("mensaje");

        if (mensaje != null) {
    %>

        <div class="mensaje">

            <strong>
                <%= mensaje %>
            </strong>

        </div>

    <%
        }
    %>


    <!-- ================================================= -->
    <!-- FORMULARIO PARA INSERTAR -->
    <!-- ================================================= -->

    <h3>Nuevo registro</h3>

    <form action="RegistroServlet" method="POST">

        <input type="hidden"
               name="accion"
               value="insertar">


        <label>
            Programa académico:
        </label>

        <br>

        <input type="text"
               name="programa"
               required>

        <br><br>


        <label>
            Asignatura:
        </label>

        <br>

        <input type="text"
               name="asignatura"
               required>

        <br><br>


        <label>
            Docente:
        </label>

        <br>

        <input type="text"
               name="docente"
               required>

        <br><br>


        <label>
            Área:
        </label>

        <br>

        <input type="text"
               name="area"
               required>

        <br><br>


        <label>
            Fecha:
        </label>

        <br>

        <input type="date"
               name="fecha"
               required>

        <br><br>


        <label>
            Horario:
        </label>

        <br>

        <input type="text"
               name="horario"
               required>

        <br><br>


        <label>
            Elementos utilizados:
        </label>

        <br>

        <textarea
            name="elementos"
            rows="4"
            required></textarea>

        <br><br>


        <button type="submit">
            Registrar uso
        </button>

    </form>


    <hr>


    <!-- ================================================= -->
    <!-- CONSULTAR REGISTROS -->
    <!-- ================================================= -->

    <h2>
        Registros del laboratorio
    </h2>


    <a href="RegistroServlet">

        <button type="button">
            Consultar registros
        </button>

    </a>


    <%
        List<Registro> registros =
                (List<Registro>) request.getAttribute("registros");

        if (registros != null && !registros.isEmpty()) {
    %>


    <!-- ================================================= -->
    <!-- TABLA -->
    <!-- ================================================= -->

    <table>

        <thead>

            <tr>

                <th>
                    ID
                </th>

                <th>
                    Programa
                </th>

                <th>
                    Asignatura
                </th>

                <th>
                    Docente
                </th>

                <th>
                    Área
                </th>

                <th>
                    Fecha
                </th>

                <th>
                    Horario
                </th>

                <th>
                    Elementos utilizados
                </th>

                <th>
                    Acciones
                </th>

            </tr>

        </thead>


        <tbody>

        <%
            for (Registro registro : registros) {
        %>

            <tr>

                <td>
                    <%= registro.getId() %>
                </td>

                <td>
                    <%= registro.getPrograma() %>
                </td>

                <td>
                    <%= registro.getAsignatura() %>
                </td>

                <td>
                    <%= registro.getDocente() %>
                </td>

                <td>
                    <%= registro.getArea() %>
                </td>

                <td>
                    <%= registro.getFecha() %>
                </td>

                <td>
                    <%= registro.getHorario() %>
                </td>

                <td>
                    <%= registro.getElementos() %>
                </td>


                <!-- ===================================== -->
                <!-- BOTONES -->
                <!-- ===================================== -->

                <td class="acciones">


                    <!-- EDITAR -->

                    <a href="editar.jsp?id=<%= registro.getId() %>">

                        <button type="button">
                            Editar
                        </button>

                    </a>


                    <!-- ELIMINAR -->

                    <a
                        href="RegistroServlet?accion=eliminar&id=<%= registro.getId() %>"
                        onclick="return confirm('¿Está seguro de eliminar este registro?');"
                    >

                        <button type="button">
                            Eliminar
                        </button>

                    </a>


                </td>

            </tr>

        <%
            }
        %>

        </tbody>

    </table>


    <%
        } else {
    %>


        <p>
            No hay registros cargados.
            Presiona "Consultar registros".
        </p>


    <%
        }
    %>

</div>

</body>

</html>