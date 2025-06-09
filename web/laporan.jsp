<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.Month" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dompetku.model.Transaksi" %>
<%@ page import="com.dompetku.model.User" %>
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

    double pemasukan = (double) request.getAttribute("totalPemasukan");
    double pengeluaran = (double) request.getAttribute("totalPengeluaran");
    double saldo = (double) request.getAttribute("saldo");
    int selectedMonth = request.getAttribute("selectedMonth") != null ? (int) request.getAttribute("selectedMonth") : -1;
    int selectedYear = request.getAttribute("selectedYear") != null ? (int) request.getAttribute("selectedYear") : -1;
    String namaBulan = (String) request.getAttribute("namaBulan");
    String insight = (String) request.getAttribute("insight");
    Map<String, Double> kategoriBreakdown = (Map<String, Double>) request.getAttribute("kategoriBreakdown");
    List<Transaksi> transaksi = (List<Transaksi>) request.getAttribute("transaksiBulanan");
    
    NumberFormat formatter = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
    String saldoClass = saldo >= 0 ? "text-success" : "text-danger";
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Bulanan - DompetKu</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px 0;
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            position: relative;
        }

        /* Style untuk button kembali di pojok kiri atas */
        .btn-back-top {
            position: absolute;
            top: 0;
            left: 20px;
            z-index: 1000;
            background: linear-gradient(90deg, #0d6efd, #00c6ff);
            border: none;
            border-radius: 12px;
            padding: 10px 25px;
            color: white;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(13, 110, 253, 0.2);
        }

        .btn-back-top:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(13, 110, 253, 0.3);
        }

        .page-header {
            background: #ffffff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            margin-top: 60px; /* Memberikan ruang untuk button */
            text-align: center;
            animation: fadeIn 0.8s ease;
        }

        .page-title {
            font-weight: 800;
            font-size: 2.2rem;
            color: #0d6efd;
            margin-bottom: 10px;
        }

        .period-text {
            color: #555;
            font-size: 1.1rem;
            margin-bottom: 0;
        }

        .content-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            animation: fadeIn 0.8s ease;
        }

        .section-title {
            font-weight: 700;
            font-size: 1.4rem;
            color: #0d6efd;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            color: #00c6ff;
        }

        .form-select, .form-control {
            border: 2px solid #e3f2fd;
            border-radius: 12px;
            padding: 12px 15px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .form-select:focus, .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.15);
        }

        .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
        }

        .btn-primary {
            background: linear-gradient(90deg, #0d6efd, #00c6ff);
            border: none;
            border-radius: 12px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(13, 110, 253, 0.3);
        }

        .summary-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.08);
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid #f8f9fa;
            height: 100%;
        }

        .summary-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.12);
            border-color: #e3f2fd;
        }

        .summary-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 1.8rem;
        }

        .icon-income {
            background: linear-gradient(135deg, #e8f5e8, #c8e6c9);
            color: #2e7d32;
        }

        .icon-expense {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #d32f2f;
        }

        .icon-balance {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #0d6efd;
        }

        .summary-label {
            color: #666;
            font-weight: 600;
            font-size: 0.95rem;
            margin-bottom: 10px;
        }

        .summary-value {
            font-size: 1.6rem;
            font-weight: 800;
            margin: 0;
        }

        .insight-card {
            background: linear-gradient(135deg, #fff3e0, #ffcc02);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 15px 30px rgba(255, 193, 7, 0.2);
            margin-bottom: 30px;
            animation: fadeIn 0.8s ease;
        }

        .insight-icon {
            font-size: 1.5rem;
            color: #ff8f00;
            margin-right: 15px;
        }

        .insight-title {
            font-weight: 700;
            color: #ff8f00;
            margin-bottom: 8px;
        }

        .insight-text {
            color: #5d4037;
            margin: 0;
            font-weight: 500;
        }

        .chart-container {
            max-width: 350px;
            margin: 20px auto;
        }

        .no-data-container {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .no-data-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        .category-item {
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .category-item:last-child {
            border-bottom: none;
        }

        .category-name {
            font-weight: 600;
            color: #333;
        }

        .category-amount {
            font-weight: 700;
            color: #d32f2f;
        }

        .category-progress {
            height: 8px;
            background: #f0f0f0;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 8px;
        }

        .category-progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #ff5722, #ff9800);
            border-radius: 10px;
            transition: width 0.6s ease;
        }

        .transaction-item {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 15px;
            border-left: 4px solid #dee2e6;
            transition: all 0.3s ease;
        }

        .transaction-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .transaction-item.income {
            border-left-color: #2e7d32;
            background: linear-gradient(135deg, #f1f8e9, #e8f5e8);
        }

        .transaction-item.expense {
            border-left-color: #d32f2f;
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
        }

        .transaction-title {
            font-weight: 700;
            color: #333;
            margin-bottom: 8px;
        }

        .transaction-meta {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        .transaction-amount {
            font-size: 1.2rem;
            font-weight: 800;
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

        .slide-up {
            animation: slideUp 0.8s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .page-title {
                font-size: 1.8rem;
            }
            
            .main-container {
                padding: 0 15px;
            }
            
            .content-card {
                padding: 20px;
            }

            .btn-back-top {
                left: 15px;
                font-size: 0.9rem;
                padding: 8px 20px;
            }

            .page-header {
                margin-top: 70px;
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <!-- Button Kembali di pojok kiri atas -->
    <a href="transaksi" class="btn-back-top">
        <i class="fas fa-arrow-left me-2"></i>Kembali ke Dashboard
    </a>

    <!-- Header Section -->
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-chart-line"></i>
            Laporan Bulanan <span style="background: linear-gradient(90deg, #0d6efd, #00c6ff); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">DompetKu</span>
        </h1>
        <% if (namaBulan != null && selectedYear > 0) { %>
            <p class="period-text">
                <i class="fas fa-calendar-alt me-2"></i>
                Periode: <%= namaBulan %> <%= selectedYear %>
            </p>
        <% } %>
    </div>

    <!-- Filter Section -->
    <div class="content-card slide-up">
        <h3 class="section-title">
            <i class="fas fa-filter"></i>
            Filter Laporan
        </h3>
        <form method="get" action="laporan" class="row g-4">
            <div class="col-md-4">
                <label class="form-label">Pilih Bulan</label>
                <select name="month" class="form-select">
                    <option value="">Semua Bulan</option>
                    <% for (int i = 1; i <= 12; i++) { %>
                        <option value="<%= i %>" <%= i == selectedMonth ? "selected" : "" %>>
                            <%= Month.of(i).getDisplayName(java.time.format.TextStyle.FULL, new Locale("id", "ID")) %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label">Pilih Tahun</label>
                <select name="year" class="form-select">
                    <option value="">Semua Tahun</option>
                    <%
                        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
                        for (int y = currentYear; y >= currentYear - 5; y--) {
                    %>
                        <option value="<%= y %>" <%= y == selectedYear ? "selected" : "" %>><%= y %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-search me-2"></i>Tampilkan Laporan
                </button>
            </div>
        </form>
    </div>

    <!-- Summary Cards -->
    <div class="content-card slide-up">
        <h3 class="section-title">
            <i class="fas fa-chart-bar"></i>
            Ringkasan Keuangan
        </h3>
        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="summary-card">
                    <div class="summary-icon icon-income">
                        <i class="fas fa-arrow-trend-up"></i>
                    </div>
                    <h6 class="summary-label">Total Pemasukan</h6>
                    <h3 class="summary-value text-success"><%= formatter.format(pemasukan) %></h3>
                </div>
            </div>
            <div class="col-lg-4 mb-4">
                <div class="summary-card">
                    <div class="summary-icon icon-expense">
                        <i class="fas fa-arrow-trend-down"></i>
                    </div>
                    <h6 class="summary-label">Total Pengeluaran</h6>
                    <h3 class="summary-value text-danger"><%= formatter.format(pengeluaran) %></h3>
                </div>
            </div>
            <div class="col-lg-4 mb-4">
                <div class="summary-card">
                    <div class="summary-icon icon-balance">
                        <i class="fas fa-wallet"></i>
                    </div>
                    <h6 class="summary-label">Sisa Uang</h6>
                    <h3 class="summary-value <%= saldoClass %>"><%= formatter.format(saldo) %></h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Insight Alert -->
    <% if (insight != null && !insight.trim().isEmpty()) { %>
        <div class="insight-card slide-up">
            <div class="d-flex align-items-start">
                <i class="insight-icon fas fa-lightbulb"></i>
                <div>
                    <h6 class="insight-title">💡 Insight Keuangan</h6>
                    <p class="insight-text"><%= insight %></p>
                </div>
            </div>
        </div>
    <% } %>

    <!-- Charts and Analytics -->
    <div class="row">
        <!-- Budget Chart -->
        <div class="col-lg-6 mb-4">
            <div class="content-card slide-up">
                <h3 class="section-title">
                    <i class="fas fa-chart-pie"></i>
                    Perbandingan Keuangan
                </h3>
                <% if (pemasukan == 0 && pengeluaran == 0) { %>
                    <div class="no-data-container">
                        <i class="fas fa-chart-pie no-data-icon"></i>
                        <h6 class="text-muted">Tidak ada data untuk ditampilkan</h6>
                        <p class="text-muted small mb-0">Mulai tambahkan transaksi untuk melihat grafik</p>
                    </div>
                <% } else { %>
                    <div class="chart-container">
                        <canvas id="budgetChart"></canvas>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Category Breakdown -->
        <div class="col-lg-6 mb-4">
            <div class="content-card slide-up">
                <h3 class="section-title">
                    <i class="fas fa-tags"></i>
                    Breakdown Kategori
                </h3>
                <% if (kategoriBreakdown != null && !kategoriBreakdown.isEmpty()) { %>
                    <% for (Map.Entry<String, Double> entry : kategoriBreakdown.entrySet()) { %>
                        <div class="category-item">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="category-name">
                                    <i class="fas fa-tag me-2 text-muted"></i>
                                    <%= entry.getKey() %>
                                </span>
                                <span class="category-amount"><%= formatter.format(entry.getValue()) %></span>
                            </div>
                            <div class="category-progress">
                                <div class="category-progress-bar" 
                                     style="width: <%= pengeluaran > 0 ? (entry.getValue() / pengeluaran * 100) : 0 %>%"></div>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="no-data-container">
                        <i class="fas fa-tags no-data-icon"></i>
                        <h6 class="text-muted">Belum ada pengeluaran</h6>
                        <p class="text-muted small mb-0">Data kategori akan muncul setelah ada transaksi</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Transaction List -->
    <% if (transaksi != null && !transaksi.isEmpty()) { %>
        <div class="content-card slide-up">
            <h3 class="section-title">
                <i class="fas fa-history"></i>
                Riwayat Transaksi
                <span class="badge bg-primary ms-2" style="font-size: 0.8rem;"><%= transaksi.size() %></span>
            </h3>
            <div class="row">
                <% for (Transaksi t : transaksi) { %>
                    <div class="col-lg-4 col-md-6 mb-3">
                        <div class="transaction-item <%= "pemasukan".equalsIgnoreCase(t.getJenis()) ? "income" : "expense" %>">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="flex-grow-1">
                                    <h6 class="transaction-title"><%= t.getDeskripsi() %></h6>
                                    <div class="transaction-meta">
                                        <i class="fas fa-tag me-1"></i>
                                        <%= t.getKategori().getNama() %>
                                    </div>
                                    <div class="transaction-meta">
                                        <i class="fas fa-calendar me-1"></i>
                                        <%= t.getTanggal() %>
                                    </div>
                                </div>
                                <div class="text-end ms-3">
                                    <div class="transaction-amount <%= "pemasukan".equalsIgnoreCase(t.getJenis()) ? "text-success" : "text-danger" %>">
                                        <%= "pemasukan".equalsIgnoreCase(t.getJenis()) ? "+" : "-" %><%= formatter.format(t.getJumlah()) %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    <% } %>
</div>

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

    // Chart initialization with soft colors matching the theme
    <% if (pemasukan > 0 || pengeluaran > 0) { %>
        const ctx = document.getElementById('budgetChart').getContext('2d');
        const chart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Pemasukan', 'Pengeluaran'],
                datasets: [{
                    label: 'Keuangan Bulanan',
                    data: [<%= pemasukan %>, <%= pengeluaran %>],
                    backgroundColor: [
                        '#4caf50',
                        '#f44336'
                    ],
                    borderColor: [
                        '#2e7d32',
                        '#d32f2f'
                    ],
                    borderWidth: 3,
                    hoverOffset: 12
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 25,
                            usePointStyle: true,
                            pointStyle: 'circle',
                            font: {
                                size: 14,
                                weight: '600',
                                family: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif"
                            }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: 'white',
                        bodyColor: 'white',
                        cornerRadius: 12,
                        padding: 12,
                        callbacks: {
                            label: function(context) {
                                const value = new Intl.NumberFormat('id-ID', {
                                    style: 'currency',
                                    currency: 'IDR'
                                }).format(context.parsed);
                                return context.label + ': ' + value;
                            }
                        }
                    }
                },
                cutout: '60%',
                animation: {
                    animateRotate: true,
                    duration: 1200
                }
            }
        });
    <% } %>

    // Scroll animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    document.querySelectorAll('.slide-up').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'all 0.6s ease';
        observer.observe(el);
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>