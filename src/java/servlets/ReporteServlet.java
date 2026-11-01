
package servlets;

import dao.ReporteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;

/**
 * Controlador encargado de generar los reportes
 * estadísticos de Statistics System.
 *
 * @author Edwin Pautt
 */
@WebServlet("/ReporteServlet")
public class ReporteServlet extends HttpServlet {

    private ReporteDAO reporteDAO;

    @Override
    public void init() throws ServletException {
        reporteDAO = new ReporteDAO();
    }

    /**
     * Recibe los filtros y genera las estadísticas.
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String programa = request.getParameter("programa");
        String area = request.getParameter("area");
        String fechaInicial = request.getParameter("fechaInicial");
        String fechaFinal = request.getParameter("fechaFinal");

        // Validación de fechas.
        try {

            if (fechaInicial != null && !fechaInicial.isEmpty()) {
                LocalDate.parse(fechaInicial);
            }

            if (fechaFinal != null && !fechaFinal.isEmpty()) {
                LocalDate.parse(fechaFinal);
            }

            if (fechaInicial != null && !fechaInicial.isEmpty()
                    && fechaFinal != null && !fechaFinal.isEmpty()
                    && fechaInicial.compareTo(fechaFinal) > 0) {

                request.setAttribute(
                        "error",
                        "La fecha inicial no puede ser posterior a la fecha final."
                );

            } else {

                Map<String, Integer> indicadores =
                        reporteDAO.obtenerIndicadores(
                                programa, area, fechaInicial, fechaFinal
                        );

                Map<String, Integer> porArea =
                        reporteDAO.obtenerAgrupacion(
                                "area", programa, area, fechaInicial, fechaFinal
                        );

                Map<String, Integer> porPrograma =
                        reporteDAO.obtenerAgrupacion(
                                "programa", programa, area,
                                fechaInicial, fechaFinal
                        );

                Map<String, Integer> porAsignatura =
                        reporteDAO.obtenerAgrupacion(
                                "asignatura", programa, area,
                                fechaInicial, fechaFinal
                        );

                request.setAttribute("indicadores", indicadores);
                request.setAttribute("porArea", porArea);
                request.setAttribute("porPrograma", porPrograma);
                request.setAttribute("porAsignatura", porAsignatura);

            }

        } catch (java.time.format.DateTimeParseException e) {

            request.setAttribute(
                    "error",
                    "El formato de las fechas no es válido."
            );
        }

        // Conserva los filtros para mostrarlos nuevamente.
        request.setAttribute("filtroPrograma", programa);
        request.setAttribute("filtroArea", area);
        request.setAttribute("filtroFechaInicial", fechaInicial);
        request.setAttribute("filtroFechaFinal", fechaFinal);

        request.getRequestDispatcher("/reportes.jsp")
                .forward(request, response);
    }
}
