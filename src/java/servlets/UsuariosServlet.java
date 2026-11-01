

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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/UsuariosServlet")
public class UsuariosServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }

    private boolean esAdministrador(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        String rol = (String) session.getAttribute("rol");
        return "ADMINISTRADOR".equalsIgnoreCase(rol);
    }

    private void redireccionar(
            HttpServletRequest request,
            HttpServletResponse response,
            String mensaje) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/UsuariosServlet?mensaje="
                + URLEncoder.encode(mensaje, StandardCharsets.UTF_8)
        );
    }

    private void redireccionarCrear(
            HttpServletRequest request,
            HttpServletResponse response,
            String mensaje) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/crearUsuario.jsp?mensaje="
                + URLEncoder.encode(mensaje, StandardCharsets.UTF_8)
        );
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdministrador(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "No tienes permisos para administrar usuarios.");
            return;
        }

        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {

            try {
                int id = Integer.parseInt(request.getParameter("id"));

                Usuario usuario = usuarioDAO.consultarUsuario(id);

                if (usuario == null) {
                    redireccionar(request, response,
                            "No se encontró el usuario.");
                    return;
                }

                request.setAttribute("usuarioEditar", usuario);

                request.getRequestDispatcher(
                        "/editarUsuario.jsp"
                ).forward(request, response);

                return;

            } catch (NumberFormatException e) {
                redireccionar(request, response,
                        "Identificador de usuario no válido.");
                return;
            }
        }

        List<Usuario> usuarios = usuarioDAO.listarUsuarios();

        request.setAttribute("usuarios", usuarios);

        request.getRequestDispatcher(
                "/usuarios.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!esAdministrador(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "No tienes permisos para realizar esta operación.");
            return;
        }

        String accion = request.getParameter("accion");

        if (accion == null) {
            redireccionar(request, response,
                    "Operación no especificada.");
            return;
        }

        // REGISTRAR NUEVO USUARIO
        if ("crear".equals(accion)) {

            String nombre = request.getParameter("nombre");
            String nombreUsuario = request.getParameter("usuario");
            String contrasena = request.getParameter("contrasena");
            String rol = request.getParameter("rol");

            if (nombre == null || nombreUsuario == null
                    || contrasena == null || rol == null
                    || nombre.trim().isEmpty()
                    || nombreUsuario.trim().isEmpty()
                    || contrasena.length() < 8
                    || !validarRol(rol)) {

                redireccionarCrear(request, response,
                        "Verifica los datos. La contraseña debe tener mínimo 8 caracteres.");
                return;
            }

            Usuario nuevoUsuario = new Usuario();

            nuevoUsuario.setNombre(nombre.trim());
            nuevoUsuario.setUsuario(nombreUsuario.trim());
            nuevoUsuario.setContrasena(contrasena);
            nuevoUsuario.setRol(rol);
            nuevoUsuario.setEstado("ACTIVO");

            boolean registrado =
                    usuarioDAO.registrarUsuario(nuevoUsuario);

            if (registrado) {
                redireccionar(request, response,
                        "Usuario registrado correctamente.");
            } else {
                redireccionarCrear(request, response,
                        "No fue posible registrar el usuario. Verifica que el nombre de usuario no esté ocupado.");
            }

            return;
        }

        // LAS DEMÁS OPERACIONES REQUIEREN UN ID
        try {

            int id = Integer.parseInt(request.getParameter("id"));

            switch (accion) {

                case "actualizar":

                    Usuario usuario = new Usuario();

                    usuario.setId(id);
                    usuario.setNombre(request.getParameter("nombre"));
                    usuario.setUsuario(request.getParameter("usuario"));
                    usuario.setRol(request.getParameter("rol"));
                    usuario.setEstado(request.getParameter("estado"));

                    if (usuario.getNombre() == null
                            || usuario.getUsuario() == null
                            || usuario.getNombre().trim().isEmpty()
                            || usuario.getUsuario().trim().isEmpty()
                            || !validarRol(usuario.getRol())
                            || !validarEstado(usuario.getEstado())) {

                        redireccionar(request, response,
                                "Verifica los datos ingresados.");
                        return;
                    }

                    boolean actualizado =
                            usuarioDAO.actualizarUsuario(usuario);

                    redireccionar(request, response,
                            actualizado
                            ? "Usuario actualizado correctamente."
                            : "No fue posible actualizar el usuario.");

                    break;

                case "estado":

                    String estado = request.getParameter("estado");

                    if (!validarEstado(estado)) {
                        redireccionar(request, response,
                                "Estado no válido.");
                        return;
                    }

                    boolean cambiado =
                            usuarioDAO.cambiarEstadoUsuario(id, estado);

                    redireccionar(request, response,
                            cambiado
                            ? "Estado del usuario actualizado."
                            : "No fue posible cambiar el estado.");

                    break;

                case "contrasena":

                    String nuevaContrasena =
                            request.getParameter("contrasena");

                    if (nuevaContrasena == null
                            || nuevaContrasena.length() < 8) {

                        redireccionar(request, response,
                                "La contraseña debe tener al menos 8 caracteres.");
                        return;
                    }

                    boolean cambiada =
                            usuarioDAO.cambiarContrasena(id, nuevaContrasena);

                    redireccionar(request, response,
                            cambiada
                            ? "Contraseña actualizada correctamente."
                            : "No fue posible cambiar la contraseña.");

                    break;

                default:

                    redireccionar(request, response,
                            "Operación no reconocida.");
            }

        } catch (NumberFormatException e) {

            redireccionar(request, response,
                    "Identificador de usuario no válido.");

        } catch (Exception e) {

            e.printStackTrace();

            redireccionar(request, response,
                    "Ocurrió un error al procesar la operación.");
        }
    }

    private boolean validarRol(String rol) {
        return "ADMINISTRADOR".equals(rol)
                || "USUARIO".equals(rol);
    }

    private boolean validarEstado(String estado) {
        return "ACTIVO".equals(estado)
                || "INACTIVO".equals(estado);
    }
}
