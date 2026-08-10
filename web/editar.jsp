<%@ page import="dao.RegistroDAO" %>
<%@ page import="model.Registro" %>

<%
    String idTexto = request.getParameter("id");

    Registro registro = null;

    if (idTexto != null) {
        try {

            int id = Integer.parseInt(idTexto);

            RegistroDAO dao = new RegistroDAO();

            registro = dao.consultarRegistro(id);

        } catch (Exception e) {

            e.printStackTrace();

        }
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>Editar registro - Statistics System</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f5f5f5;
        }

        .contenedor {
            background-color: white;
            padding: 30px;
            width: 500px;
            border-radius: 10px;
        }

        h1 {
            margin-bottom: 5px;
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
            padding: 10px 20px;
            margin-top: 10px;
            cursor: pointer;
        }

        .error {
            color: red;
            font-weight: bold;
        }

    </style>

</head>

<body>

<div class="contenedor">

    <h1>Statistics System</h1>

    <h2>Editar registro</h2>

<%
    if (registro != null) {
%>

    <form action="RegistroServlet" method="POST">

        <!-- Acción que realizará el Servlet -->

        <input type="hidden"
               name="accion"
               value="actualizar">

        <!-- ID del registro -->

        <input type="hidden"
               name="id"
               value="<%= registro.getId() %>">


        <label>Programa académico:</label>

        <br>

        <input type="text"
               name="programa"
               value="<%= registro.getPrograma() %>"
               required>

        <br><br>


        <label>Asignatura:</label>

        <br>

        <input type="text"
               name="asignatura"
               value="<%= registro.getAsignatura() %>"
               required>

        <br><br>


        <label>Docente:</label>

        <br>

        <input type="text"
               name="docente"
               value="<%= registro.getDocente() %>"
               required>

        <br><br>


        <label>Área:</label>

        <br>

        <input type="text"
               name="area"
               value="<%= registro.getArea() %>"
               required>

        <br><br>


        <label>Fecha:</label>

        <br>

        <input type="date"
               name="fecha"
               value="<%= registro.getFecha() %>"
               required>

        <br><br>


        <label>Horario:</label>

        <br>

        <input type="text"
               name="horario"
               value="<%= registro.getHorario() %>"
               required>

        <br><br>


        <label>Elementos utilizados:</label>

        <br>

        <textarea
            name="elementos"
            rows="4"
            required><%= registro.getElementos() %></textarea>

        <br><br>


        <button type="submit">
            Guardar cambios
        </button>

    </form>

    <br>

    <a href="RegistroServlet">
        Volver a registros
    </a>


<%
    } else {
%>

    <p class="error">
        No se encontró el registro solicitado.
    </p>

    <br>

    <a href="RegistroServlet">
        Volver a registros
    </a>

<%
    }
%>

</div>

</body>

</html>