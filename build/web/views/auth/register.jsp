<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DompetKu - Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #2c3e50;
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            background-color: rgba(255, 255, 255, 0.95);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            border-radius: 12px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card p-4">
                <h2 class="text-center mb-4">Sign Up</h2>

                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger">Registrasi gagal. Akun sudah tersedia.</div>
                <% } %>

                <form method="post" action="${pageContext.request.contextPath}/AuthServlet">
                    <input type="hidden" name="action" value="register">

                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input 
                            type="text" 
                            class="form-control" 
                            id="username" 
                            name="username" 
                            required 
                            placeholder="Masukkan username">
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input 
                            type="email" 
                            class="form-control" 
                            id="email" 
                            name="email" 
                            required 
                            placeholder="Masukkan email">
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input 
                            type="password" 
                            class="form-control" 
                            id="password" 
                            name="password" 
                            required 
                            placeholder="Masukkan password">
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Sign Up</button>
                    <p class="mt-3 text-center text-muted">Sudah punya akun? <a href="${pageContext.request.contextPath}/index.jsp">Login</a></p>
                </form>

            </div>
        </div>
    </div>
</div>
</body>
</html>
