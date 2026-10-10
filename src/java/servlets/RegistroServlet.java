package servlets;

import dao.RegistroDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Registro;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * Servlet encargado de gestionar las operaciones relacionadas
 * con los registros de uso de los laboratorios de simulación clínica.
 *
 * Permite realizar las siguientes operaciones:
 * - Registrar información.
 * - Consultar registros.
 * - Actualizar registros.
 * - Eliminar registros.
 *
 * El Servlet recibe las solicitudes provenientes de las páginas JSP
 * y utiliza RegistroDAO para realizar las operaciones en la base de datos.
 *
 * @author Edwin Pautt
 */
@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    // Objeto utilizado para realizar las operaciones con la base de datos.
    private RegistroDAO registroDAO;

    /**
     * Inicializa el Servlet y crea la instancia del DAO.
     *
     * @throws ServletException si ocurre un error durante la inicialización.
     */
    @Override
    public void init() throws ServletException {
        registroDAO = new RegistroDAO();
    }

    /**
     * Procesa las solicitudes POST enviadas desde los formularios.
     *
     * Dependiendo de la acción recibida, permite insertar o actualizar
     * la información de un registro.
     *
     * @param request solicitud enviada por el cliente.
     * @param response respuesta enviada al cliente.
     * @throws ServletException si ocurre un error relacionado con el Servlet.
     * @throws IOException si ocurre un error de entrada o salida.
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Permite recibir correctamente caracteres especiales.
        request.setCharacterEncoding("UTF-8");

        // Obtiene la acción enviada desde el formulario.
        String accion = request.getParameter("accion");

        // Si no se especifica una acción, se realiza un nuevo registro.
        if (accion == null || accion.equals("insertar")) {

            insertar(request, response);

        } else if (accion.equals("actualizar")) {

            // Actualiza un registro existente.
            actualizar(request, response);

        } else {

            // Si la acción no es reconocida, se regresa al Servlet.
            response.sendRedirect(
                    request.getContextPath() + "/RegistroServlet"
            );
        }
    }

    /**
     * Registra un nuevo uso del laboratorio.
     *
     * Obtiene los datos enviados desde el formulario, crea un objeto
     * Registro y utiliza RegistroDAO para almacenarlo en la base de datos.
     *
     * @param request solicitud que contiene los datos del formulario.
     * @param response respuesta enviada al navegador.
     * @throws ServletException si ocurre un error durante el procesamiento.
     * @throws IOException si ocurre un error de entrada o salida.
     */
    private void insertar(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Obtiene los datos enviados desde el formulario.
        String programa = request.getParameter("programa");
        String asignatura = request.getParameter("asignatura");
        String docente = request.getParameter("docente");
        String area = request.getParameter("area");
        String fechaTexto = request.getParameter("fecha");
        String horario = request.getParameter("horario");
        String elementos = request.getParameter("elementos");

        try {

            // Convierte la fecha recibida a formato SQL.
            Date fecha = Date.valueOf(fechaTexto);

            // Crea el objeto con la información del registro.
            Registro registro = new Registro(
                    programa,
                    asignatura,
                    docente,
                    area,
                    fecha,
                    horario,
                    elementos
            );

            // Envía el registro al DAO para almacenarlo.
            boolean guardado = registroDAO.insertarRegistro(registro);

            if (guardado) {

                // Redirecciona mostrando un mensaje de confirmación.
                response.sendRedirect(
                        request.getContextPath()
                        + "/RegistroServlet?mensaje=Registro+guardado+correctamente"
                );

            } else {

                // Envía un mensaje de error a la página de registro.
                request.setAttribute(
                        "error",
                        "No fue posible guardar el registro."
                );

                request.getRequestDispatcher("registro.jsp")
                        .forward(request, response);
            }

        } catch (IllegalArgumentException e) {

            // Maneja errores relacionados con el formato de la fecha.
            request.setAttribute(
                    "error",
                    "La fecha ingresada no es válida."
            );

            request.getRequestDispatcher("registro.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Actualiza la información de un registro existente.
     *
     * Obtiene los datos modificados desde el formulario, crea el objeto
     * Registro y solicita al DAO actualizar la información en la base de datos.
     *
     * @param request solicitud que contiene los datos modificados.
     * @param response respuesta enviada al navegador.
     * @throws ServletException si ocurre un error durante el procesamiento.
     * @throws IOException si ocurre un error de entrada o salida.
     */
    private void actualizar(HttpServletRequest request,
                            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // Obtiene el identificador del registro que se va a actualizar.
            int id = Integer.parseInt(
                    request.getParameter("id")
            );

            // Obtiene los nuevos datos enviados desde el formulario.
            String programa = request.getParameter("programa");
            String asignatura = request.getParameter("asignatura");
            String docente = request.getParameter("docente");
            String area = request.getParameter("area");
            String fechaTexto = request.getParameter("fecha");
            String horario = request.getParameter("horario");
            String elementos = request.getParameter("elementos");

            // Convierte la fecha al formato utilizado por MySQL.
            Date fecha = Date.valueOf(fechaTexto);

            // Crea el objeto Registro que contiene la información actualizada.
            Registro registro = new Registro();

            registro.setId(id);
            registro.setPrograma(programa);
            registro.setAsignatura(asignatura);
            registro.setDocente(docente);
            registro.setArea(area);
            registro.setFecha(fecha);
            registro.setHorario(horario);
            registro.setElementos(elementos);

            // Solicita al DAO actualizar la información.
            boolean actualizado =
                    registroDAO.actualizarRegistro(registro);

            if (actualizado) {

                // Redirecciona mostrando el mensaje de actualización.
                response.sendRedirect(
                        request.getContextPath()
                        + "/RegistroServlet?mensaje=Registro+actualizado+correctamente"
                );

            } else {

                // Informa que no se pudo realizar la actualización.
                response.sendRedirect(
                        request.getContextPath()
                        + "/RegistroServlet?mensaje=No+se+actualizo+el+registro"
                );
            }

        } catch (Exception e) {

            // Muestra información del error en la consola del servidor.
            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/RegistroServlet?mensaje=Error+al+actualizar"
            );
        }
    }

    /**
     * Procesa las solicitudes GET del sistema.
     *
     * Permite eliminar registros y consultar la información almacenada.
     *
     * @param request solicitud enviada por el cliente.
     * @param response respuesta enviada al cliente.
     * @throws ServletException si ocurre un error durante el procesamiento.
     * @throws IOException si ocurre un error de entrada o salida.
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Obtiene la acción solicitada.
        String accion = request.getParameter("accion");

        // =====================================================
        // ELIMINAR REGISTRO
        // =====================================================

        if ("eliminar".equals(accion)) {

            try {

                // Obtiene el ID del registro que se desea eliminar.
                int id = Integer.parseInt(
                        request.getParameter("id")
                );

                // Solicita al DAO eliminar el registro.
                boolean eliminado =
                        registroDAO.eliminarRegistro(id);

                if (eliminado) {

                    // Redirecciona mostrando el mensaje de confirmación.
                    response.sendRedirect(
                            request.getContextPath()
                            + "/RegistroServlet?mensaje=Registro+eliminado+correctamente"
                    );

                } else {

                    // Informa que el registro no fue encontrado.
                    response.sendRedirect(
                            request.getContextPath()
                            + "/RegistroServlet?mensaje=No+se+encontro+el+registro"
                    );
                }

            } catch (Exception e) {

                // Muestra el error en la consola del servidor.
                e.printStackTrace();

                response.sendRedirect(
                        request.getContextPath()
                        + "/RegistroServlet?mensaje=Error+al+eliminar"
                );
            }

            // Finaliza el proceso de eliminación.
            return;
        }

        // =====================================================
        // CONSULTAR REGISTROS
        // =====================================================

        // Obtiene todos los registros almacenados en la base de datos.
        List<Registro> registros =
                registroDAO.listarRegistros();

        // Envía la lista de registros a la página JSP.
        request.setAttribute(
                "registros",
                registros
        );

        // Muestra los registros en la interfaz.
        request.getRequestDispatcher(
                "registro.jsp"
        ).forward(request, response);
    }
}