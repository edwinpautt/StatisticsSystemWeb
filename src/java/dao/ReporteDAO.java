
package dao;

import config.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * DAO encargado de consultar las estadísticas
 * de uso de los laboratorios de simulación clínica.
 *
 * @author Edwin Pautt
 */
public class ReporteDAO {

    /**
     * Construye los filtros utilizados en los reportes.
     */
    private String construirFiltros(String programa, String area,
                                    String fechaInicial, String fechaFinal) {

        StringBuilder sql = new StringBuilder(" WHERE 1=1 ");

        if (programa != null && !programa.isEmpty()) {
            sql.append(" AND programa = ? ");
        }

        if (area != null && !area.isEmpty()) {
            sql.append(" AND area = ? ");
        }

        if (fechaInicial != null && !fechaInicial.isEmpty()) {
            sql.append(" AND fecha >= ? ");
        }

        if (fechaFinal != null && !fechaFinal.isEmpty()) {
            sql.append(" AND fecha <= ? ");
        }

        return sql.toString();
    }

    /**
     * Asigna los valores de los filtros a la consulta SQL.
     */
    private int asignarFiltros(PreparedStatement ps, String programa,
                               String area, String fechaInicial,
                               String fechaFinal) throws SQLException {

        int posicion = 1;

        if (programa != null && !programa.isEmpty()) {
            ps.setString(posicion++, programa);
        }

        if (area != null && !area.isEmpty()) {
            ps.setString(posicion++, area);
        }

        if (fechaInicial != null && !fechaInicial.isEmpty()) {
            ps.setDate(posicion++, java.sql.Date.valueOf(fechaInicial));
        }

        if (fechaFinal != null && !fechaFinal.isEmpty()) {
            ps.setDate(posicion++, java.sql.Date.valueOf(fechaFinal));
        }

        return posicion;
    }

    /**
     * Obtiene los indicadores generales del reporte.
     */
    public Map<String, Integer> obtenerIndicadores(
            String programa, String area,
            String fechaInicial, String fechaFinal) {

        Map<String, Integer> indicadores = new LinkedHashMap<>();

        String sql = "SELECT COUNT(*) AS total, "
                + "COUNT(DISTINCT area) AS areas, "
                + "COUNT(DISTINCT programa) AS programas "
                + "FROM registro_laboratorio "
                + construirFiltros(programa, area, fechaInicial, fechaFinal);

        try (Connection conexion = ConexionBD.conectar()) {

            if (conexion == null) {
                throw new SQLException("No se pudo conectar con MySQL.");
            }

            try (PreparedStatement ps = conexion.prepareStatement(sql)) {

                asignarFiltros(ps, programa, area, fechaInicial, fechaFinal);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        indicadores.put("total", rs.getInt("total"));
                        indicadores.put("areas", rs.getInt("areas"));
                        indicadores.put("programas", rs.getInt("programas"));
                    }
                }
            }

        } catch (SQLException | IllegalArgumentException e) {
            e.printStackTrace();
            indicadores.put("total", 0);
            indicadores.put("areas", 0);
            indicadores.put("programas", 0);
        }

        return indicadores;
    }

    /**
     * Obtiene los registros agrupados por una categoría.
     * Las columnas se seleccionan únicamente desde el código interno.
     */
    public Map<String, Integer> obtenerAgrupacion(
            String columna, String programa, String area,
            String fechaInicial, String fechaFinal) {

        Map<String, Integer> resultados = new LinkedHashMap<>();

        // Solo se permiten las columnas definidas para los reportes.
        if (!"area".equals(columna)
                && !"programa".equals(columna)
                && !"asignatura".equals(columna)) {
            return resultados;
        }

        String sql = "SELECT " + columna + " AS categoria, "
                + "COUNT(*) AS cantidad "
                + "FROM registro_laboratorio "
                + construirFiltros(programa, area, fechaInicial, fechaFinal)
                + " GROUP BY " + columna
                + " ORDER BY cantidad DESC";

        try (Connection conexion = ConexionBD.conectar()) {

            if (conexion == null) {
                throw new SQLException("No se pudo conectar con MySQL.");
            }

            try (PreparedStatement ps = conexion.prepareStatement(sql)) {

                asignarFiltros(ps, programa, area, fechaInicial, fechaFinal);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        String categoria = rs.getString("categoria");

                        if (categoria == null || categoria.trim().isEmpty()) {
                            categoria = "Sin especificar";
                        }

                        resultados.put(
                                categoria,
                                rs.getInt("cantidad")
                        );
                    }
                }
            }

        } catch (SQLException | IllegalArgumentException e) {
            e.printStackTrace();
        }

        return resultados;
    }
}

