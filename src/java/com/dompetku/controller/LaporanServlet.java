package com.dompetku.controller;

import com.dompetku.dao.TransaksiDAO;
import com.dompetku.model.Transaksi;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/laporan")
public class LaporanServlet extends HttpServlet {
    private TransaksiDAO transaksiDAO;

    @Override
    public void init() {
        transaksiDAO = new TransaksiDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");

        if (userObj == null) {
            setDefaultAttributes(request);
            request.getRequestDispatcher("laporan.jsp").forward(request, response);
            return;
        }

        int userId = ((com.dompetku.model.User) userObj).getId();

        // Ambil parameter bulan & tahun dari form
        String monthParam = request.getParameter("month");
        String yearParam = request.getParameter("year");

        Integer month = parseInteger(monthParam);
        Integer year = parseInteger(yearParam);

        // Jika tidak ada filter, gunakan bulan dan tahun saat ini
        if (month == null || year == null) {
            LocalDate now = LocalDate.now();
            month = (month == null) ? now.getMonthValue() : month;
            year = (year == null) ? now.getYear() : year;
        }

        try {
            // Data untuk laporan
            LaporanData laporanData = generateLaporanData(userId, month, year);
            
            // Set attributes untuk JSP
            setLaporanAttributes(request, laporanData, month, year);
            
            request.getRequestDispatcher("laporan.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Terjadi kesalahan pada server.");
        }
    }

    /**
     * Membuat data laporan berdasarkan userId, bulan, dan tahun
     */
    private LaporanData generateLaporanData(int userId, int month, int year) throws SQLException {
        List<Transaksi> semuaTransaksi = TransaksiDAO.getAllByUserId(userId);
        List<Transaksi> transaksiBulanIni = new ArrayList<>();
        double totalPemasukan = 0;
        double totalPengeluaran = 0;

        // Filter transaksi berdasarkan bulan dan tahun
        for (Transaksi t : semuaTransaksi) {
            LocalDate tanggal = t.getTanggal();
            
            if (tanggal.getMonthValue() == month && tanggal.getYear() == year) {
                transaksiBulanIni.add(t);
                
                if ("pemasukan".equalsIgnoreCase(t.getJenis())) {
                    totalPemasukan += t.getJumlah();
                } else if ("pengeluaran".equalsIgnoreCase(t.getJenis())) {
                    totalPengeluaran += t.getJumlah();
                }
            }
        }

        // Membuat insights
        String insight = generateInsight(transaksiBulanIni);
        
        // Membuat kategori pengeluaran breakdown
        Map<String, Double> kategoriBreakdown = generateKategoriBreakdown(transaksiBulanIni);
        
        // Menghitung saldo
        double saldo = totalPemasukan - totalPengeluaran;

        return new LaporanData(transaksiBulanIni, totalPemasukan, totalPengeluaran, 
                              saldo, insight, kategoriBreakdown);
    }

    /**
     * Membuat insight berdasarkan data transaksi
     */
    private String generateInsight(List<Transaksi> transaksi) {
        if (transaksi.isEmpty()) {
            return "Belum ada transaksi untuk periode ini.";
        }

        // Cari pengeluaran tertinggi
        Optional<Transaksi> maxPengeluaran = transaksi.stream()
                .filter(t -> "pengeluaran".equalsIgnoreCase(t.getJenis()))
                .max(Comparator.comparing(Transaksi::getJumlah));

        if (maxPengeluaran.isPresent()) {
            Transaksi max = maxPengeluaran.get();
            NumberFormat formatter = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
            return String.format("Pengeluaran tertinggi: %s (%s)", 
                    max.getKategori().getNama(), 
                    formatter.format(max.getJumlah()));
        }

        return "Hanya ada transaksi pemasukan di periode ini.";
    }

    /**
     * Membuat breakdown pengeluaran per kategori
     */
    private Map<String, Double> generateKategoriBreakdown(List<Transaksi> transaksi) {
        return transaksi.stream()
                .filter(t -> "pengeluaran".equalsIgnoreCase(t.getJenis()))
                .collect(Collectors.groupingBy(
                        t -> t.getKategori().getNama(),
                        Collectors.summingDouble(Transaksi::getJumlah)
                ));
    }

    /**
     * Men-set default attributes ketika user belum login
     */
    private void setDefaultAttributes(HttpServletRequest request) {
        request.setAttribute("totalPemasukan", 0.0);
        request.setAttribute("totalPengeluaran", 0.0);
        request.setAttribute("saldo", 0.0);
        request.setAttribute("transaksiBulanan", new ArrayList<>());
        request.setAttribute("insight", "Silakan login untuk melihat laporan.");
        request.setAttribute("kategoriBreakdown", new HashMap<>());
    }

    /**
     * Men-set attributes untuk laporan di JSP
     */
    private void setLaporanAttributes(HttpServletRequest request, LaporanData data, 
                                    Integer month, Integer year) {
        request.setAttribute("totalPemasukan", data.totalPemasukan);
        request.setAttribute("totalPengeluaran", data.totalPengeluaran);
        request.setAttribute("saldo", data.saldo);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);
        request.setAttribute("transaksiBulanan", data.transaksi);
        request.setAttribute("insight", data.insight);
        request.setAttribute("kategoriBreakdown", data.kategoriBreakdown);
        
        // Tambahan nama bulan untuk display
        if (month != null) {
            String namaBulan = java.time.Month.of(month)
                    .getDisplayName(TextStyle.FULL, new Locale("id", "ID"));
            request.setAttribute("namaBulan", namaBulan);
        }
    }

    /**
     * Helper method untuk parsing integer
     */
    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * Inner class untuk menyimpan data laporan
     */
    private static class LaporanData {
        final List<Transaksi> transaksi;
        final double totalPemasukan;
        final double totalPengeluaran;
        final double saldo;
        final String insight;
        final Map<String, Double> kategoriBreakdown;

        LaporanData(List<Transaksi> transaksi, double totalPemasukan, double totalPengeluaran,
                   double saldo, String insight, Map<String, Double> kategoriBreakdown) {
            this.transaksi = transaksi;
            this.totalPemasukan = totalPemasukan;
            this.totalPengeluaran = totalPengeluaran;
            this.saldo = saldo;
            this.insight = insight;
            this.kategoriBreakdown = kategoriBreakdown;
        }
    }
}