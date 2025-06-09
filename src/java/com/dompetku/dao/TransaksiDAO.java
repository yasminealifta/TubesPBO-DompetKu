package com.dompetku.dao;

import com.dompetku.model.Transaksi;
import com.dompetku.model.Kategori;
import com.dompetku.model.User;
import com.dompetku.util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TransaksiDAO {

    // Tambah transaksi
    public static boolean insert(Transaksi transaksi) throws SQLException {
        String sql = "INSERT INTO transaksi (user_id, kategori_id, jenis, jumlah, deskripsi, tanggal) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, transaksi.getUser().getId());
            stmt.setInt(2, transaksi.getKategori().getId());
            stmt.setString(3, transaksi.getJenis());
            stmt.setDouble(4, transaksi.getJumlah());
            stmt.setString(5, transaksi.getDeskripsi());
            stmt.setDate(6, Date.valueOf(transaksi.getTanggal()));

            return stmt.executeUpdate() > 0;
        }
    }

    // Mengambil semua transaksi milik user tertentu
    public static List<Transaksi> getAllByUserId(int userId) throws SQLException {
        List<Transaksi> list = new ArrayList<>();

        String sql = "SELECT t.*, k.nama_kategori AS nama_kategori FROM transaksi t " +
                     "JOIN kategori k ON t.kategori_id = k.id WHERE t.user_id = ? ORDER BY t.tanggal DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Transaksi t = new Transaksi();
                t.setId(rs.getInt("id"));
                t.setJumlah(rs.getDouble("jumlah"));
                t.setDeskripsi(rs.getString("deskripsi"));
                t.setTanggal(rs.getDate("tanggal").toLocalDate());
                t.setJenis(rs.getString("jenis"));

                Kategori k = new Kategori();
                k.setId(rs.getInt("kategori_id"));
                k.setNama(rs.getString("nama_kategori"));
                t.setKategori(k);

                User u = new User();
                u.setId(userId);
                t.setUser(u);

                list.add(t);
            }
        }

        return list;
    }
    
    public static List<Transaksi> getByUserIdAndMonth(int userId, int bulan, int tahun) throws SQLException {
    List<Transaksi> list = new ArrayList<>();
    String sql = "SELECT t.*, k.nama_kategori, k.jenis FROM transaksi t JOIN kategori k ON t.kategori_id = k.id " +
                 "WHERE t.user_id = ? AND MONTH(t.tanggal) = ? AND YEAR(t.tanggal) = ? ORDER BY t.tanggal DESC";

    try (Connection conn = DatabaseUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, userId);
        stmt.setInt(2, bulan);
        stmt.setInt(3, tahun);

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Kategori kategori = new Kategori();
            kategori.setId(rs.getInt("kategori_id"));
            kategori.setNama(rs.getString("nama_kategori"));
            kategori.setJenis(rs.getString("jenis"));
            
            User u = new User();
            u.setId(userId);

            Transaksi transaksi = new Transaksi();
            transaksi.setId(rs.getInt("id"));
            transaksi.setUser(u);
            transaksi.setKategori(kategori);
            transaksi.setJenis(rs.getString("jenis"));
            transaksi.setJumlah(rs.getDouble("jumlah"));
            transaksi.setTanggal(rs.getDate("tanggal").toLocalDate());
            transaksi.setDeskripsi(rs.getString("deskripsi"));

            list.add(transaksi);
        }
    }

    return list;
}


    // Hapus transaksi berdasarkan ID
    public static boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM transaksi WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    

    // (Opsional) Update transaksi
    public static boolean update(Transaksi transaksi) throws SQLException {
        String sql = "UPDATE transaksi SET kategori_id = ?, jenis = ?, jumlah = ?, deskripsi = ?, tanggal = ? " +
                     "WHERE id = ? AND user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, transaksi.getKategori().getId());
            stmt.setString(2, transaksi.getJenis());
            stmt.setDouble(3, transaksi.getJumlah());
            stmt.setString(4, transaksi.getDeskripsi());
            stmt.setDate(5, Date.valueOf(transaksi.getTanggal()));
            stmt.setInt(6, transaksi.getId());
            stmt.setInt(7, transaksi.getUser().getId());

            return stmt.executeUpdate() > 0;
        }
    }
    
    // Mengambil transaksi berdasarkan ID
    public static Transaksi getById(int id) throws SQLException {
        String sql = "SELECT t.*, k.nama_kategori, k.jenis FROM transaksi t " +
                     "JOIN kategori k ON t.kategori_id = k.id WHERE t.id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Kategori kategori = new Kategori();
                kategori.setId(rs.getInt("kategori_id"));
                kategori.setNama(rs.getString("nama_kategori"));
                kategori.setJenis(rs.getString("jenis"));

                User user = new User();
                user.setId(rs.getInt("user_id"));

                Transaksi transaksi = new Transaksi();
                transaksi.setId(rs.getInt("id"));
                transaksi.setUser(user);
                transaksi.setKategori(kategori);
                transaksi.setJenis(rs.getString("jenis"));
                transaksi.setJumlah(rs.getDouble("jumlah"));
                transaksi.setDeskripsi(rs.getString("deskripsi"));
                transaksi.setTanggal(rs.getDate("tanggal").toLocalDate());

                return transaksi;
            }
        }

        return null;
    }


    public static List<Transaksi> getByUserId(int id) throws SQLException {
    return getAllByUserId(id);
}
    
    
}
