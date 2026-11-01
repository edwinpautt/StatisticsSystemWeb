
package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controlador encargado de cerrar la sesión
 * del usuario en Statistics System.
 *
 * @author Edwin Pautt
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Recupera la sesión activa.
        HttpSession sesion = request.getSession(false);

        if (sesion != null) {

            // Destruye la sesión del usuario.
            sesion.invalidate();
        }

        // Regresa a la pantalla de acceso.
        response.sendRedirect(
                request.getContextPath() + "/login.jsp?cerrada=true"
        );
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendError(
                HttpServletResponse.SC_METHOD_NOT_ALLOWED
        );
    }
}
