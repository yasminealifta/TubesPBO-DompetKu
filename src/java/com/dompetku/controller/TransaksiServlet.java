package com.dompetku.controller;

import com.dompetku.dao.KategoriDAO;
import com.dompetku.dao.TransaksiDAO;
import com.dompetku.model.Kategori;
import com.dompetku.model.Transaksi;
import com.dompetku.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/transaksi")
public class TransaksiServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            int kategoriId = Integer.parseInt(request.getParameter("kategori_id"));
            String jenis = request.getParameter("jenis");
            double jumlah = Double.parseDouble(request.getParameter("jumlah"));
            String tanggalStr = request.getParameter("tanggal");
            String deskripsi = request.getParameter("deskripsi");
            String idStr = request.getParameter("id"); // untuk cek update atau insert

            Kategori kategori = KategoriDAO.getById(kategoriId);
            LocalDate tanggal = LocalDate.parse(tanggalStr);

            Transaksi transaksi = new Transaksi();
            transaksi.setUser(user);
            transaksi.setKategori(kategori);
            transaksi.setJenis(jenis);
            transaksi.setJumlah(jumlah);
            transaksi.setTanggal(tanggal);
            transaksi.setDeskripsi(deskripsi);

            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                transaksi.setId(id);
                TransaksiDAO.update(transaksi);
            } else {
                TransaksiDAO.insert(transaksi);
            }

            response.sendRedirect("transaksi");
        } catch (NumberFormatException | DateTimeParseException e) {
            e.printStackTrace();
            request.setAttribute("error", "Format data tidak valid.");
            request.getRequestDispatcher("/views/transaksi/tambah.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Gagal menyimpan transaksi.");
            request.getRequestDispatcher("/views/transaksi/tambah.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getId();

        String action = request.getParameter("action");
        String ajax = request.getParameter("ajax");

        try {
            if ("kategori".equalsIgnoreCase(ajax)) {
                String jenis = request.getParameter("jenis");
                List<Kategori> kategoriList = KategoriDAO.getByJenis(jenis);

                response.setContentType("application/json");
                PrintWriter out = response.getWriter();

                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < kategoriList.size(); i++) {
                    Kategori k = kategoriList.get(i);
                    json.append("{\"id\":").append(k.getId())
                        .append(",\"nama\":\"").append(k.getNama()).append("\"}");
                    if (i != kategoriList.size() - 1) {
                        json.append(",");
                    }
                }
                json.append("]");
                out.print(json.toString());
                out.flush();
                return;
            }

            if ("tambah".equalsIgnoreCase(action)) {
                List<Kategori> kategoriList = KategoriDAO.getAll();
                request.setAttribute("kategoriList", kategoriList);
                request.getRequestDispatcher("/views/transaksi/tambah.jsp").forward(request, response);

            } else if ("edit".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Transaksi transaksi = TransaksiDAO.getById(id);

                if (transaksi == null || transaksi.getUser().getId() != userId) {
                    response.sendRedirect("transaksi");
                    return;
                }

                List<Kategori> kategoriList = KategoriDAO.getAll();
                request.setAttribute("kategoriList", kategoriList);
                request.setAttribute("transaksi", transaksi);
                request.getRequestDispatcher("/views/transaksi/edit.jsp").forward(request, response);

            } else if ("hapus".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Transaksi transaksi = TransaksiDAO.getById(id);

                if (transaksi != null && transaksi.getUser().getId() == userId) {
                    TransaksiDAO.delete(id);
                }
                response.sendRedirect("transaksi");

            } else if ("laporan".equalsIgnoreCase(action)) {
                String bulanStr = request.getParameter("bulan");
                String tahunStr = request.getParameter("tahun");

                int bulan = (bulanStr != null) ? Integer.parseInt(bulanStr) : LocalDate.now().getMonthValue();
                int tahun = (tahunStr != null) ? Integer.parseInt(tahunStr) : LocalDate.now().getYear();

                List<Transaksi> listLaporan = TransaksiDAO.getByUserIdAndMonth(userId, bulan, tahun);
                request.setAttribute("listLaporan", listLaporan);
                request.setAttribute("bulan", bulan);
                request.setAttribute("tahun", tahun);

                request.getRequestDispatcher("/views/transaksi/laporan.jsp").forward(request, response);

            } else {
                List<Transaksi> listTransaksi = TransaksiDAO.getAllByUserId(userId);
                request.setAttribute("listTransaksi", listTransaksi);
                request.getRequestDispatcher("/views/transaksi/list.jsp").forward(request, response);
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Terjadi kesalahan saat memproses transaksi.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
