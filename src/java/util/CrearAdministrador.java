
package util;

import dao.UsuarioDAO;
import model.Usuario;

/**
 * Crea la cuenta inicial de administrador.
 *
 * Ejecutar una sola vez y después eliminar esta clase.
 */
public class CrearAdministrador {

    public static void main(String[] args) {

        UsuarioDAO dao = new UsuarioDAO();

        Usuario administrador = new Usuario(
                "Administrador del sistema",
                "admin",
                "CambiaEstaClave2026!",
                "ADMINISTRADOR"
        );

        boolean creado = dao.registrarUsuario(administrador);

        if (creado) {
            System.out.println(
                    "Administrador creado correctamente."
            );
        } else {
            System.out.println(
                    "No se pudo crear el administrador. "
                    + "Verifica si el usuario ya existe."
            );
        }
    }
}
