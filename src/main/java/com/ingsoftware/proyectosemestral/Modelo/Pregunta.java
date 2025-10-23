package com.ingsoftware.proyectosemestral.Modelo;

public class Pregunta {
    private Long pregunta_id;
    private int orden;
    private TipoDato tipo_dato;
    private String etiqueta;
    private boolean dato_sensible;
    private boolean activo;
    private String descripcion;
    private double dicotomizacion;
    private SentidoCorte sentido_corte;

    public Pregunta(Long pregunta_id, int orden, TipoDato tipo_dato, String etiqueta, boolean dato_sensible, boolean activo, String descripcion, double dicotomizacion, SentidoCorte sentido_corte) {
        this.pregunta_id = pregunta_id;
        this.orden = orden;
        this.tipo_dato = tipo_dato;
        this.etiqueta = etiqueta;
        this.dato_sensible = dato_sensible;
        this.activo = activo;
        this.descripcion = descripcion;
        this.dicotomizacion = dicotomizacion;
        this.sentido_corte = sentido_corte;
    }

    public Long getPregunta_id() {
        return pregunta_id;
    }

    public void setPregunta_id(Long pregunta_id) {
        this.pregunta_id = pregunta_id;
    }

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public TipoDato getTipo_dato() {
        return tipo_dato;
    }

    public void setTipo_dato(TipoDato tipo_dato) {
        this.tipo_dato = tipo_dato;
    }

    public String getEtiqueta() {
        return etiqueta;
    }

    public void setEtiqueta(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public boolean isDato_sensible() {
        return dato_sensible;
    }

    public void setDato_sensible(boolean dato_sensible) {
        this.dato_sensible = dato_sensible;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public double getDicotomizacion() {
        return dicotomizacion;
    }

    public void setDicotomizacion(double dicotomizacion) {
        this.dicotomizacion = dicotomizacion;
    }

    public SentidoCorte getSentido_corte() {
        return sentido_corte;
    }

    public void setSentido_corte(SentidoCorte sentido_corte) {
        this.sentido_corte = sentido_corte;
    }
}
