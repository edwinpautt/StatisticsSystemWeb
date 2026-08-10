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

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    private RegistroDAO registroDAO;

    @Override
    public void init() throws ServletException {
        registroDAO = new RegistroDAO();
    }

    // =====================================================
    // MÉTODO POST
    // =====================================================
    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        // Si no se especifica acción, se realiza INSERT
        if (accion == null || accion.equals("insertar")) {

            insertar(request, response);

        } else if (accion.equals("actualizar")) {

            actualizar(request, response);

        } else {

            response.sendRedirect(
                    request.getContextPath() + "/RegistroServlet"
            );
        }
    }

    // =====================================================
    // INSERTAR REGISTRO
    // =====================================================
    private void insertar(HttpServletRequest request,
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

            boolean guardado = registroDAO.insertarRegistro(registro);

            if (guardado) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/RegistroServlet?mensaje=Registro+guardado+correctamente"
                );

            } else {

                request.setAttribute(
                        "error",
                        "No fue posible guardar el registro."
                );

                request.getRequestDispatcher("registro.jsp")
                        .forward(request, response);
            }

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                    "error",
                    "La fecha ingresada no es válida."
            );

            request.getRequestDispatcher("registro.jsp")
                    .forward(request, response);
        }
    }

    // =====================================================
    // ACTUALIZAR REGISTRO
    // =====================================================
    private void actualizar(HttpServletRequest request,
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

            if (actualizado) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/RegistroServlet?mensaje=Registro+actualizado+correctamente"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/RegistroServlet?mensaje=No+se+actualizo+el+registro"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/RegistroServlet?mensaje=Error+al+actualizar"
            );
        }
    }

    // =====================================================
    // MÉTODO GET
    // =====================================================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        // =================================================
        // ELIMINAR
        // =================================================
        if ("eliminar".equals(accion)) {

            try {

                int id = Integer.parseInt(
                        request.getParameter("id")
                );

                boolean eliminado =
                        registroDAO.eliminarRegistro(id);

                if (eliminado) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/RegistroServlet?mensaje=Registro+eliminado+correctamente"
                    );

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/RegistroServlet?mensaje=No+se+encontro+el+registro"
                    );
                }

            } catch (Exception e) {

                e.printStackTrace();

                response.sendRedirect(
                        request.getContextPath()
                        + "/RegistroServlet?mensaje=Error+al+eliminar"
                );
            }

            return;
        }

        // =================================================
        // CONSULTAR REGISTROS
        // =================================================

        List<Registro> registros =
                registroDAO.listarRegistros();

        request.setAttribute(
                "registros",
                registros
        );

        request.getRequestDispatcher(
                "registro.jsp"
        ).forward(request, response);
    }
}