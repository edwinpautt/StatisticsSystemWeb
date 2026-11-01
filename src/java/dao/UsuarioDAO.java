
package dao;

import config.ConexionBD;
import model.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.security.SecureRandom;
import java.security.spec.KeySpec;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import java.util.Base64;

import java.util.List;
import java.util.ArrayList;

/**
 * DAO encargado de gestionar los usuarios
 * y validar el acceso a Statistics System.
 *
 * Las contraseñas se almacenan mediante PBKDF2.
 *
 * @author Edwin Pautt
 */
public class UsuarioDAO {

    private static final int ITERACIONES = 210000;
    private static final int LONGITUD_CLAVE = 256;

    /**
     * Genera un hash seguro de la contraseña.
     */
    public static String generarHash(String contrasena)
            throws Exception {

        byte[] salt = new byte[16];

        SecureRandom random = new SecureRandom();
        random.nextBytes(salt);

        KeySpec spec = new PBEKeySpec(
                contrasena.toCharArray(),
                salt,
                ITERACIONES,
                LONGITUD_CLAVE
        );

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

        byte[] hash = factory.generateSecret(spec).getEncoded();

        return ITERACIONES + ":"
                + Base64.getEncoder().encodeToString(salt) + ":"
                + Base64.getEncoder().encodeToString(hash);
    }

    /**
     * Comprueba una contraseña contra su hash almacenado.
     */
    private boolean verificarContrasena(
            String contrasena, String hashAlmacenado) {

        try {

            String[] partes = hashAlmacenado.split(":");

            if (partes.length != 3) {
                return false;
            }

            int iteraciones = Integer.parseInt(partes[0]);

            byte[] salt = Base64.getDecoder().decode(partes[1]);
            byte[] hashOriginal = Base64.getDecoder().decode(partes[2]);

            KeySpec spec = new PBEKeySpec(
                    contrasena.toCharArray(),
                    salt,
                    iteraciones,
                    hashOriginal.length * 8
            );

            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            byte[] hashNuevo = factory.generateSecret(spec).getEncoded();

            return java.security.MessageDigest.isEqual(
                    hashOriginal,
                    hashNuevo
            );

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Valida el usuario y contraseña.
     * Solo permite el ingreso de cuentas activas.
     */
    public Usuario validarUsuario(String nombreUsuario,
                                  String contrasena) {

        String sql = "SELECT * FROM usuarios "
                + "WHERE usuario = ? AND estado = 'ACTIVO'";

        try (Connection conexion = ConexionBD.conectar()) {

            if (conexion == null) {
                return null;
            }

            try (PreparedStatement ps =
                    conexion.prepareStatement(sql)) {

                ps.setString(1, nombreUsuario);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        String hash = rs.getString("contrasena");

                        if (verificarContrasena(contrasena, hash)) {

                            Usuario usuario = new Usuario();

                            usuario.setId(rs.getInt("id"));
                            usuario.setNombre(rs.getString("nombre"));
                            usuario.setUsuario(rs.getString("usuario"));
                            usuario.setRol(rs.getString("rol"));
                            usuario.setEstado(rs.getString("estado"));

                            return usuario;
                        }
                    }
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al validar usuario:");
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Registra un nuevo usuario en la base de datos.
     */
    public boolean registrarUsuario(Usuario usuario) {

        String sql = "INSERT INTO usuarios "
                + "(nombre, usuario, contrasena, rol, estado) "
                + "VALUES (?, ?, ?, ?, ?)";

        try {

            // Nunca se almacena la contraseña original.
            String hash = generarHash(usuario.getContrasena());

            try (Connection conexion = ConexionBD.conectar()) {

                if (conexion == null) {
                    return false;
                }

                try (PreparedStatement ps =
                        conexion.prepareStatement(sql)) {

                    ps.setString(1, usuario.getNombre());
                    ps.setString(2, usuario.getUsuario());
                    ps.setString(3, hash);
                    ps.setString(4, usuario.getRol());
                    ps.setString(5, usuario.getEstado());

                    return ps.executeUpdate() > 0;
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al registrar usuario:");
            e.printStackTrace();
            return false;

        } catch (Exception e) {
            System.out.println("Error al generar contraseña segura:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Consulta todos los usuarios registrados.
     */
    public List<Usuario> listarUsuarios() {

        List<Usuario> usuarios = new ArrayList<>();

        String sql = "SELECT id, nombre, usuario, rol, estado "
                   + "FROM usuarios ORDER BY id DESC";

        try (Connection conexion = ConexionBD.conectar()) {

            if (conexion == null) {
                return usuarios;
            }

            try (PreparedStatement ps = conexion.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Usuario usuario = new Usuario();

                    usuario.setId(rs.getInt("id"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setUsuario(rs.getString("usuario"));
                    usuario.setRol(rs.getString("rol"));
                    usuario.setEstado(rs.getString("estado"));

                    usuarios.add(usuario);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al listar usuarios:");
            e.printStackTrace();
        }

        return usuarios;
    }

    /**
     * Busca un usuario por su identificador.
     */
    public Usuario consultarUsuario(int id) {

        String sql = "SELECT id, nombre, usuario, rol, estado "
                   + "FROM usuarios WHERE id = ?";

        try (Connection conexion = ConexionBD.conectar()) {

            if (conexion == null) {
                return null;
            }

            try (PreparedStatement ps = conexion.prepareStatement(sql)) {

                ps.setInt(1, id);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {

                        Usuario usuario = new Usuario();

                        usuario.setId(rs.getInt("id"));
                        usuario.setNombre(rs.getString("nombre"));
                        usuario.setUsuario(rs.getString("usuario"));
                        usuario.setRol(rs.getString("rol"));
                        usuario.setEstado(rs.getString("estado"));

                        return usuario;
                    }
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al consultar usuario:");
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Actualiza los datos generales de un usuario.
     * No modifica su contraseña.
     */
    public boolean actualizarUsuario(Usuario usuario) {

        String sql = "UPDATE usuarios SET "
                   + "nombre = ?, usuario = ?, rol = ?, estado = ? "
                   + "WHERE id = ?";

        try (Connection conexion = ConexionBD.conectar()) {

            if (conexion == null) {
                return false;
            }

            try (PreparedStatement ps = conexion.prepareStatement(sql)) {

                ps.setString(1, usuario.getNombre());
                ps.setString(2, usuario.getUsuario());
                ps.setString(3, usuario.getRol());
                ps.setString(4, usuario.getEstado());
                ps.setInt(5, usuario.getId());

                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error al actualizar usuario:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Activa o desactiva una cuenta.
     */
    public boolean cambiarEstadoUsuario(int id, String estado) {

        if (!"ACTIVO".equals(estado) && !"INACTIVO".equals(estado)) {
            return false;
        }

        String sql = "UPDATE usuarios SET estado = ? WHERE id = ?";

        try (Connection conexion = ConexionBD.conectar()) {

            if (conexion == null) {
                return false;
            }

            try (PreparedStatement ps = conexion.prepareStatement(sql)) {

                ps.setString(1, estado);
                ps.setInt(2, id);

                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            System.out.println("Error al cambiar estado del usuario:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cambia la contraseña de un usuario.
     * La nueva contraseña se almacena mediante PBKDF2.
     */
    public boolean cambiarContrasena(int id, String nuevaContrasena) {

        if (nuevaContrasena == null || nuevaContrasena.length() < 8) {
            return false;
        }

        String sql = "UPDATE usuarios SET contrasena = ? WHERE id = ?";

        try {

            String hash = generarHash(nuevaContrasena);

            try (Connection conexion = ConexionBD.conectar()) {

                if (conexion == null) {
                    return false;
                }

                try (PreparedStatement ps = conexion.prepareStatement(sql)) {

                    ps.setString(1, hash);
                    ps.setInt(2, id);

                    return ps.executeUpdate() > 0;
                }
            }

        } catch (Exception e) {
            System.out.println("Error al cambiar contraseña:");
            e.printStackTrace();
            return false;
        }
    }
}
