package com.dompetku.controller;
import com.dompetku.dao.UserDAO;
import com.dompetku.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {
    
    // Method untuk handle logout 
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("logout".equals(action)) {
            // Invalidate session
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            
            // Set cache control headers untuk prevent caching
            res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            res.setHeader("Pragma", "no-cache");
            res.setDateHeader("Expires", 0);
            
            // Redirect ke halaman login menggunakan sendRedirect
            res.sendRedirect(req.getContextPath() + "/index.jsp?logout=success");
        } else {
            // Jika bukan logout, redirect ke login
            res.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }
    
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("register".equals(action)) {
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            User user = new User(); 
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password);
            boolean success = false;
            try {
                success = UserDAO.register(user);
            } catch (SQLException e) {
                e.printStackTrace();
                res.sendRedirect("views/auth/register.jsp?error=true");
                return; // agar tidak lanjut ke bawah
            }
 
            if (success) {
                // Auto login setelah register
                User loggedInUser = null;
                try {
                    loggedInUser = UserDAO.login(username, password);
                } catch (SQLException ex) {
                    Logger.getLogger(AuthServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                req.getSession().setAttribute("user", loggedInUser);
                res.sendRedirect(req.getContextPath() + "/transaksi");
            } else {
                res.sendRedirect("views/auth/register.jsp?error=true");
            }
        } else {
            // Login
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            User user = null;
            try {
                user = UserDAO.login(username, password);
            } catch (SQLException ex) {
                Logger.getLogger(AuthServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            if (user != null) {
                req.getSession().setAttribute("user", user);
                req.getSession().setAttribute("userId", user.getId());
                res.sendRedirect("transaksi"); // Pastikan servlet/transaksi ada
            } else {
                res.sendRedirect("index.jsp?error=true");
            }
        }
    }
}