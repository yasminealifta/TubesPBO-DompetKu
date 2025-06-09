package com.dompetku.dao;

import com.dompetku.model.Kategori;
import com.dompetku.util.DatabaseUtil;
import java.sql.*;
import java.util.*;

public class KategoriDAO {
    public static List<Kategori> getAll() throws SQLException {
        List<Kategori> list = new ArrayList<>();
        String sql = "SELECT * FROM kategori";

        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Kategori k = new Kategori();
                k.setId(rs.getInt("id"));
                k.setNama(rs.getString("nama_kategori"));
                k.setJenis(rs.getString("jenis"));
                list.add(k);
            }
        }
        return list;
    }

    public static Kategori getById(int id) throws SQLException {
        String sql = "SELECT * FROM kategori WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Kategori k = new Kategori();
                k.setId(rs.getInt("id"));
                k.setNama(rs.getString("nama_kategori"));
                k.setJenis(rs.getString("jenis"));
                return k;
            }
        }
        return null;
    }

    public static List<Kategori> getByJenis(String jenis) throws SQLException {
        List<Kategori> list = new ArrayList<>();
        String sql = "SELECT * FROM kategori WHERE jenis = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, jenis);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Kategori k = new Kategori();
                k.setId(rs.getInt("id"));
                k.setNama(rs.getString("nama_kategori"));
                k.setJenis(rs.getString("jenis"));
                list.add(k);
            }
        }
        return list;
    }
}
