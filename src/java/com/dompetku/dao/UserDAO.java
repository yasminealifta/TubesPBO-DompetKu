package com.dompetku.dao;

import com.dompetku.model.User;
import com.dompetku.util.DatabaseUtil;
import java.sql.*;

public class UserDAO {
    public static User login(String username, String password) throws SQLException {
        String sql = "SELECT * FROM user WHERE username = ? AND password = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    return user;
                }
            }
        }
        return null;
    }

    public static boolean register(User user) throws SQLException {
        String sql = "INSERT INTO user (username, email, password) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());

            int rows = stmt.executeUpdate();
        System.out.println("Rows inserted: " + rows);
        return rows > 0;
    } catch (SQLException e) {
        System.out.println("Error saat insert user: " + e.getMessage());
        throw e;
    }
    }
}
