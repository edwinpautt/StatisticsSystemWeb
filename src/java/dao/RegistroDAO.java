package dao;

import config.ConexionBD;
import model.Registro;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RegistroDAO {

    // INSERTAR
    public boolean insertarRegistro(Registro registro) {

        String sql = "INSERT INTO registro_laboratorio "
                + "(programa, asignatura, docente, area, fecha, horario, elementos) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, registro.getPrograma());
            ps.setString(2, registro.getAsignatura());
            ps.setString(3, registro.getDocente());
            ps.setString(4, registro.getArea());
            ps.setDate(5, registro.getFecha());
            ps.setString(6, registro.getHorario());
            ps.setString(7, registro.getElementos());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al insertar registro:");
            e.printStackTrace();
            return false;
        }
    }

    // CONSULTAR TODOS
    public List<Registro> listarRegistros() {

        List<Registro> registros = new ArrayList<>();

        String sql = "SELECT * FROM registro_laboratorio ORDER BY id DESC";

        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Registro registro = new Registro();

                registro.setId(rs.getInt("id"));
                registro.setPrograma(rs.getString("programa"));
                registro.setAsignatura(rs.getString("asignatura"));
                registro.setDocente(rs.getString("docente"));
                registro.setArea(rs.getString("area"));
                registro.setFecha(rs.getDate("fecha"));
                registro.setHorario(rs.getString("horario"));
                registro.setElementos(rs.getString("elementos"));

                registros.add(registro);
            }

        } catch (SQLException e) {
            System.out.println("Error al consultar registros:");
            e.printStackTrace();
        }

        return registros;
    }

    // CONSULTAR POR ID
    public Registro consultarRegistro(int id) {

        String sql = "SELECT * FROM registro_laboratorio WHERE id = ?";

        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Registro registro = new Registro();

                    registro.setId(rs.getInt("id"));
                    registro.setPrograma(rs.getString("programa"));
                    registro.setAsignatura(rs.getString("asignatura"));
                    registro.setDocente(rs.getString("docente"));
                    registro.setArea(rs.getString("area"));
                    registro.setFecha(rs.getDate("fecha"));
                    registro.setHorario(rs.getString("horario"));
                    registro.setElementos(rs.getString("elementos"));

                    return registro;
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al consultar el registro:");
            e.printStackTrace();
        }

        return null;
    }

    // ACTUALIZAR
    public boolean actualizarRegistro(Registro registro) {

        String sql = "UPDATE registro_laboratorio SET "
                + "programa = ?, "
                + "asignatura = ?, "
                + "docente = ?, "
                + "area = ?, "
                + "fecha = ?, "
                + "horario = ?, "
                + "elementos = ? "
                + "WHERE id = ?";

        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, registro.getPrograma());
            ps.setString(2, registro.getAsignatura());
            ps.setString(3, registro.getDocente());
            ps.setString(4, registro.getArea());
            ps.setDate(5, registro.getFecha());
            ps.setString(6, registro.getHorario());
            ps.setString(7, registro.getElementos());
            ps.setInt(8, registro.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al actualizar registro:");
            e.printStackTrace();
            return false;
        }
    }

    // ELIMINAR
    public boolean eliminarRegistro(int id) {

        String sql = "DELETE FROM registro_laboratorio WHERE id = ?";

        try (Connection conexion = ConexionBD.conectar();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al eliminar registro:");
            e.printStackTrace();
            return false;
        }
    }
    
}