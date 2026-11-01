
package servlets;

import dao.UsuarioDAO;
import model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controlador encargado de autenticar
 * los usuarios de Statistics System.
 *
 * @author Edwin Pautt
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }

    /**
     * Procesa las credenciales enviadas desde login.jsp.
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");

        if (usuario == null || contrasena == null
                || usuario.trim().isEmpty()
                || contrasena.isEmpty()) {

            request.setAttribute(
                    "error",
                    "Debes ingresar usuario y contraseña."
            );

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);

            return;
        }

        // Comprueba las credenciales en MySQL.
        Usuario usuarioValidado =
                usuarioDAO.validarUsuario(usuario.trim(), contrasena);

        if (usuarioValidado != null) {

            // Evita reutilizar una sesión anterior.
            HttpSession sesionAnterior = request.getSession(false);

            if (sesionAnterior != null) {
                sesionAnterior.invalidate();
            }

            // Crea una nueva sesión autenticada.
            HttpSession sesion = request.getSession(true);

            sesion.setAttribute("usuario", usuarioValidado.getUsuario());
            sesion.setAttribute("nombre", usuarioValidado.getNombre());
            sesion.setAttribute("rol", usuarioValidado.getRol());
            sesion.setAttribute("idUsuario", usuarioValidado.getId());

            // Tiempo máximo de inactividad: 30 minutos.
            sesion.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(
                    request.getContextPath() + "/index.jsp"
            );

        } else {

            request.setAttribute(
                    "error",
                    "Usuario o contraseña incorrectos, o cuenta inactiva."
            );

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Evita utilizar GET para autenticar usuarios.
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
    }
}
