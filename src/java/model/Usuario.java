
package model;

/**
 * Modelo que representa los usuarios de Statistics System.
 *
 * Contiene la información de identificación,
 * credenciales, rol y estado de cada usuario.
 *
 * @author Edwin Pautt
 */
public class Usuario {

    private int id;
    private String nombre;
    private String usuario;
    private String contrasena;
    private String rol;
    private String estado;

    // Constructor vacío.
    public Usuario() {
    }

    // Constructor completo.
    public Usuario(int id, String nombre, String usuario,
                   String contrasena, String rol, String estado) {

        this.id = id;
        this.nombre = nombre;
        this.usuario = usuario;
        this.contrasena = contrasena;
        this.rol = rol;
        this.estado = estado;
    }

    // Constructor para registrar usuarios.
    public Usuario(String nombre, String usuario,
                   String contrasena, String rol) {

        this.nombre = nombre;
        this.usuario = usuario;
        this.contrasena = contrasena;
        this.rol = rol;
        this.estado = "ACTIVO";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
