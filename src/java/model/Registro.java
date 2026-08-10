package model;

import java.sql.Date;

public class Registro {

    private int id;
    private String programa;
    private String asignatura;
    private String docente;
    private String area;
    private Date fecha;
    private String horario;
    private String elementos;

    // Constructor vacío
    public Registro() {
    }

    // Constructor sin ID
    public Registro(String programa, String asignatura, String docente,
                    String area, Date fecha, String horario, String elementos) {

        this.programa = programa;
        this.asignatura = asignatura;
        this.docente = docente;
        this.area = area;
        this.fecha = fecha;
        this.horario = horario;
        this.elementos = elementos;
    }

    // Constructor completo
    public Registro(int id, String programa, String asignatura, String docente,
                    String area, Date fecha, String horario, String elementos) {

        this.id = id;
        this.programa = programa;
        this.asignatura = asignatura;
        this.docente = docente;
        this.area = area;
        this.fecha = fecha;
        this.horario = horario;
        this.elementos = elementos;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPrograma() {
        return programa;
    }

    public void setPrograma(String programa) {
        this.programa = programa;
    }

    public String getAsignatura() {
        return asignatura;
    }

    public void setAsignatura(String asignatura) {
        this.asignatura = asignatura;
    }

    public String getDocente() {
        return docente;
    }

    public void setDocente(String docente) {
        this.docente = docente;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getHorario() {
        return horario;
    }

    public void setHorario(String horario) {
        this.horario = horario;
    }

    public String getElementos() {
        return elementos;
    }

    public void setElementos(String elementos) {
        this.elementos = elementos;
    }
}