package com.ingsoftware.proyectosemestral.Modelo;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import java.time.LocalDate;

@Entity
public class Paciente {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long participante_id;
    String participante_cod;
    Boolean esCaso;
    LocalDate fecha_incl;

    public Paciente(Long participante_id, String participante_cod, Boolean esCaso, LocalDate fecha_incl) {
        this.participante_id = participante_id;
        this.participante_cod = participante_cod;
        this.esCaso = esCaso;
        this.fecha_incl = fecha_incl;
    }

    public Paciente() {}

    public Long getParticipante_id() {
        return participante_id;
    }

    public void setParticipante_id(Long participante_id) {
        this.participante_id = participante_id;
    }

    public String getParticipante_cod() {
        return participante_cod;
    }

    public void setParticipante_cod(String participante_cod) {
        this.participante_cod = participante_cod;
    }

    public Boolean getEsCaso() {
        return esCaso;
    }

    public void setEsCaso(Boolean esCaso) {
        this.esCaso = esCaso;
    }

    public LocalDate getFecha_incl() {
        return fecha_incl;
    }

    public void setFecha_incl(LocalDate fecha_incl) {
        this.fecha_incl = fecha_incl;
    }
}
