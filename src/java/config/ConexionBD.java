
package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase encargada de establecer la conexión
 * entre Statistics System y la base de datos MySQL.
 *
 * @author Edwin Pautt
 */
public class ConexionBD {

    // Parámetros de conexión a MySQL.
    private static final String URL =
            "jdbc:mysql://localhost:3306/statistics_system?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    private static final String USUARIO = "root";

    private static final String CONTRASENA = "";

    /**
     * Establece una conexión con la base de datos.
     *
     * @return objeto Connection si la conexión es exitosa;
     *         null si ocurre algún error.
     */
    public static Connection conectar() {

        Connection conexion = null;

        try {

            // Carga el controlador JDBC de MySQL.
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establece la conexión con la base de datos.
            conexion = DriverManager.getConnection(
                    URL,
                    USUARIO,
                    CONTRASENA
            );

            System.out.println(
                    "Conexión a MySQL establecida correctamente."
            );

        } catch (ClassNotFoundException e) {

            System.err.println(
                    "Error: no se encontró el controlador JDBC de MySQL."
            );

            e.printStackTrace();

        } catch (SQLException e) {

            System.err.println(
                    "Error al establecer conexión con la base de datos."
            );

            e.printStackTrace();
        }

        return conexion;
    }
}
