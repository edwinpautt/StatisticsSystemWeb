package config;

import java.sql.Connection;

public class PruebaConexion {

    public static void main(String[] args) {

        Connection conexion = ConexionBD.conectar();

        if (conexion != null) {
            System.out.println("================================");
            System.out.println("CONEXIÓN CORRECTA");
            System.out.println("Statistics System conectado a MySQL");
            System.out.println("================================");

            try {
                conexion.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else {
            System.out.println("================================");
            System.out.println("ERROR DE CONEXIÓN");
            System.out.println("No se pudo conectar a MySQL");
            System.out.println("================================");
        }
    }
}