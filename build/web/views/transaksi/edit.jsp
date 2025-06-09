<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.dompetku.model.Transaksi, com.dompetku.model.Kategori" %>
<%
    Transaksi transaksi = (Transaksi) request.getAttribute("transaksi");
    java.util.List<Kategori> kategoriList = (java.util.List<Kategori>) request.getAttribute("kategoriList");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Edit Transaksi - DompetKu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px 0;
        }

        .form-container {
            max-width: 900px;
            margin: 0 auto;
            animation: fadeIn 0.8s ease;
        }

        .header-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
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
            margin-bottom: 0;
        }

        .main-form {
            background: #ffffff;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .section-title {
            font-weight: 700;
            color: #333;
            margin-bottom: 30px;
            font-size: 1.8rem;
            display: flex;
            align-items: center;
        }

        .section-title i {
            color: #0d6efd;
            margin-right: 15px;
        }

        .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }

        .form-label i {
            margin-right: 8px;
            color: #0d6efd;
        }

        .form-control,
        .form-select {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background-color: #fafbfc;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
            background-color: #ffffff;
        }

        .form-control:hover,
        .form-select:hover {
            border-color: #0d6efd;
            background-color: #ffffff;
        }

        .btn-primary-custom {
            background: #0d6efd;
            border: none;
            color: white;
            border-radius: 12px;
            padding: 14px 30px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-primary-custom:hover {
            background: #0b5ed7;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(13, 110, 253, 0.3);
            color: white;
        }

        .btn-secondary-custom {
            background: #6c757d;
            border: none;
            color: white;
            border-radius: 12px;
            padding: 14px 30px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-secondary-custom:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(108, 117, 125, 0.3);
            color: white;
        }

        .btn-danger-custom {
            background: #dc3545;
            border: none;
            color: white;
            border-radius: 12px;
            padding: 14px 30px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-danger-custom:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(220, 53, 69, 0.3);
            color: white;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            border-radius: 12px;
            padding: 15px 20px;
            margin-bottom: 25px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .error-message i {
            margin-right: 12px;
            font-size: 1.2rem;
        }

        .form-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid #e9ecef;
        }

        .form-section h5 {
            color: #333;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .form-section h5 i {
            margin-right: 10px;
            background: #0d6efd;
            color: white;
            padding: 8px;
            border-radius: 10px;
            font-size: 1rem;
        }

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 2px solid #e9ecef;
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

        .floating-label {
            position: relative;
        }

        .floating-label .form-control,
        .floating-label .form-select {
            padding-top: 20px;
        }

        @media (max-width: 768px) {
            .main-form {
                padding: 25px;
                margin: 15px;
            }
            
            .header-card {
                padding: 20px;
                margin: 15px;
            }
            
            .button-group {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-primary-custom,
            .btn-secondary-custom,
            .btn-danger-custom {
                width: 100%;
                justify-content: center;
            }
        }

        /* Animation for form interactions */
        .form-control:focus + .form-label,
        .form-select:focus + .form-label {
            color: #0d6efd;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="form-container">
        
        <!-- Main Form -->
        <div class="main-form">
            <h2 class="section-title">
                <i class="bi bi-pencil-square"></i>Edit Transaksi
            </h2>

            <% if (error != null && !error.isEmpty()) { %>
                <div class="error-message">
                    <i class="bi bi-exclamation-triangle"></i>
                    <%= error %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/transaksi" method="post">
                <input type="hidden" name="id" value="<%= transaksi.getId() %>">
                
                <div class="row">
                    <!-- Kolom Kiri -->
                    <div class="col-md-6">
                        <div class="form-section">
                            <h5><i class="bi bi-info-circle"></i>Informasi Dasar</h5>
                            
                            <div class="mb-3">
                                <label for="jenisTransaksi" class="form-label">
                                    <i class="bi bi-tag"></i>Jenis Transaksi
                                </label>
                                <select name="jenis" id="jenisTransaksi" class="form-select" required>
                                    <option value="pemasukan" <%= transaksi.getJenis().equalsIgnoreCase("pemasukan") ? "selected" : "" %>>
                                        <i class="bi bi-arrow-up-circle"></i> Pemasukan
                                    </option>
                                    <option value="pengeluaran" <%= transaksi.getJenis().equalsIgnoreCase("pengeluaran") ? "selected" : "" %>>
                                        <i class="bi bi-arrow-down-circle"></i> Pengeluaran
                                    </option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="jumlah" class="form-label">
                                    <i class="bi bi-currency-dollar"></i>Jumlah
                                </label>
                                <input type="number" name="jumlah" id="jumlah" step="0.01" class="form-control" 
                                       value="<%= transaksi.getJumlah() %>" placeholder="Masukkan jumlah transaksi" required />
                            </div>

                            <div class="mb-3">
                                <label for="tanggal" class="form-label">
                                    <i class="bi bi-calendar3"></i>Tanggal
                                </label>
                                <input type="date" name="tanggal" id="tanggal" class="form-control" 
                                       value="<%= transaksi.getTanggal() %>" required />
                            </div>
                        </div>
                    </div>

                    <!-- Kolom Kanan -->
                    <div class="col-md-6">
                        <div class="form-section">
                            <h5><i class="bi bi-list-ul"></i>Detail Transaksi</h5>
                            
                            <div class="mb-3">
                                <label for="kategori" class="form-label">
                                    <i class="bi bi-bookmark"></i>Kategori
                                </label>
                                <select name="kategori_id" id="kategori" class="form-select" required>
                                    <% if (kategoriList != null) {
                                           for (Kategori k : kategoriList) { %>
                                        <option value="<%= k.getId() %>" <%= transaksi.getKategori().getId() == k.getId() ? "selected" : "" %>>
                                            <%= k.getNama() %>
                                        </option>
                                    <%   }
                                       } %>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="deskripsi" class="form-label">
                                    <i class="bi bi-card-text"></i>Deskripsi
                                </label>
                                <textarea name="deskripsi" id="deskripsi" rows="4" class="form-control" 
                                          placeholder="Tambahkan catatan untuk transaksi ini (opsional)"><%= transaksi.getDeskripsi() %></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Button Group -->
                <div class="button-group">
                    <button type="submit" class="btn-primary-custom">
                        <i class="bi bi-check-circle me-2"></i>Simpan Perubahan
                    </button>
                    <a href="<%= request.getContextPath() %>/transaksi" class="btn-secondary-custom">
                        <i class="bi bi-arrow-left me-2"></i>Batal
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById("jenisTransaksi").addEventListener("change", function () {
            const jenis = this.value;
            const kategoriSelect = document.getElementById("kategori");

            fetch("<%= request.getContextPath() %>/transaksi?ajax=kategori&jenis=" + jenis)
                .then(response => response.json())
                .then(data => {
                    kategoriSelect.innerHTML = "";
                    data.forEach(function (kategori) {
                        const option = document.createElement("option");
                        option.value = kategori.id;
                        option.textContent = kategori.nama;
                        kategoriSelect.appendChild(option);
                    });
                })
                .catch(error => console.error("Gagal memuat kategori:", error));
        });

        // Form validation enhancement
        const form = document.querySelector('form');
        const jumlahInput = document.getElementById('jumlah');
        
        form.addEventListener('submit', function(e) {
            if (jumlahInput.value <= 0) {
                e.preventDefault();
                alert('Jumlah transaksi harus lebih besar dari 0');
                jumlahInput.focus();
            }
        });

        // Auto-format number input
        jumlahInput.addEventListener('input', function() {
            if (this.value < 0) {
                this.value = Math.abs(this.value);
            }
        });
    </script>
</body>
</html>