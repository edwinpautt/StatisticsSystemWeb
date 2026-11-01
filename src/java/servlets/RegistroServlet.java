
package servlets;

import dao.RegistroDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Registro;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.util.List;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    private RegistroDAO registroDAO;

    @Override
    public void init() throws ServletException {
        registroDAO = new RegistroDAO();
    }

    // Verifica que exista una sesión activa.
    private boolean tieneSesion(HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        return session != null
                && session.getAttribute("usuario") != null;
    }

    // Verifica si el usuario es administrador.
    private boolean esAdministrador(HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        String rol = (String) session.getAttribute("rol");

        return "ADMINISTRADOR".equalsIgnoreCase(rol);
    }

    // Redirecciona mostrando un mensaje.
    private void redireccionar(
            HttpServletRequest request,
            HttpServletResponse response,
            String destino,
            String mensaje) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + destino
                + "?mensaje="
                + URLEncoder.encode(mensaje, StandardCharsets.UTF_8)
        );
    }

    // ==========================================
    // PROCESAR REGISTROS
    // ==========================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!tieneSesion(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String accion = request.getParameter("accion");

        if (accion == null) {
            redireccionar(
                    request, response,
                    "/registro.jsp",
                    "Operación no especificada."
            );
            return;
        }

        // Solo el administrador puede editar o eliminar.
        if ("actualizar".equals(accion)
                || "eliminar".equals(accion)) {

            if (!esAdministrador(request)) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "No tienes permisos para modificar o eliminar registros."
                );
                return;
            }
        }

        switch (accion) {

            case "insertar":
                insertar(request, response);
                break;

            case "actualizar":
                actualizar(request, response);
                break;

            case "eliminar":
                eliminar(request, response);
                break;

            default:
                redireccionar(
                        request, response,
                        "/registro.jsp",
                        "Operación no reconocida."
                );
        }
    }

    // ==========================================
    // INSERTAR REGISTRO
    // ==========================================

    private void insertar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String programa = request.getParameter("programa");
        String asignatura = request.getParameter("asignatura");
        String docente = request.getParameter("docente");
        String area = request.getParameter("area");
        String fechaTexto = request.getParameter("fecha");
        String horario = request.getParameter("horario");
        String elementos = request.getParameter("elementos");

        try {

            Date fecha = Date.valueOf(fechaTexto);

            Registro registro = new Registro(
                    programa,
                    asignatura,
                    docente,
                    area,
                    fecha,
                    horario,
                    elementos
            );

            boolean guardado =
                    registroDAO.insertarRegistro(registro);

            redireccionar(
                    request,
                    response,
                    "/registro.jsp",
                    guardado
                    ? "Registro guardado correctamente."
                    : "No fue posible guardar el registro."
            );

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                    "error",
                    "La fecha ingresada no es válida."
            );

            request.getRequestDispatcher("/registro.jsp")
                    .forward(request, response);
        }
    }

    // ==========================================
    // ACTUALIZAR REGISTRO
    // ==========================================

    private void actualizar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(
                    request.getParameter("id")
            );

            String programa = request.getParameter("programa");
            String asignatura = request.getParameter("asignatura");
            String docente = request.getParameter("docente");
            String area = request.getParameter("area");
            String fechaTexto = request.getParameter("fecha");
            String horario = request.getParameter("horario");
            String elementos = request.getParameter("elementos");

            Date fecha = Date.valueOf(fechaTexto);

            Registro registro = new Registro();

            registro.setId(id);
            registro.setPrograma(programa);
            registro.setAsignatura(asignatura);
            registro.setDocente(docente);
            registro.setArea(area);
            registro.setFecha(fecha);
            registro.setHorario(horario);
            registro.setElementos(elementos);

            boolean actualizado =
                    registroDAO.actualizarRegistro(registro);

            redireccionar(
                    request,
                    response,
                    "/RegistroServlet",
                    actualizado
                    ? "Registro actualizado correctamente."
                    : "No se actualizó el registro."
            );

        } catch (Exception e) {

            e.printStackTrace();

            redireccionar(
                    request,
                    response,
                    "/RegistroServlet",
                    "Error al actualizar el registro."
            );
        }
    }

    // ==========================================
    // ELIMINAR REGISTRO
    // ==========================================

    private void eliminar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(
                    request.getParameter("id")
            );

            boolean eliminado =
                    registroDAO.eliminarRegistro(id);

            redireccionar(
                    request,
                    response,
                    "/RegistroServlet",
                    eliminado
                    ? "Registro eliminado correctamente."
                    : "No se encontró el registro."
            );

        } catch (NumberFormatException e) {

            redireccionar(
                    request,
                    response,
                    "/RegistroServlet",
                    "Identificador no válido."
            );
        }
    }

    // ==========================================
    // CONSULTAR REGISTROS
    // ==========================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!tieneSesion(request)) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        List<Registro> registros =
                registroDAO.listarRegistros();

        request.setAttribute("registros", registros);

        // Ahora la consulta abre una página independiente.
        request.getRequestDispatcher(
                "/consultarRegistros.jsp"
        ).forward(request, response);
    }
}
