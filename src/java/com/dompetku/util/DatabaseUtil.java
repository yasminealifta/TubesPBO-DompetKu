package com.dompetku.util;

import java.sql.*;

public class DatabaseUtil {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/dompetku?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver Registered!");
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver NOT found!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        System.out.println("Trying to connect to DB...");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }
}
