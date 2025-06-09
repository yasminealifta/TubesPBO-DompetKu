<%@ page import="java.util.*, com.dompetku.model.Transaksi" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.dompetku.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // AUTH GUARD - Cek session dulu sebelum render halaman
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Transaksi - DompetKu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px 0;
            position: relative;
        }
        
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            animation: fadeIn 0.8s ease;
        }
        
        /* Header Styles */
        .top-header {
            background: #ffffff;
            border-radius: 20px;
            padding: 20px 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }
        
        .greeting-section {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            text-align: center;
        }
        
        .btn-logout {
            background: linear-gradient(135deg, #dc3545, #c82333);
            border: none;
            color: white;
            border-radius: 12px;
            padding: 12px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(220, 53, 69, 0.3);
            background: linear-gradient(135deg, #c82333, #a71e2a);
            color: white;
        }
        
        .greeting-section h1 {
            font-weight: 800;
            font-size: 2rem;
            color: #0d6efd;
            margin: 0;
            background: linear-gradient(90deg, #0d6efd, #00c6ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .greeting-section p {
            color: #6c757d;
            margin: 5px 0 0 0;
            font-size: 1rem;
        }
        
        .header-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            text-align: center;
        }
        
        .header-card img {
            width: 60px;
            margin-bottom: 15px;
        }
        
        .header-card h1 {
            font-weight: 800;
            font-size: 2rem;
            color: #0d6efd;
            margin-bottom: 10px;
        }
        
        .header-tagline {
            font-size: 1.1rem;
            color: #333;
            font-weight: 450;
            background: linear-gradient(90deg, #0d6efd, #00c6ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 20px;
        }
        
        .stats-card {
            background: #ffffff;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            margin-bottom: 20px;
            transition: transform 0.3s ease;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
        }
        
        .stats-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 15px;
        }
        
        .income-icon {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }
        
        .expense-icon {
            background: linear-gradient(135deg, #dc3545, #fd7e14);
            color: white;
        }
        
        .balance-icon {
            background: linear-gradient(135deg, #0d6efd, #00c6ff);
            color: white;
        }
        
        .main-content {
            background: #ffffff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .section-title {
            font-weight: 700;
            color: #0d6efd;
            margin-bottom: 25px;
            font-size: 1.5rem;
        }
        
        .table {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }
        
        .table thead th {
            background: linear-gradient(135deg, #0d6efd, #00c6ff);
            color: white;
            font-weight: 600;
            border: none;
            padding: 15px;
        }
        
        .table tbody tr {
            transition: background-color 0.2s ease;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9ff;
        }
        
        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-color: #e9ecef;
        }
        
        .btn-action {
            border-radius: 8px;
            padding: 6px 12px;
            font-size: 0.875rem;
            font-weight: 500;
            margin: 0 2px;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #0d6efd, #00c6ff);
            border: none;
            color: white;
            border-radius: 12px;
            padding: 12px 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(13, 110, 253, 0.3);
            background: linear-gradient(135deg, #0b5ed7, #0099cc);
        }
        
        .btn-success-custom {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            color: white;
            border-radius: 12px;
            padding: 12px 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-success-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.3);
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .currency-positive {
            color: #28a745;
            font-weight: 600;
        }
        
        .currency-negative {
            color: #dc3545;
            font-weight: 600;
        }
        
        .badge-jenis {
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .badge-pemasukan {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
        }
        
        .badge-pengeluaran {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .top-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .greeting-section {
                position: static;
                transform: none;
            }
            
            .greeting-section h1 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Top Header with Greeting -->
        <div class="top-header">
            <button onclick="logout()" class="btn btn-logout">
                <i class="bi bi-box-arrow-right"></i>
                Logout
            </button>
            <div class="greeting-section">
                <%
                    String displayName = "User";
                    
                    if (currentUser != null && currentUser.getUsername() != null) {
                        displayName = currentUser.getUsername();
                    }
                %>
                <h1>Hello <%= displayName %>!</h1>
                <p>Yuk kelola keuanganmu</p>
            </div>
            <div></div> <!-- Empty div for spacing -->
        </div>
        
        <%
            List<Transaksi> list = (List<Transaksi>) request.getAttribute("listTransaksi");
            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
            double totalPemasukan = 0;
            double totalPengeluaran = 0;
            
            if (list != null && !list.isEmpty()) {
                for (Transaksi t : list) {
                    if ("pemasukan".equalsIgnoreCase(t.getJenis())) {
                        totalPemasukan += t.getJumlah();
                    } else if ("pengeluaran".equalsIgnoreCase(t.getJenis())) {
                        totalPengeluaran += t.getJumlah();
                    }
                }
            }
            
            double saldo = totalPemasukan - totalPengeluaran;
        %>

        <!-- Main Content -->
        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="section-title mb-0">
                    <i class="bi bi-list-ul me-2"></i>Daftar Transaksi
                </h2>
                <a href="${pageContext.request.contextPath}/transaksi?action=tambah" 
                   class="btn btn-primary-custom">
                    <i class="bi bi-plus-circle me-2"></i>Tambah Transaksi
                </a>
            </div>

            <%
                if (list != null && !list.isEmpty()) {
            %>
                <!-- Transaction Table -->
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th><i class="bi bi-calendar3 me-2"></i>Tanggal</th>
                                <th><i class="bi bi-tag me-2"></i>Jenis</th>
                                <th><i class="bi bi-bookmark me-2"></i>Kategori</th>
                                <th><i class="bi bi-currency-dollar me-2"></i>Jumlah</th>
                                <th><i class="bi bi-card-text me-2"></i>Deskripsi</th>
                                <th><i class="bi bi-gear me-2"></i>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            for (Transaksi t : list) {
                                String jumlahClass = t.isPemasukan() ? "currency-positive" : "currency-negative";
                                String jenisClass = t.isPemasukan() ? "badge-pemasukan" : "badge-pengeluaran";
                        %>
                            <tr>
                                <td>
                                    <i class="bi bi-calendar-event text-muted me-2"></i>
                                    <%= t.getTanggal() %>
                                </td>
                                <td>
                                    <span class="badge <%= jenisClass %>">
                                        <i class="bi bi-<%= t.isPemasukan() ? "arrow-up" : "arrow-down" %> me-1"></i>
                                        <%= t.getJenis() %>
                                    </span>
                                </td>
                                <td>
                                    <i class="bi bi-bookmark-fill text-primary me-2"></i>
                                    <%= t.getKategori().getNama() %>
                                </td>
                                <td class="<%= jumlahClass %>">
                                    <strong><%= currencyFormatter.format(t.getJumlah()) %></strong>
                                </td>
                                <td>
                                    <span class="text-muted">
                                        <%= t.getDeskripsi() != null && !t.getDeskripsi().isEmpty() ? t.getDeskripsi() : "-" %>
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <a href="<%= request.getContextPath() %>/transaksi?action=edit&id=<%= t.getId() %>" 
                                           class="btn btn-warning btn-action" title="Edit">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="<%= request.getContextPath() %>/transaksi?action=hapus&id=<%= t.getId() %>" 
                                           class="btn btn-danger btn-action" 
                                           title="Hapus"
                                           onclick="return confirm('Yakin ingin menghapus transaksi ini?');">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            <%
                } else {
            %>
                <!-- Empty State -->
                <div class="empty-state">
                    <i class="bi bi-inbox"></i>
                    <h4 class="mb-3">Belum Ada Transaksi</h4>
                    <p class="mb-4">Mulai kelola keuanganmu dengan menambahkan transaksi pertama</p>
                    <a href="${pageContext.request.contextPath}/transaksi?action=tambah" 
                       class="btn btn-primary-custom">
                        <i class="bi bi-plus-circle me-2"></i>Tambah Transaksi Pertama
                    </a>
                </div>
            <%
                }
            %>

            <!-- Action Buttons -->
            <div class="d-flex justify-content-center mt-4 pt-4 border-top">
                <a href="<%= request.getContextPath() %>/laporan" 
                   class="btn btn-success-custom me-3">
                    <i class="bi bi-bar-chart-line me-2"></i>Lihat Laporan Bulanan
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // AUTH PROTECTION - Additional client-side protection
        (function() {
            // Set cache control untuk prevent page caching
            if (window.history && window.history.pushState) {
                // Prevent page from being cached
                window.onbeforeunload = function() {
                    // Clear any cache when leaving the page
                };
                
                // Handle page show event (when user navigates back)
                window.addEventListener('pageshow', function(event) {
                    // If page loaded from cache and no session, redirect to login
                    if (event.persisted) {
                        // Check if session still exists via a simple check
                        fetch('<%= request.getContextPath() %>/TransaksiServlet?action=checkSession', {
                            method: 'GET',
                            cache: 'no-cache'
                        }).then(function(response) {
                            if (!response.ok) {
                                window.location.replace('<%= request.getContextPath() %>/index.jsp');
                            }
                        }).catch(function() {
                            window.location.replace('<%= request.getContextPath() %>/index.jsp');
                        });
                    }
                });
            }
        })();
        
        function logout() {
            if (confirm('Apakah Anda yakin ingin keluar?')) {
                // Clear any client-side session data
                if (typeof(Storage) !== "undefined") {
                    sessionStorage.clear();
                    localStorage.clear();
                }
                
                // Use replace instead of href to prevent back navigation
                window.location.replace('<%= request.getContextPath() %>/AuthServlet?action=logout');
            }
        }
    </script>
</body>
</html>