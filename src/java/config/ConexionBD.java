package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {

    private static final String URL =
            "jdbc:mysql://localhost:3306/statistics_system";

    private static final String USUARIO = "root";

    private static final String CONTRASENA = "";

    public static Connection conectar() {
        Connection conexion = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conexion = DriverManager.getConnection(
                    URL,
                    USUARIO,
                    CONTRASENA
            );

            System.out.println("Conexión a MySQL exitosa.");

        } catch (ClassNotFoundException e) {
            System.out.println("No se encontró el controlador JDBC.");
            e.printStackTrace();

        } catch (SQLException e) {
            System.out.println("Error al conectar con MySQL.");
            e.printStackTrace();
        }

        return conexion;
    }
}