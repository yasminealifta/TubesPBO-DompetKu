<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DompetKu - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #2c3e50; /* warna gelap untuk kontras yang kuat */
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            background-color: rgba(255, 255, 255, 0.95); /* transparansi ringan untuk efek modern */
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2); /* bayangan agar card lebih menonjol */
            border-radius: 12px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card p-4">
                <h2 class="text-center mb-4">Login</h2>
                <% if ("true".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger text-center" role="alert">
                        Username atau password salah
                    </div>
                <% } %>
                <% if ("success".equals(request.getParameter("logout"))) { %>
                    <div class="alert alert-success text-center" role="alert">
                        Anda telah berhasil logout
                    </div>
                <% } %>
                <form action="AuthServlet" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Login</button>
                    <p class="mt-3 text-center text-muted">Belum punya akun? <a href="views/auth/register.jsp">Daftar</a></p>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Prevent back navigation ke protected pages setelah logout
    (function() {
        // Check jika ada parameter logout=success, berarti baru saja logout
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('logout') === 'success') {
            // Clear browser history dan prevent back navigation
            if (window.history && window.history.pushState) {
                // Add current login page to history
                window.history.pushState(null, null, window.location.href);
                
                // Listen for back button
                window.addEventListener('popstate', function(event) {
                    // Push login page again to prevent going back
                    window.history.pushState(null, null, window.location.href);
                });
            }
        }
        
        // Additional protection: disable back navigation from login page
        if (window.history && window.history.pushState) {
            window.history.pushState(null, null, window.location.href);
            window.addEventListener('popstate', function(event) {
                window.history.pushState(null, null, window.location.href);
            });
        }
    })();
    
    // Clear any cached session data
    if (typeof(Storage) !== "undefined") {
        sessionStorage.clear();
        localStorage.removeItem('authToken');
    }
</script>
</body>
</html>