
package filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filtro encargado de proteger las páginas
 * privadas de Statistics System.
 *
 * @author Edwin Pautt
 */
@WebFilter("/*")
public class AutenticacionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig)
            throws ServletException {
    }

    @Override
    public void doFilter(
            jakarta.servlet.ServletRequest request,
            jakarta.servlet.ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String ruta = req.getRequestURI()
                .substring(req.getContextPath().length());

        // Permite acceder a la pantalla de inicio de sesión.
        if (ruta.equals("/login.jsp")
        || ruta.equals("/LoginServlet")
        || ruta.equals("/LogoutServlet")
        || ruta.startsWith("/img/")
        || ruta.startsWith("/css/")
        || ruta.startsWith("/js/")) {

            chain.doFilter(request, response);
            return;
        }

        HttpSession sesion = req.getSession(false);

        // Verifica que exista una sesión autenticada.
        if (sesion == null
                || sesion.getAttribute("usuario") == null) {

            res.sendRedirect(
                    req.getContextPath() + "/login.jsp"
            );

            return;
        }

        String rol = (String) sesion.getAttribute("rol");

        // Protege los módulos exclusivos del administrador.
        boolean esAdministrador = "ADMINISTRADOR".equals(rol);

if (!esAdministrador &&
        (ruta.equals("/configuracion.jsp")
        || ruta.equals("/editar.jsp"))) {

    res.sendRedirect(
            req.getContextPath() + "/index.jsp"
    );

    return;
}

        // Permite continuar con la solicitud autorizada.
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
