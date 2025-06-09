package com.dompetku.model;

import java.time.LocalDate;

public class Transaksi {
    private int id;
    private double jumlah;
    private String deskripsi;
    private LocalDate tanggal;
    private Kategori kategori;
    private User user;
    private String jenis; // "pemasukan" atau "pengeluaran"

    // Constructor
    public Transaksi() {}

    public Transaksi(int id, double jumlah, String deskripsi, LocalDate tanggal,
                     Kategori kategori, User user, String jenis) {
        this.id = id;
        this.jumlah = jumlah;
        this.deskripsi = deskripsi;
        this.tanggal = tanggal;
        this.kategori = kategori;
        this.user = user;
        this.jenis = jenis;
    }

    // Getter & Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public double getJumlah() { return jumlah; }
    public void setJumlah(double jumlah) { this.jumlah = jumlah; }

    public String getDeskripsi() { return deskripsi; }
    public void setDeskripsi(String deskripsi) { this.deskripsi = deskripsi; }

    public LocalDate getTanggal() { return tanggal; }
    public void setTanggal(LocalDate tanggal) { this.tanggal = tanggal; }

    public Kategori getKategori() { return kategori; }
    public void setKategori(Kategori kategori) { this.kategori = kategori; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getJenis() { return jenis; }
    public void setJenis(String jenis) { this.jenis = jenis; }

    // Optional: method bantu untuk icon/tampilan
    public boolean isPemasukan() {
        return "pemasukan".equalsIgnoreCase(jenis);
    }

    public boolean isPengeluaran() {
        return "pengeluaran".equalsIgnoreCase(jenis);
    }
}
